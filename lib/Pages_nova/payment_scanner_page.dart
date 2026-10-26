import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // only for openAppSettings()

import 'package:nova/Pages_nova/pay_after_scan.dart'; // defines PayMerchantPage
import 'package:nova/Pages_nova/pay_money_page.dart'; // defines SendMoneyPage

class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const infoCard = Color(0xFFE9F3D6);
  static const lime = Color(0xFFC8F560);
  static const border = Color(0xFFE3E6DC);
  static const scanCard = Color(0xFF262E28);
  static const scanFrame = Color(0xFF1C231E);
  static const scanText = Color(0xFFB9C1B6);
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  // ---- Static demo data ----
  static const String _myUpi = 'aarav@nova';
  static const String _balance = '₹3,680';

  // DEMO: tapping the camera frame jumps to the pay page.
  // Set to false when your backend is ready.
  static const bool _demoTapToPay = true;

  final MobileScannerController _camera = MobileScannerController(
    facing: CameraFacing.back,
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final ImagePicker _picker = ImagePicker();

  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  bool _handling = false; // true while picker / pay page is active

  // ---------- Camera: any QR -> pay page ----------
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final raw = capture.barcodes.firstOrNull?.rawValue ?? '';

    _handling = true;
    try {
      await _safeStop();
      HapticFeedback.mediumImpact();
      await _openPayment(raw);
    } finally {
      await _safeStart();
      // cooldown so the same QR doesn't instantly re-open the page
      await Future.delayed(const Duration(milliseconds: 1500));
      _handling = false;
    }
  }

  // ---------- Upload: ANY image -> pay page ----------
  Future<void> _pickFromGallery() async {
    if (_handling) return;
    _handling = true;
    try {
      await _safeStop();

      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) return; // user cancelled the picker

      // Try to read a real QR from the image. Never blocks:
      // if nothing is found (or it takes too long), demo data is used.
      String raw = '';
      try {
        final result = await _camera
            .analyzeImage(file.path, formats: const [BarcodeFormat.qrCode])
            .timeout(const Duration(seconds: 3));
        raw = result?.barcodes.firstOrNull?.rawValue ?? '';
      } catch (_) {}

      HapticFeedback.mediumImpact();
      await _openPayment(raw);
    } catch (_) {
      _snack('Could not open photos');
    } finally {
      await _safeStart();
      _handling = false;
    }
  }

  // ---------- Demo: tap the frame ----------
  Future<void> _demoPay() async {
    if (_handling) return;
    _handling = true;
    try {
      await _safeStop();
      await _openPayment('');
    } finally {
      await _safeStart();
      _handling = false;
    }
  }

  // ---------- Open pay page (no backend, no validation) ----------
  Future<void> _openPayment(String raw) async {
    // Demo defaults, used when the QR / image has no UPI data
    String name = 'Merchant';
    String upiId = 'merchant@nova';
    double? amount;

    final uri = Uri.tryParse(raw);
    if (uri != null && uri.scheme == 'upi') {
      final q = uri.queryParameters;
      if ((q['pa'] ?? '').isNotEmpty) upiId = q['pa']!;
      if ((q['pn'] ?? '').trim().isNotEmpty) name = q['pn']!;
      final am = double.tryParse(q['am'] ?? '');
      if (am != null && am > 0) amount = am;
    }

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PayMerchantPage(
          merchantName: name,
          upiId: upiId,
          fixedAmount: amount,
        ),
      ),
    );
  }

  Future<void> _safeStop() async {
    try {
      await _camera.stop();
    } catch (_) {}
  }

  Future<void> _safeStart() async {
    if (!mounted) return;
    try {
      await _camera.start();
    } catch (_) {}
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _camera.dispose();
    _scan.dispose();
    super.dispose();
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              const SizedBox(height: 22),
              _scannerCard(),
              const SizedBox(height: 20),
              _safetyCard(),
              const SizedBox(height: 28),
              const Text('Other ways to pay',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: _C.ink)),
              const SizedBox(height: 16),
              _uploadButton(),
              const SizedBox(height: 14),
              _enterUpiButton(),
              const SizedBox(height: 20),
              _myUpiCard(),
              const SizedBox(height: 22),
              const Text(
                'Paying from Available · $_balance',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _C.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _header() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.arrow_back, size: 22, color: _C.ink),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scan & pay',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Point, check, pay. Simple.',
                  style: TextStyle(fontSize: 13, color: _C.grey)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.more_horiz, size: 22, color: _C.ink),
        ),
      ],
    );
  }

  // ---------- Scanner card ----------
  Widget _scannerCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: _C.scanCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Text('Align a merchant QR inside the frame',
              style: TextStyle(fontSize: 12.5, color: _C.scanText)),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.72,
            child: AspectRatio(aspectRatio: 1, child: _scanFrame()),
          ),
          const SizedBox(height: 22),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _camera,
            builder: (_, state, __) {
              final on = state.torchState == TorchState.on;
              return GestureDetector(
                onTap: () async {
                  try {
                    await _camera.toggleTorch();
                  } catch (_) {}
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(on ? Icons.flashlight_on : Icons.flashlight_off,
                        size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(on ? 'Flash on' : 'Flash off',
                        style:
                            const TextStyle(fontSize: 13, color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _scanFrame() {
    return GestureDetector(
      onTap: _demoTapToPay ? _demoPay : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: _C.scanFrame,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Camera permission is requested by MobileScanner itself.
              MobileScanner(
                controller: _camera,
                onDetect: _onDetect,
                // (context, error, [child]) works on every mobile_scanner version
                placeholderBuilder: (context, [child]) => const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: _C.lime),
                  ),
                ),
                errorBuilder: (context, error, [child]) {
                  final denied =
                      error.errorCode == MobileScannerErrorCode.permissionDenied;
                  return _cameraMessage(
                    denied
                        ? 'Camera access is needed to scan QR codes'
                        : 'Camera unavailable',
                    denied ? 'Open settings' : 'Try again',
                    denied ? openAppSettings : _safeStart,
                  );
                },
              ),
              // Moving scan line
              IgnorePointer(
                child: AnimatedBuilder(
                  animation: _scan,
                  builder: (_, __) {
                    final t = Curves.easeInOut.transform(_scan.value);
                    return Align(
                      alignment: Alignment(0, -0.8 + 1.6 * t),
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: _C.lime,
                          boxShadow: [
                            BoxShadow(
                                color: _C.lime.withOpacity(0.5), blurRadius: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Corner brackets
              IgnorePointer(
                child: Positioned.fill(
                  child: CustomPaint(painter: _CornerPainter(_C.lime)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraMessage(String text, String action, VoidCallback onTap) {
    return Container(
      color: _C.scanFrame,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography_outlined,
              size: 30, color: _C.scanText),
          const SizedBox(height: 10),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11.5, color: _C.scanText)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onTap,
            child: Text(action,
                style: const TextStyle(
                    color: _C.lime, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ---------- Safety card ----------
  Widget _safetyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: _C.infoCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.verified_user_outlined, size: 20, color: _C.ink),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pay safely, every time',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _C.ink)),
                SizedBox(height: 4),
                Text(
                  'Check the merchant name and amount before confirming your payment.',
                  style: TextStyle(fontSize: 12, color: _C.grey, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Buttons ----------
  Widget _uploadButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: _pickFromGallery,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _C.ink,
          side: const BorderSide(color: _C.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 18),
            SizedBox(width: 10),
            Text('Upload a QR from photos',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _enterUpiButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SendMoneyPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          foregroundColor: _C.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.alternate_email, size: 18),
            SizedBox(width: 10),
            Text('Enter UPI ID',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------- My UPI ID ----------
  Widget _myUpiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _C.infoCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_2, size: 26, color: _C.ink),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your UPI ID',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _C.ink)),
                SizedBox(height: 3),
                Text(_myUpi, style: TextStyle(fontSize: 12, color: _C.grey)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: _myUpi));
              _snack('UPI ID copied');
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Text('Share',
                  style: TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w700, color: _C.ink)),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Corner brackets painter ----------
class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const len = 34.0, r = 18.0, w = 4.0, i = w / 2;
    final w_ = size.width, h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(i, len)
      ..lineTo(i, r)
      ..quadraticBezierTo(i, i, r, i)
      ..lineTo(len, i)
      ..moveTo(w_ - len, i)
      ..lineTo(w_ - r, i)
      ..quadraticBezierTo(w_ - i, i, w_ - i, r)
      ..lineTo(w_ - i, len)
      ..moveTo(w_ - i, h - len)
      ..lineTo(w_ - i, h - r)
      ..quadraticBezierTo(w_ - i, h - i, w_ - r, h - i)
      ..lineTo(w_ - len, h - i)
      ..moveTo(len, h - i)
      ..lineTo(r, h - i)
      ..quadraticBezierTo(i, h - i, i, h - r)
      ..lineTo(i, h - len);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}