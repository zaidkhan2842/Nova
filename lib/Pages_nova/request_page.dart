import 'package:flutter/material.dart';

class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF1C201A);
  static const grey = Color(0xFF7C8279);
  static const card = Colors.white;
  static const infoCard = Color(0xFFE9F3D6);
  static const lime = Color(0xFFC8F560);
  static const green = Color(0xFF4F7A2B);
  
  static const tabTrack = Color(0xFFE4E8DB);
  static const lavender = Color(0xFFE6E4F4);
}

class RequestMoneyPage extends StatefulWidget {
  const RequestMoneyPage({super.key});

  @override
  State<RequestMoneyPage> createState() => _RequestMoneyPageState();
}

class _RequestMoneyPageState extends State<RequestMoneyPage> {
  // ---- Static demo data ----
  static const _people = [
    {'name': 'Dad', 'tag': 'Linked family'},
    {'name': 'Mom', 'tag': 'Linked family'},
    {'name': 'Isha', 'tag': 'NOVA friend'},
  ];
  static const _chips = [100, 250, 500];

  int _tab = 0; // 0 = From a person, 1 = Payment link
  int _person = 0;
  int _amount = 500;
  final _reason = TextEditingController(text: 'Books for the new term 📚');

  String get _name => _people[_person]['name']!;

  String _fmt(int n) {
    final s = n.toString();
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

  @override
  void dispose() {
    _reason.dispose();
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
              const SizedBox(height: 22),
              _tabs(),
              const SizedBox(height: 24),
              if (_tab == 0) ...[
                _label('Request from'),
                const SizedBox(height: 10),
                _personDropdown(),
                const SizedBox(height: 32),
              ],
              _amountSection(),
              const SizedBox(height: 24),
              _chipRow(),
              const SizedBox(height: 32),
              _label('Reason (optional)'),
              const SizedBox(height: 10),
              _reasonField(),
              const SizedBox(height: 20),
              _infoCard(),
              const SizedBox(height: 20),
              _requestButton(),
              const SizedBox(height: 28),
              _requestsHeader(),
              const SizedBox(height: 14),
              _requestsCard(),
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
              Text('Request money',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('Ask for it, without the awkward bit.',
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

  // ---------- Segmented tabs ----------
  Widget _tabs() {
    Widget tab(int i, String text) {
      final selected = _tab == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(text,
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? _C.ink : _C.grey)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _C.tabTrack,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: [tab(0, 'From a person'), tab(1, 'Payment link')]),
    );
  }

  // ---------- Request from dropdown ----------
  Widget _personDropdown() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _person,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 22, color: _C.ink),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          style: const TextStyle(fontSize: 15, color: _C.ink),
          onChanged: (v) => setState(() => _person = v ?? 0),
          items: [
            for (var i = 0; i < _people.length; i++)
              DropdownMenuItem(
                value: i,
                child: Text('${_people[i]['name']} · ${_people[i]['tag']}'),
              ),
          ],
        ),
      ),
    );
  }

  // ---------- Amount ----------
  Widget _amountSection() {
    return Column(
      children: [
        _label('Amount to request'),
        const SizedBox(height: 10),
        Text(
          '₹${_fmt(_amount)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.w300, color: _C.ink, height: 1.1),
        ),
      ],
    );
  }

  Widget _chipRow() {
    return Row(
      children: [
        for (var i = 0; i < _chips.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: _chip(_chips[i])),
        ],
      ],
    );
  }

  Widget _chip(int v) {
    final selected = _amount == v;
    return GestureDetector(
      onTap: () => setState(() => _amount = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _C.lime : Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text('₹$v',
            style: TextStyle(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: _C.ink)),
      ),
    );
  }

  // ---------- Reason ----------
  Widget _reasonField() {
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
              controller: _reason,
              style: const TextStyle(fontSize: 15, color: _C.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Add a reason',
              ),
            ),
          ),
          const Icon(Icons.edit_outlined, size: 20, color: _C.ink),
        ],
      ),
    );
  }

  // ---------- Info card ----------
  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: _C.infoCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none, size: 22, color: _C.ink),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tab == 0
                      ? '$_name will get a notification'
                      : 'Share your link anywhere',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: _C.ink),
                ),
                const SizedBox(height: 4),
                const Text(
                  'They can review your reason and pay securely. '
                  "Requests don't move money automatically.",
                  style: TextStyle(fontSize: 12, color: _C.grey, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Request button ----------
  Widget _requestButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _amount > 0
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_tab == 0
                      ? 'Requested ₹${_fmt(_amount)} from $_name'
                      : 'Payment link for ₹${_fmt(_amount)} created'),
                ));
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          foregroundColor: _C.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.south_west, size: 18),
            const SizedBox(width: 10),
            Text(
              _tab == 0
                  ? 'Request ₹${_fmt(_amount)} from $_name'
                  : 'Create link for ₹${_fmt(_amount)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Your requests ----------
  Widget _requestsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Your requests',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: _C.ink)),
        InkWell(
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Text('View all',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _C.green)),
          ),
        ),
      ],
    );
  }

  Widget _requestsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Past request
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _C.infoCard,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('D',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500, color: _C.ink)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dad',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _C.ink)),
                    SizedBox(height: 3),
                    Text('Yesterday · Weekly allowance',
                        style: TextStyle(fontSize: 12, color: _C.grey)),
                  ],
                ),
              ),
              const Text('₹1,000',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _C.green)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Paid · Included in your recent activity',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: _C.green)),
          const SizedBox(height: 16),
          // Empty state
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _C.lavender,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 22, color: _C.ink),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No pending requests',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _C.ink)),
                    SizedBox(height: 3),
                    Text("You're all caught up.",
                        style: TextStyle(fontSize: 12, color: _C.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Footer / bottom nav ----------
  
}