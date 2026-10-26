import 'package:flutter/material.dart';
import 'package:nova/Pages_nova/reward_page.dart';


class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const walletCard = Color(0xFFE9F3D6);
  static const lime = Color(0xFFC8F560);
  static const green = Color(0xFF4F7A2B);

  static const mint = Color(0xFFE9F3D6);
}

// ---------- Goal model (static demo data) ----------
// Public (no underscore) so RewardsPage can use it too.
class SavingGoal {
  final String name;
  final String short; // used in sentences: "Add money to <short>"
  double saved;
  final double target;
  final IconData icon;
  final Color tint;
  final Color track;

  SavingGoal({
    required this.name,
    required this.short,
    required this.saved,
    required this.target,
    required this.icon,
    required this.tint,
    required this.track,
  });

  double get progress =>
      target == 0 ? 0 : (saved / target).clamp(0.0, 1.0).toDouble();
  int get percent => (progress * 100).round();
  double get remaining => (target - saved).clamp(0.0, target).toDouble();
  bool get done => saved >= target;
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  static const double _walletSavings = 600;
  static const double _weeklyAmount = 100;

  // Tints for goals created with "+ Add goal"
  static const _extraTints = [
    [Color(0xFFFBE6DC), Color(0xFFF2D3C4)],
    [Color(0xFFE9F3D6), Color(0xFFD7E6BC)],
    [Color(0xFFEAE7F7), Color(0xFFD9D4EE)],
  ];

  final List<SavingGoal> _goals = [
    SavingGoal(
      name: 'New headphones',
      short: 'headphones',
      saved: 2400,
      target: 4000,
      icon: Icons.headphones_outlined,
      tint: const Color(0xFFEAE7F7),
      track: const Color(0xFFD9D4EE),
    ),
    SavingGoal(
      name: 'Weekend adventure',
      short: 'weekend adventure',
      saved: 0,
      target: 1500,
      icon: Icons.terrain_outlined,
      tint: const Color(0xFFE2E9F7),
      track: const Color(0xFFD3DDF0),
    ),
  ];

  bool _autoSave = false;

  // First goal that is started but not finished
  SavingGoal? get _active {
    for (final g in _goals) {
      if (g.saved > 0 && !g.done) return g;
    }
    return null;
  }

  String get _autoTarget =>
      (_active ?? (_goals.isNotEmpty ? _goals.first : null))?.short ??
      'savings';

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

  // ---------- Actions ----------
  Future<void> _addMoney(SavingGoal g) async {
    final amount = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _AddMoneySheet(goalName: g.short, remaining: g.remaining),
    );
    if (amount == null || amount <= 0) return;
    setState(() => g.saved = (g.saved + amount).clamp(0.0, g.target).toDouble());
    _snack('Added ₹${_fmt(amount)} to ${g.short}');
  }

  Future<void> _addGoal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _AddGoalSheet(),
    );
    if (result == null) return;
    final name = result['name'] as String;
    final target = (result['target'] as int).toDouble();
    final tints = _extraTints[_goals.length % _extraTints.length];
    setState(() {
      _goals.add(SavingGoal(
        name: name,
        short: name.toLowerCase(),
        saved: 0,
        target: target,
        icon: Icons.savings_outlined,
        tint: tints[0],
        track: tints[1],
      ));
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final active = _active;

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
              _walletCard(),
              const SizedBox(height: 28),
              _sectionRow(),
              const SizedBox(height: 16),
              for (final g in _goals) ...[
                _goalCard(g),
                if (g.saved > 0 && !g.done) ...[
                  const SizedBox(height: 14),
                  _addMoneyButton(g),
                ],
                const SizedBox(height: 18),
              ],
              const SizedBox(height: 10),
              const Text('Make saving a habit',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500, color: _C.ink)),
              const SizedBox(height: 14),
              _autoSaveCard(),
              const SizedBox(height: 26),
              Text(
                active != null
                    ? 'Just ₹${_fmt(active.remaining)} more for your ${active.short}.\n'
                        "You're closer than you think."
                    : 'Pick a goal and start with a little.\n'
                        'Every save counts.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: _C.green, height: 1.5),
              ),
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
              Text('Your goals',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Big plans start with little saves.',
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

  // ---------- Wallet savings ----------
  Widget _walletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _C.walletCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current wallet savings',
              style: TextStyle(fontSize: 12.5, color: _C.grey)),
          const SizedBox(height: 8),
          Text('₹${_fmt(_walletSavings)}',
              style: const TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w400, color: _C.ink)),
          const SizedBox(height: 14),
          const Text(
            'Set aside this week. Your goal pots are tracked separately '
            'from this wallet balance.',
            style: TextStyle(fontSize: 12.5, color: _C.grey, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ---------- Section title + add goal ----------
  Widget _sectionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("What you're saving for",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: _C.ink)),
        InkWell(
          onTap: _addGoal,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Text('+ Add goal',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _C.green)),
          ),
        ),
      ],
    );
  }

  // ---------- Goal card ----------
  Widget _goalCard(SavingGoal g) {
    final started = g.saved > 0;
    final subtitle = g.done
        ? 'Goal reached 🎉'
        : started
            ? 'Your goal · ₹${_fmt(g.remaining)} to go'
            : "New goal · Start whenever you're ready";

    return GestureDetector(
      onTap: (!started && !g.done)
          ? () => _addMoney(g) // no money yet -> add money first
          : () async {
              // has money (or finished) -> open that goal's page, passing g
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RewardsPage(goal: g)),
              );
              if (mounted) setState(() {}); // refresh card after coming back
            },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: g.tint,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(g.icon, size: 24, color: _C.ink),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _C.ink)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style:
                              const TextStyle(fontSize: 12, color: _C.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${_fmt(g.saved)} / ₹${_fmt(g.target)}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _C.ink)),
                Text('${g.percent}% saved',
                    style: const TextStyle(fontSize: 12, color: _C.grey)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: g.progress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 8,
                  backgroundColor: g.track,
                  valueColor: const AlwaysStoppedAnimation(_C.ink),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMoneyButton(SavingGoal g) {
    return SizedBox(
      height: 58,
      child: ElevatedButton(
        onPressed: () => _addMoney(g),
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          foregroundColor: _C.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text('Add money to ${g.short}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Weekly auto-save ----------
  Widget _autoSaveCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _C.mint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.repeat, size: 22, color: _C.ink),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weekly auto-save',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _C.ink)),
                    const SizedBox(height: 3),
                    Text(
                        '₹${_fmt(_weeklyAmount)} every Monday to $_autoTarget',
                        style: const TextStyle(fontSize: 12, color: _C.grey)),
                  ],
                ),
              ),
              Switch(
                value: _autoSave,
                onChanged: (v) => setState(() => _autoSave = v),
                thumbColor: const WidgetStatePropertyAll(Colors.white),
                trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return _C.green;
                  return const Color(0xFFD9DDD0);
                }),
                trackOutlineColor:
                    const WidgetStatePropertyAll(Colors.transparent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _autoSave
                ? 'On. ₹${_fmt(_weeklyAmount)} moves to your $_autoTarget '
                    'every Monday.'
                : 'Off for now. Turn it on to keep your goal moving without '
                    'thinking about it.',
            style: const TextStyle(fontSize: 12.5, color: _C.grey, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Bottom sheet: add money to a goal
// =====================================================================
class _AddMoneySheet extends StatefulWidget {
  final String goalName;
  final double remaining;
  const _AddMoneySheet({required this.goalName, required this.remaining});

  @override
  State<_AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<_AddMoneySheet> {
  static const _chips = [100, 250, 500];
  int _amount = 100;
  final _field = TextEditingController(text: '100');

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _setAmount(int v) {
    setState(() => _amount = v);
    _field.text = v.toString();
    _field.selection = TextSelection.collapsed(offset: _field.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final valid = _amount > 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add money to ${widget.goalName}',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: _C.ink)),
          const SizedBox(height: 4),
          Text('₹${widget.remaining.toInt()} left to reach this goal',
              style: const TextStyle(fontSize: 13, color: _C.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < _chips.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setAmount(_chips[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _amount == _chips[i] ? _C.lime : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text('₹${_chips[i]}',
                          style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: _amount == _chips[i]
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: _C.ink)),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('₹', style: TextStyle(fontSize: 18, color: _C.ink)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _field,
                    keyboardType: TextInputType.number,
                    onChanged: (v) =>
                        setState(() => _amount = int.tryParse(v) ?? 0),
                    style: const TextStyle(fontSize: 16, color: _C.ink),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Custom amount',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: valid ? () => Navigator.pop(context, _amount) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.lime,
                disabledBackgroundColor: _C.lime.withValues(alpha: 0.5),
                foregroundColor: _C.ink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: Text(valid ? 'Add ₹$_amount' : 'Enter an amount',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// Bottom sheet: create a new goal
// =====================================================================
class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _name = TextEditingController();
  final _target = TextEditingController();

  bool get _valid =>
      _name.text.trim().isNotEmpty && (int.tryParse(_target.text) ?? 0) > 0;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  Widget _field(TextEditingController c, String hint,
      {TextInputType? type, String? prefix}) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (prefix != null) ...[
            Text(prefix, style: const TextStyle(fontSize: 18, color: _C.ink)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              controller: c,
              keyboardType: type,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 16, color: _C.ink),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('New goal',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: _C.ink)),
          const SizedBox(height: 4),
          const Text('What are you saving for?',
              style: TextStyle(fontSize: 13, color: _C.grey)),
          const SizedBox(height: 20),
          _field(_name, 'Goal name (e.g. New sneakers)'),
          const SizedBox(height: 12),
          _field(_target, 'Target amount',
              type: TextInputType.number, prefix: '₹'),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _valid
                  ? () => Navigator.pop(context, {
                        'name': _name.text.trim(),
                        'target': int.parse(_target.text),
                      })
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.lime,
                disabledBackgroundColor: _C.lime.withValues(alpha: 0.5),
                foregroundColor: _C.ink,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Create goal',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}