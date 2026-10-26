import 'package:flutter/material.dart';

class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const friendCard = Color(0xFFE9F3D6);
  static const lime = Color(0xFFC8F560);
  static const green = Color(0xFF4F7A2B);
}

class PayMerchantPage extends StatefulWidget {
  final String merchantName;
  final String upiId;

  /// If the QR already contains an amount, pass it here.
  /// The amount is then locked and the keypad is hidden.
  final double? fixedAmount;

  const PayMerchantPage({
    super.key,
    required this.merchantName,
    required this.upiId,
    this.fixedAmount,
  });

  @override
  State<PayMerchantPage> createState() => _PayMerchantPageState();
}

class _PayMerchantPageState extends State<PayMerchantPage> {
  // ---- Static demo data ----
  static const double _balance = 3680;

  late String _amount;
  final _noteController = TextEditingController();

  bool get _locked => widget.fixedAmount != null;
  double get _value => double.tryParse(_amount) ?? 0;
  bool get _canPay => _value > 0 && _value <= _balance;

  @override
  void initState() {
    super.initState();
    _amount = _locked ? _trim(widget.fixedAmount!) : '0';
  }

  String _trim(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  // ---- Keypad logic ----
  void _onKey(String key) {
    if (_locked) return;
    setState(() {
      if (key == 'back') {
        _amount = _amount.length <= 1 ? '0' : _amount.substring(0, _amount.length - 1);
        return;
      }
      if (key == '.') {
        if (!_amount.contains('.')) _amount += '.';
        return;
      }
      if (_amount.contains('.') && _amount.split('.')[1].length >= 2) return;
      if (_amount.replaceAll('.', '').length >= 7) return;
      _amount = _amount == '0' ? key : _amount + key;
    });
  }

  // 3680 -> 3,680 | 125000 -> 1,25,000 (Indian grouping)
  String _fmt(num n) {
    final isInt = n == n.roundToDouble();
    final parts = (isInt ? n.toInt().toString() : n.toStringAsFixed(2)).split('.');
    String s = parts[0];
    if (s.length > 3) {
      final last3 = s.substring(s.length - 3);
      var rest = s.substring(0, s.length - 3);
      final buf = <String>[];
      while (rest.length > 2) {
        buf.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) buf.insert(0, rest);
      s = '${buf.join(',')},$last3';
    }
    return parts.length > 1 ? '$s.${parts[1]}' : s;
  }

  // ---- Pay (static, no API) ----
  Future<void> _pay() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: _C.bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                    color: _C.lime, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 34, color: _C.ink),
              ),
              const SizedBox(height: 18),
              const Text('Payment successful',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: _C.ink)),
              const SizedBox(height: 8),
              Text('₹${_fmt(_value)} paid to ${widget.merchantName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: _C.grey)),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                    ..pop() // close dialog
                    ..popUntil((r) => r.isFirst), // back to home
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.lime,
                    foregroundColor: _C.ink,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('Done',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 28),
              _label('Paying to'),
              const SizedBox(height: 10),
              _merchantTile(),
              const SizedBox(height: 40),
              _amountSection(),
              const SizedBox(height: 36),
              _label('Note (optional)'),
              const SizedBox(height: 10),
              _noteField(),
              if (!_locked) ...[
                const SizedBox(height: 20),
                _keypad(),
              ],
              const SizedBox(height: 20),
              _feeCard(),
              const SizedBox(height: 28),
              _payButton(),
              const SizedBox(height: 16),
              const Text(
                "You'll confirm securely before money leaves.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _C.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) =>
      Text(t, style: const TextStyle(fontSize: 12, color: _C.grey));

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
              Text('Pay merchant',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Scanned just now. Review and pay.',
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

  // ---------- Scanned merchant ----------
  Widget _merchantTile() {
    final initial = widget.merchantName.trim().isEmpty
        ? '?'
        : widget.merchantName.trim()[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: _C.friendCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Text(initial,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600, color: _C.ink)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.merchantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _C.ink)),
                const SizedBox(height: 3),
                Text('${widget.upiId} · Merchant',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _C.grey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code_2, size: 18, color: _C.ink),
              SizedBox(width: 4),
              Text('Scanned',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _C.ink)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Amount ----------
  Widget _amountSection() {
    return Column(
      children: [
        _label(_locked ? 'Amount to pay' : "You're paying"),
        const SizedBox(height: 10),
        Text(
          '₹${_amount.contains('.') ? _amount : _fmt(_value)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.w300, color: _C.ink, height: 1.1),
        ),
        const SizedBox(height: 12),
        Text('Available balance ₹${_fmt(_balance)}',
            style: const TextStyle(fontSize: 12.5, color: _C.grey)),
      ],
    );
  }

  // ---------- Note ----------
  Widget _noteField() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              style: const TextStyle(fontSize: 15, color: _C.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Add a note',
              ),
            ),
          ),
          const Icon(Icons.edit_outlined, size: 20, color: _C.ink),
        ],
      ),
    );
  }

  // ---------- Keypad ----------
  Widget _keypad() {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', 'back'],
    ];
    return Column(
      children: rows
          .map((r) => Row(
                children: r.map((k) => Expanded(child: _key(k))).toList(),
              ))
          .toList(),
    );
  }

  Widget _key(String k) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _onKey(k),
      child: SizedBox(
        height: 68,
        child: Center(
          child: k == 'back'
              ? const Icon(Icons.backspace_outlined, size: 24, color: _C.ink)
              : Text(k,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w400, color: _C.ink)),
        ),
      ),
    );
  }

  // ---------- Fee ----------
  Widget _feeCard() {
    final after = _balance - _value;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transfer fee',
                  style: TextStyle(fontSize: 13, color: _C.grey)),
              Text('Free',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: _C.green)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            after >= 0
                ? '₹${_fmt(after)} available after this payment.'
                : 'Amount exceeds your available balance.',
            style: TextStyle(
                fontSize: 12.5, color: after >= 0 ? _C.grey : Colors.redAccent),
          ),
        ],
      ),
    );
  }

  // ---------- Pay button ----------
  Widget _payButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _canPay ? _pay : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          disabledBackgroundColor: _C.lime.withOpacity(0.5),
          foregroundColor: _C.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.north_east, size: 18),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Pay ₹${_fmt(_value)} to ${widget.merchantName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}