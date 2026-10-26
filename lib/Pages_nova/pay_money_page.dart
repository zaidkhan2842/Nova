import 'package:flutter/material.dart';

// ---------- Colors (pulled from the design) ----------
class _C {
  static const bg = Color(0xFFF6F7F0);
  static const ink = Color(0xFF20251F);
  static const grey = Color(0xFF777e72);
  static const card = Colors.white;
  static const friendCard = Color(0xFFE9F3D6);
  static const lime = Color(0xFFC8F560);
  static const green = Color(0xFF42632A);
 
}

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  // ---- Static demo data (replace with API later) ----
  static const double _balance = 3680;
  static const String _friendName = 'Isha Sharma';
  static const String _friendHandle = 'isha@nova · NOVA friend';

  String _amount = '250';
  final _noteController = TextEditingController(text: 'For pizza 🍕');
  final _search = TextEditingController();

  double get _value => double.tryParse(_amount) ?? 0;
  bool get _canSend => _value > 0 && _value <= _balance;

  // ---- Keypad logic ----
  void _onKey(String key) {
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _header(),
                    const SizedBox(height: 18),
                    const Text('Find a friend',
                        style: TextStyle(fontSize: 11, color: _C.grey)),
                    const SizedBox(height: 6),
                    _searchField(),
                    const SizedBox(height: 14),
                    _friendTile(),
                    const SizedBox(height: 22),
                    _amountSection(),
                    const SizedBox(height: 18),
                    const Text('Note (optional)',
                        style: TextStyle(fontSize: 11, color: _C.grey)),
                    const SizedBox(height: 6),
                    _noteField(),
                    const SizedBox(height: 8),
                    _keypad(),
                    const SizedBox(height: 8),
                    _feeCard(),
                    const SizedBox(height: 18),
                    _sendButton(),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text("You'll confirm securely before money leaves.",
                          style: TextStyle(fontSize: 11, color: _C.grey)),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  // ---------- Header ----------
   Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
              Text('Send money',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600, color: _C.ink)),
              SizedBox(height: 3),
              Text('A little something, instantly.',
                  style: TextStyle(fontSize: 13, color: _C.grey,fontWeight: FontWeight.w400)),
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
            style: const TextStyle(fontSize: 15, color: _C.ink),
            textInputAction: TextInputAction.search,
            onChanged: (q) {
              // TODO: filter friends by name / phone / UPI ID
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: 'Search name, phone or UPI ID',
              hintStyle: TextStyle(fontSize: 15, color: _C.ink),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.search, size: 22, color: _C.ink),
      ],
    ),
  );
}
  // ---------- Selected friend ----------
  Widget _friendTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: _C.friendCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 28,
            child: Text('I',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _C.ink)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_friendName,
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, color: _C.ink)),
                SizedBox(height: 2),
                Text(_friendHandle,
                    style: TextStyle(fontSize: 10.5, color: _C.grey ,fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text('Change',
                style: TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w700, color: _C.ink)),
          ),
        ],
      ),
    );
  }

  // ---------- Amount ----------
  Widget _amountSection() {
    return Center(
      child: Column(
        children: [
          const Text("You're sending",
              style: TextStyle(fontSize: 11, color: _C.grey)),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: '₹'),
                TextSpan(text: _amount.contains('.') ? _amount : _fmt(_value)),
              ],
            ),
            style: const TextStyle(
                fontSize: 48, fontWeight: FontWeight.w400, color: _C.ink, height: 1.1),
          ),
          const SizedBox(height: 6),
          Text('Available balance ₹${_fmt(_balance)}',
              style: const TextStyle(fontSize: 11, color: _C.grey)),
        ],
      ),
    );
  }

  // ---------- Note ----------
  Widget _noteField() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _noteController,
              style: const TextStyle(fontSize: 13.5, color: _C.ink),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Add a note',
              ),
            ),
          ),
          const Icon(Icons.edit_outlined, size: 18, color: _C.ink),
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
          .map((r) => Row(children: r.map((k) => Expanded(child: _key(k))).toList()))
          .toList(),
    );
  }

  Widget _key(String k) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _onKey(k),
      child: SizedBox(
        height: 52,
        child: Center(
          child: k == 'back'
              ? const Icon(Icons.backspace_outlined, size: 22, color: _C.ink)
              : Text(k,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w400, color: _C.ink)),
        ),
      ),
    );
  }

  // ---------- Fee ----------
  Widget _feeCard() {
    final after = _balance - _value;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Transfer fee', style: TextStyle(fontSize: 11.5, color: _C.grey)),
              Text('Free',
                  style: TextStyle(
                      fontSize: 11.5, fontWeight: FontWeight.w400, color: _C.green)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            after >= 0
                ? '₹${_fmt(after)} available after this payment.'
                : 'Amount exceeds your available balance.',
            style: TextStyle(
                fontSize: 11, color: after >= 0 ? _C.grey : Colors.redAccent),
          ),
        ],
      ),
    );
  }

  // ---------- Send button ----------
  Widget _sendButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _canSend
            ? () {
                // TODO: confirm screen / API call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sending ₹${_fmt(_value)} to Isha...')),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.lime,
          disabledBackgroundColor: _C.lime.withOpacity(0.5),
          foregroundColor: _C.ink,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.north_east, size: 16),
            const SizedBox(width: 8),
            Text('Send ₹${_fmt(_value)} to Isha',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------- Bottom nav ----------
  
}