import 'package:flutter/material.dart';

class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const summary = Color(0xFFE9F3D6);
  static const green = Color(0xFF4F7A2B);
  static const tabTrack = Color(0xFFE4E8DB);
  static const border = Color(0xFFE3E6DC);
  static const savedCard = Color(0xFFE9E6F6);
  static const peach = Color(0xFFFBE6DC);
  static const mint = Color(0xFFE9F3D6);
  static const sky = Color(0xFFE1E8F6);
  static const lavender = Color(0xFFE6E4F4);
}

// ---------- Static demo data ----------
class _Txn {
  final String title;
  final String sub;
  final double amount; // negative = spent, positive = received
  final IconData? icon;
  final String? letter;
  final Color tint;
  final bool inWeek; // false = only shows in "This month"

  const _Txn({
    required this.title,
    required this.sub,
    required this.amount,
    this.icon,
    this.letter,
    required this.tint,
    this.inWeek = true,
  });
}

const List<_Txn> _allTxns = [
  _Txn(
      title: 'Starbucks',
      sub: 'Today · Food & drinks',
      amount: -180,
      icon: Icons.local_cafe_outlined,
      tint: _C.peach),
  _Txn(
      title: 'Dad',
      sub: 'Yesterday · Money received',
      amount: 1000,
      letter: 'D',
      tint: _C.mint),
  _Txn(
      title: 'Steam',
      sub: 'Yesterday · Gaming',
      amount: -499,
      icon: Icons.sports_esports_outlined,
      tint: _C.sky),
  _Txn(
      title: 'Metro',
      sub: 'Mon, 5 Oct · Transport',
      amount: -141,
      icon: Icons.directions_subway_outlined,
      tint: _C.lavender),
  _Txn(
      title: 'School canteen',
      sub: 'Mon, 5 Oct · Food & drinks',
      amount: -100,
      icon: Icons.lunch_dining_outlined,
      tint: _C.peach),
  // Older: only visible in "This month" / "Custom"
  _Txn(
      title: 'Zomato',
      sub: 'Sat, 3 Oct · Food & drinks',
      amount: -320,
      icon: Icons.delivery_dining_outlined,
      tint: _C.peach,
      inWeek: false),
  _Txn(
      title: 'Mom',
      sub: 'Thu, 1 Oct · Money received',
      amount: 500,
      letter: 'M',
      tint: _C.mint,
      inWeek: false),
  _Txn(
      title: 'Electricity bill',
      sub: 'Thu, 1 Oct · Bills',
      amount: -640,
      icon: Icons.bolt_outlined,
      tint: _C.sky,
      inWeek: false),
];

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];

  int _period = 0; // 0 week, 1 month, 2 custom
  int _type = 0; // 0 all, 1 spent, 2 received
  int _sort = 0; // 0 newest first, 1 highest amount
  DateTimeRange? _range;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ---------- Data helpers ----------
  List<_Txn> get _periodTxns =>
      _period == 0 ? _allTxns.where((t) => t.inWeek).toList() : _allTxns;

  double get _spent => _periodTxns
      .where((t) => t.amount < 0)
      .fold(0.0, (s, t) => s + t.amount.abs());

  double get _received => _periodTxns
      .where((t) => t.amount > 0)
      .fold(0.0, (s, t) => s + t.amount);

  double get _saved => _period == 0 ? 600 : 1800;

  List<_Txn> get _visible {
    final q = _search.text.trim().toLowerCase();
    var list = _periodTxns.where((t) {
      if (_type == 1 && t.amount >= 0) return false;
      if (_type == 2 && t.amount <= 0) return false;
      if (q.isEmpty) return true;
      return t.title.toLowerCase().contains(q) ||
          t.amount.abs().toInt().toString().contains(q);
    }).toList();
    if (_sort == 1) {
      list.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
    }
    return list;
  }

  String get _dateLabel {
    if (_period == 0) return '5–11 October';
    if (_period == 1) return '1–31 October';
    final r = _range;
    if (r == null) return 'Pick a date range';
    final s = r.start, e = r.end;
    if (s.month == e.month && s.year == e.year) {
      return '${s.day}–${e.day} ${_months[s.month - 1]}';
    }
    return '${s.day} ${_months[s.month - 1].substring(0, 3)} – '
        '${e.day} ${_months[e.month - 1].substring(0, 3)}';
  }

  String get _periodWord =>
      _period == 0 ? 'week' : (_period == 1 ? 'month' : 'range');

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

  Future<void> _onPeriod(int i) async {
    if (i == 2) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2025),
        lastDate: DateTime.now(),
        initialDateRange: _range,
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _C.green,
              onPrimary: Colors.white,
              surface: _C.bg,
              onSurface: _C.ink,
            ),
          ),
          child: child!,
        ),
      );
      if (picked == null) return;
      setState(() {
        _range = picked;
        _period = 2;
      });
      return;
    }
    setState(() => _period = i);
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final items = _visible;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 22),
                _pillTabs(['This week', 'This month', 'Custom'], _period,
                    _onPeriod),
                const SizedBox(height: 18),
                _summaryCard(),
                const SizedBox(height: 26),
                _label('Search activity'),
                const SizedBox(height: 10),
                _searchField(),
                const SizedBox(height: 18),
                _pillTabs(['All', 'Spent', 'Received'], _type,
                    (i) => setState(() => _type = i)),
                const SizedBox(height: 22),
                _dateRow(),
                const SizedBox(height: 14),
                _listCard(items),
                const SizedBox(height: 18),
                _savedCard(),
                const SizedBox(height: 18),
                _downloadButton(),
                const SizedBox(height: 18),
                Text(
                  "You've reached the start of this $_periodWord.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: _C.grey),
                ),
              ],
            ),
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
              Text('Transactions',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Every little move, in one place.',
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

  // ---------- Pill tabs (used twice) ----------
  Widget _pillTabs(
      List<String> labels, int selected, ValueChanged<int> onTap) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _C.tabTrack,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == i ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(labels[i],
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight:
                              selected == i ? FontWeight.w600 : FontWeight.w400,
                          color: selected == i ? _C.ink : _C.grey)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- Summary ----------
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _C.summary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _summaryStat('Spent', '₹${_fmt(_spent)}')),
              Expanded(child: _summaryStat('Received', '₹${_fmt(_received)}')),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _period == 0
                ? 'You spent less than last week 🎉'
                : 'Here is your activity at a glance',
            style: const TextStyle(fontSize: 12.5, color: _C.grey),
          ),
        ],
      ),
    );
  }

  Widget _summaryStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, color: _C.grey)),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w400, color: _C.ink)),
      ],
    );
  }

  // ---------- Search ----------
  Widget _searchField() {
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
              controller: _search,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 15, color: _C.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Merchant, person or amount',
                hintStyle: TextStyle(fontSize: 15, color: _C.ink),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _search.text.isEmpty
              ? const Icon(Icons.search, size: 22, color: _C.ink)
              : GestureDetector(
                  onTap: () => setState(_search.clear),
                  child: const Icon(Icons.close, size: 20, color: _C.ink),
                ),
        ],
      ),
    );
  }

  // ---------- Date + filter row ----------
  Widget _dateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_dateLabel,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: _C.ink)),
        PopupMenuButton<int>(
          onSelected: (v) => setState(() => _sort = v),
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 0, child: Text('Newest first')),
            PopupMenuItem(value: 1, child: Text('Highest amount')),
          ],
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filter',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _C.green)),
                SizedBox(width: 3),
                Icon(Icons.arrow_downward, size: 14, color: _C.green),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Transactions list ----------
  Widget _listCard(List<_Txn> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No matching activity',
                    style: TextStyle(fontSize: 13, color: _C.grey)),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 20),
                  _txnRow(items[i]),
                ],
              ],
            ),
    );
  }

  Widget _txnRow(_Txn t) {
    final received = t.amount > 0;
    final amountText =
        '${received ? '+' : '-'}₹${_fmt(t.amount.abs())}';

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: t.tint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: t.letter != null
              ? Text(t.letter!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500, color: _C.ink))
              : Icon(t.icon, size: 22, color: _C.ink),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: _C.ink)),
              const SizedBox(height: 3),
              Text(t.sub,
                  style: const TextStyle(fontSize: 12, color: _C.grey)),
            ],
          ),
        ),
        Text(amountText,
            style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: received ? _C.green : _C.ink)),
      ],
    );
  }

  // ---------- Saved card ----------
  Widget _savedCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.savedCard,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _C.mint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.spa_outlined, size: 22, color: _C.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saved this $_periodWord',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _C.ink)),
                const SizedBox(height: 3),
                const Text('Moved to your savings balance',
                    style: TextStyle(fontSize: 12, color: _C.grey)),
              ],
            ),
          ),
          Text('₹${_fmt(_saved)}',
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: _C.ink)),
        ],
      ),
    );
  }

  // ---------- Download ----------
  Widget _downloadButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          // TODO: generate statement when backend is ready
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Statement will be ready soon')),
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _C.ink,
          side: const BorderSide(color: _C.border),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_download_outlined, size: 20),
            SizedBox(width: 10),
            Text('Download statement',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}