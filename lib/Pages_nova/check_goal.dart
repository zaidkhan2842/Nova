import 'package:flutter/material.dart';
import 'package:nova/Pages_nova/spending_page.dart';
//import 'package:nova/Pages_nova/transactions_page.dart';

class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const lime = Color(0xFFC8F560);
  static const green = Color(0xFF4F7A2B);
  static const mint = Color(0xFFE9F3D6);
  static const challenge = Color(0xFFEAE7F7);
  static const challengeTrack = Color(0xFFD9D4EE);
  static const lavender = Color(0xFFE6E4F4);
}

class _Step {
  final String title;
  final String sub;
  final bool done;
  const _Step(this.title, this.sub, this.done);
}

class MoneyMissionPage extends StatelessWidget {
  const MoneyMissionPage({super.key});

  // ---- Static demo data ----
  static const double _limit = 1200; // weekly spending limit
  static const double _spent = 920; // spent this week
  static const double _saveGoal = 500; // weekly saving target
  static const double _saved = 600; // saved this week
  static const bool _reviewed = true; // checked activity this week
  static const String _endsOn = 'Ends Sun, 11 Oct';
  static const int _xp = 240;
  static const int _xpToNext = 60;

  // 3680 -> 3,680 | 125000 -> 1,25,000 (Indian grouping)
  String _fmt(num n) {
    final s = n.toInt().toString();
    if (s.length <= 3) return s;
    final last3 = s.substring(s.length - 3);
    var rest = s.substring(0, s.length - 3);
    final buf = <String>[];
    while (rest.length > 2) {
      buf.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) buf.insert(0, rest);
    return '${buf.join(',')},$last3';
  }

  List<_Step> get _steps => [
        const _Step('Review your spending',
            'Checked your activity this week', _reviewed),
        _Step(
          'Save at least ₹${_fmt(_saveGoal)}',
          '₹${_fmt(_saved)} saved this week. Nice work!',
          _saved >= _saveGoal,
        ),
        // Stays "in progress" until the week ends
        _Step(
          'Finish under ₹${_fmt(_limit)}',
          '₹${_fmt(_spent)} spent · ₹${_fmt(_limit - _spent)} left this week',
          false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    final doneCount = steps.where((s) => s.done).length;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              const SizedBox(height: 22),
              _challengeCard(doneCount, steps.length),
              const SizedBox(height: 28),
              const Text('Your mission checklist',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: _C.ink)),
              const SizedBox(height: 14),
              _checklistCard(steps),
              const SizedBox(height: 22),
              _rewardCard(),
              const SizedBox(height: 18),
              _reviewButton(context),
              const SizedBox(height: 18),
              _levelCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _header(BuildContext context) {
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
              Text('Money Mission',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Small habits. Real-life superpowers.',
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

  // ---------- Weekly challenge ----------
  Widget _challengeCard(int done, int total) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _C.challenge,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('WEEKLY CHALLENGE',
                    style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: _C.green)),
              ),
              const Icon(Icons.emoji_events_outlined, size: 28, color: _C.ink),
            ],
          ),
          const SizedBox(height: 22),
          const Text('The mindful\nspender',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: _C.ink,
                  height: 1.15)),
          const SizedBox(height: 18),
          Text(
            'Stay within ₹${_fmt(_limit)} this week and save at least '
            '₹${_fmt(_saveGoal)}. Every mindful choice counts.',
            style: const TextStyle(fontSize: 14, color: _C.ink, height: 1.45),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$done of $total steps complete',
                  style: const TextStyle(fontSize: 12.5, color: _C.ink)),
              const Text(_endsOn,
                  style: TextStyle(fontSize: 12, color: _C.grey)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: total == 0 ? 0 : done / total),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                backgroundColor: _C.challengeTrack,
                valueColor: const AlwaysStoppedAnimation(_C.ink),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Checklist ----------
  Widget _checklistCard(List<_Step> steps) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            _stepRow(steps[i]),
          ],
        ],
      ),
    );
  }

  Widget _stepRow(_Step s) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: s.done ? _C.mint : _C.lavender,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            s.done ? Icons.check_circle_outline : Icons.schedule,
            size: 22,
            color: _C.ink,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: _C.ink)),
              const SizedBox(height: 3),
              Text(s.sub,
                  style: const TextStyle(fontSize: 12, color: _C.grey)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(s.done ? 'Done' : 'In progress',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: s.done ? _C.green : _C.ink)),
      ],
    );
  }

  // ---------- Reward ----------
  Widget _rewardCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: _C.mint,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome_outlined, size: 22, color: _C.ink),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your reward',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _C.ink)),
                SizedBox(height: 4),
                Text(
                  'Earn 100 XP + the Mindful Spender badge when all three '
                  'steps are complete.',
                  style: TextStyle(fontSize: 12, color: _C.grey, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Review button ----------
  Widget _reviewButton(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SpendingInsightsPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          foregroundColor: _C.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, size: 18),
            SizedBox(width: 10),
            Text('Review my spending',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------- Level ----------
  Widget _levelCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Level 2 · Money Explorer',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: _C.ink)),
          const SizedBox(height: 10),
          Text('$_xp XP earned · $_xpToNext XP to the next level',
              style: const TextStyle(fontSize: 12.5, color: _C.grey)),
        ],
      ),
    );
  }
}