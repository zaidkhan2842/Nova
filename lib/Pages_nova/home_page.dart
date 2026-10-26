import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova/Pages_nova/Goal_page.dart';
import 'package:nova/Pages_nova/check_history.dart';
import 'package:nova/Pages_nova/pay_money_page.dart';
import 'package:nova/Pages_nova/payment_scanner_page.dart';
import 'package:nova/Pages_nova/request_page.dart';

import '../Nova_theme/nove_theme.dart';

// ---------------------------------------------------------------------------
// Extra colors used only on the home page
// ---------------------------------------------------------------------------
const _cardDark = Color(0xFF262B27);
const _goalBg = Color(0xFFEBE8F6);
const _goalTrack = Color(0xFFD9D5EC);
const _goalFill = Color(0xFF1B1F1C);
const _weekBg = Color(0xFFEAF4D9);
const _greenText = Color(0xFF3C8A2E);

const _availableBg = Color(0xFFE8F3D2);
const _savingBg = Color(0xFFE9E7F7);

TextStyle _ts(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// 4280 -> ₹4,280   |   4280 (decimals) -> ₹4,280.00   (Indian grouping)
String _rupee(double v, {bool decimals = false}) {
  final fixed = v.abs().toStringAsFixed(decimals ? 2 : 0);
  final parts = fixed.split('.');
  String whole = parts[0];
  if (whole.length > 3) {
    final last3 = whole.substring(whole.length - 3);
    var rest = whole.substring(0, whole.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    whole = '${groups.join(',')},$last3';
  }
  return '₹$whole${decimals ? '.${parts[1]}' : ''}';
}

/// One row in "Recent activity". amount < 0 = spent, amount > 0 = received.
class _Txn {
  final String emoji;
  final Color bg;
  final String title;
  final String subtitle;
  final double amount;

  const _Txn({
    required this.emoji,
    required this.bg,
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -------------------------------------------------------------------------
  // DEMO DATA  (this is what the API will fill later)
  // -------------------------------------------------------------------------
  String _userName = 'Aarav';

  double _totalMoney = 4280;
  double _available = 3680;
  double _saving = 600;

  String _cardLast4 = '4821';
  String _cardHolder = 'AARAV';
  String _cardExpiry = '09/29';

  String _goalEmoji = '🎧';
  String _goalTitle = 'New headphones';
  double _goalSaved = 2400;
  double _goalTarget = 4000;

  double _spentThisWeek = 920;
  double _savedThisWeek = 600;
  String _weekMessage = 'You spent less than last week 🎉';

  List<_Txn> _recent = const [
    _Txn(
      emoji: '☕',
      bg: Color(0xFFFCE8DC),
      title: 'Starbucks',
      subtitle: 'Today · Food & drinks',
      amount: -180,
    ),
    _Txn(
      emoji: '😊',
      bg: Color(0xFFE6F2CF),
      title: 'Dad',
      subtitle: 'Yesterday · Money received',
      amount: 1000,
    ),
    _Txn(
      emoji: '🎮',
      bg: Color(0xFFE4E8F8),
      title: 'Steam',
      subtitle: 'Yesterday · Gaming',
      amount: -499,
    ),
  ];

  

  // bool _loading = true;

  // -------------------------------------------------------------------------
  // API CALLS - commented out for now. The screen uses the demo data above.
  // To enable: add `http` in pubspec.yaml, uncomment this block and the
  // imports below, set your baseUrl, and uncomment `_loadHomeData()` in
  // initState().
  // -------------------------------------------------------------------------
  // import 'dart:convert';
  // import 'package:http/http.dart' as http;
  //
  // const String baseUrl = 'https://your-api.com';
  //
  // Future<void> _loadHomeData() async {
  //   try {
  //     // headers: {'Authorization': 'Bearer $token'}
  //     final responses = await Future.wait([
  //       http.get(Uri.parse('$baseUrl/user/profile')),          // name
  //       http.get(Uri.parse('$baseUrl/wallet/summary')),        // total, available, saving
  //       http.get(Uri.parse('$baseUrl/card')),                  // last4, holder, expiry
  //       http.get(Uri.parse('$baseUrl/goals/active')),          // goal card
  //       http.get(Uri.parse('$baseUrl/insights/week')),         // spent, saved, message
  //       http.get(Uri.parse('$baseUrl/transactions?limit=3')),  // recent activity
  //     ]);
  //
  //     final profile = jsonDecode(responses[0].body);
  //     final wallet  = jsonDecode(responses[1].body);
  //     final card    = jsonDecode(responses[2].body);
  //     final goal    = jsonDecode(responses[3].body);
  //     final week    = jsonDecode(responses[4].body);
  //     final txns    = jsonDecode(responses[5].body) as List;
  //
  //     if (!mounted) return;
  //     setState(() {
  //       _userName = profile['name'];
  //
  //       _totalMoney = (wallet['total'] as num).toDouble();
  //       _available  = (wallet['available'] as num).toDouble();
  //       _saving     = (wallet['saving'] as num).toDouble();
  //
  //       _cardLast4  = card['last4'];
  //       _cardHolder = card['holder'];
  //       _cardExpiry = card['expiry'];
  //
  //       _goalEmoji  = goal['emoji'];
  //       _goalTitle  = goal['title'];
  //       _goalSaved  = (goal['saved'] as num).toDouble();
  //       _goalTarget = (goal['target'] as num).toDouble();
  //
  //       _spentThisWeek = (week['spent'] as num).toDouble();
  //       _savedThisWeek = (week['saved'] as num).toDouble();
  //       _weekMessage   = week['message'];
  //
  //       _recent = txns.map((t) => _Txn(
  //             emoji: t['emoji'],
  //             bg: Color(int.parse(t['bgColor'])),
  //             title: t['title'],
  //             subtitle: t['subtitle'],
  //             amount: (t['amount'] as num).toDouble(),
  //           )).toList();
  //
  //       // _loading = false;
  //     });
  //   } catch (e) {
  //     // show an error / snackbar here
  //     debugPrint('Home API error: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _loadHomeData(); // <- uncomment when the API is ready
  }

  // -------------------------------------------------------------------------
  // BUILD
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovaColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 18),
              _moneySection(),
              const SizedBox(height: 16),
              _card(),
              const SizedBox(height: 16),
              _actions(),
              const SizedBox(height: 26),
              _goals(),
              const SizedBox(height: 24),
              _thisWeek(),
              const SizedBox(height: 24),
              _recentActivity(),
            ],
          ),
        ),
      ),
      
    );
  }

  // ---- Header -------------------------------------------------------------
  Widget _header() {
    final initial = _userName.isNotEmpty ? _userName[0].toUpperCase() : '?';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning, $_userName',
                  style: _ts(18, FontWeight.w700, NovaColors.navy)),
              const SizedBox(height: 2),
              Text('A little progress, every day.',
                  style: _ts(12, FontWeight.w500, NovaColors.slate)),
            ],
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: NovaColors.lime,
          child: Text(initial, style: _ts(15, FontWeight.w600, NovaColors.navy)),
        ),
      ],
    );
  }

  // ---- Your money ---------------------------------------------------------
  Widget _moneySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your money', style: _ts(12, FontWeight.w500, NovaColors.slate)),
        const SizedBox(height: 2),
        Text(
          _rupee(_totalMoney, decimals: true),
          style: _ts(34, FontWeight.w800, NovaColors.navy, letterSpacing: -1),
        ),
        const SizedBox(height: 12),
       Row(
  children: [
    Expanded(
      child: _miniStat(
        _availableBg,
        'Available',
        _rupee(_available),
        _Img('assets/images/home_page1.png', width: 34, height: 34),
      ),
    ),
    Container(width: 1, height: 34, color: Colors.black12),
    const SizedBox(width: 16),
    Expanded(
      child: _miniStat(
        _savingBg,
        'Saving',
        _rupee(_saving),
        _Img('assets/images/home_page2.png', width: 34, height: 34),
      ),
    ),
  ],
)
      ],
    );
  }

  Widget _miniStat( Color bg, String label, String value, dynamic image) {
    return Row(
      children: [
        Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: image,
      ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _ts(11, FontWeight.w500, NovaColors.slate)),
            Text(value, style: _ts(15, FontWeight.w700, NovaColors.navy)),
          ],
        ),
      ],
    );
  }

  // ---- Debit card ---------------------------------------------------------
  Widget _card() {
    return AspectRatio(
      aspectRatio: 2.05,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: _cardDark,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // decorative circles (top right)
              Positioned(
                right: -70,
                top: -50,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(12),
                  ),
                ),
              ),
              Positioned(
                right: -35,
                top: -15,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(30)),
                  ),
                ),
              ),

              // card content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // top: tag + contactless
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Card',
                                style: _ts(10, FontWeight.w600, Colors.white70)),
                          ),
                          const Icon(Icons.contactless_outlined,
                              color: NovaColors.lime, size: 22),
                        ],
                      ),

                      // middle: chip + •••• 4821
                      Row(
                        children: [
                          const Icon(Icons.sim_card_outlined,
                              color: Colors.white54, size: 24),
                          const SizedBox(width: 14),
                          ...List.generate(
                            4,
                            (_) => Container(
                              width: 9,
                              height: 9,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(_cardLast4,
                              style: _ts(17, FontWeight.w700, Colors.white,
                                  letterSpacing: 0.5)),
                        ],
                      ),

                      // bottom: holder, expiry, logo circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_cardHolder,
                              style: _ts(11, FontWeight.w600, Colors.white70,
                                  letterSpacing: 0.5)),
                          Text(_cardExpiry,
                              style: _ts(11, FontWeight.w600, Colors.white70)),
                          SizedBox(
                            width: 36,
                            height: 22,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      color: NovaColors.lime,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(150),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Send / Request / Scan ---------------------------------------------
  Widget _actions() {
  return Row(
    children: [
      Expanded(child: _actionPill(Icons.north_east, 'Send', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SendMoneyPage()),
        );
      })),
      const SizedBox(width: 12),
      Expanded(child: _actionPill(Icons.south_west, 'Request', () {
         Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RequestMoneyPage()),
        );
      })),
      const SizedBox(width: 12),
      Expanded(child: _actionPill(Icons.qr_code_scanner, 'Scan', () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScanPage()),
        );
      })),
    ],
  );
}

  Widget _actionPill(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: NovaColors.lime,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: NovaColors.navy),
              const SizedBox(width: 6),
              Text(label, style: _ts(13, FontWeight.w700, NovaColors.navy)),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Section title with arrow ------------------------------------------
  Widget _sectionTitle(String title, {VoidCallback? onArrowTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: _ts(15, FontWeight.w700, NovaColors.navy)),
          if (onArrowTap != null)
            GestureDetector(
              onTap: onArrowTap,
              child: const Icon(Icons.north_east,
                  size: 16, color: NovaColors.navy),
            ),
        ],
      ),
    );
  }

  // ---- Your goals ---------------------------------------------------------
  Widget _goals() {
    final progress = _goalTarget == 0 ? 0.0 : (_goalSaved / _goalTarget);
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Your goals', onArrowTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GoalsPage()),
              );
        }),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _goalBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_goalEmoji $_goalTitle',
                  style: _ts(14, FontWeight.w700, NovaColors.navy)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_rupee(_goalSaved)} / ${_rupee(_goalTarget)}',
                      style: _ts(12, FontWeight.w600, NovaColors.navy)),
                  Text('$percent% saved',
                      style: _ts(12, FontWeight.w500, NovaColors.slate)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 7,
                  backgroundColor: _goalTrack,
                  valueColor: const AlwaysStoppedAnimation(_goalFill),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- This week ----------------------------------------------------------
  Widget _thisWeek() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('This week'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _weekBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _weekStat('Spent', _rupee(_spentThisWeek))),
                  Expanded(child: _weekStat('Saved', _rupee(_savedThisWeek))),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: NovaColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.trending_down,
                        size: 16, color: NovaColors.navy),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(_weekMessage,
                          style: _ts(12, FontWeight.w500, NovaColors.navy,
                              height: 1.3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _ts(12, FontWeight.w500, NovaColors.slate)),
        const SizedBox(height: 2),
        Text(value,
            style: _ts(24, FontWeight.w800, NovaColors.navy, letterSpacing: -0.5)),
      ],
    );
  }

  // ---- Recent activity ----------------------------------------------------
  Widget _recentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Recent activity', onArrowTap: () {
           Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransactionsPage()),
        );
        }),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: _recent.map(_txnRow).toList(),
          ),
        ),
      ],
    );
  }

  Widget _txnRow(_Txn t) {
    final received = t.amount > 0;
    final sign = received ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(t.emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: _ts(14, FontWeight.w700, NovaColors.navy)),
                const SizedBox(height: 2),
                Text(t.subtitle,
                    style: _ts(11, FontWeight.w500, NovaColors.slate)),
              ],
            ),
          ),
          Text(
            '$sign${_rupee(t.amount)}',
            style: _ts(14, FontWeight.w700,
                received ? _greenText : NovaColors.navy),
          ),
        ],
      ),
    );
  }

  // ---- Bottom navigation --------------------------------------------------
  
}


class _Img extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _Img(this.path, {this.width, this.height}) : fit = BoxFit.contain;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width ?? 60,
        height: height ?? 60,
        color: Colors.black12,
        child: const Icon(Icons.image_not_supported_outlined, size: 20),
      ),
    );
  }
}