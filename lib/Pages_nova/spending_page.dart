import 'package:flutter/material.dart';
import 'package:nova/Pages_nova/check_history.dart';

/// Private colors so this file never clashes with the shared NovaColors theme.
class _C {
  _C._();

  static const Color page = Color(0xFFF7F8F2);
  static const Color softGreen = Color(0xFFEDF6DC);
  static const Color lime = Color(0xFFC4F566);
  static const Color barGreen = Color(0xFFB7CA9C);
  static const Color lavender = Color(0xFFEBE8F7);
  static const Color blueChip = Color(0xFFE4EAF6);
  static const Color peachChip = Color(0xFFF8E9DD);
  static const Color track = Color(0xFFDDE0D6);
  static const Color textDark = Color(0xFF20251F);
  static const Color textMuted = Color(0xFFA7ACA2);
  static const Color textMutedDark = Color(0xFF8E958A);
  static const Color outline = Color(0xFFE3E6DC);
  static const Color positive = Color(0xFF4D6C35);
}

class SpendingInsightsPage extends StatefulWidget {
  const SpendingInsightsPage({super.key});

  @override
  State<SpendingInsightsPage> createState() => _SpendingInsightsPageState();
}

class _SpendingInsightsPageState extends State<SpendingInsightsPage> {
  bool _weekSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.page,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const _PageHeader(
                title: 'Spending insights',
                subtitle: 'Your habits, a little clearer.',
              ),
              const SizedBox(height: 20),
              _PeriodToggle(
                weekSelected: _weekSelected,
                onChanged: (v) => setState(() => _weekSelected = v),
              ),
              const SizedBox(height: 16),
              const _SummaryCard(),
              const SizedBox(height: 24),
              const _SectionTitle('Where your money went'),
              const SizedBox(height: 12),
              const _BreakdownCard(),
              const SizedBox(height: 24),
              const _SectionTitle('A little room to grow'),
              const SizedBox(height: 12),
              const _MissionCard(),
              const SizedBox(height: 16),
              _OutlinedActionButton(
                label: 'View transactions',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TransactionsPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '5\u201311 October \u00B7 Card and wallet payments included',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _C.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- header

class _PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PageHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.arrow_back, size: 20, color: _C.textDark),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _C.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _C.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, size: 22, color: _C.textDark),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: _C.textDark,
      ),
    );
  }
}

// ------------------------------------------------------------ period toggle

class _PeriodToggle extends StatelessWidget {
  final bool weekSelected;
  final ValueChanged<bool> onChanged;

  const _PeriodToggle({
    required this.weekSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E9DF),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: 'This week',
              selected: weekSelected,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: 'This month',
              selected: !weekSelected,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? _C.textDark : _C.textMutedDark,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ summary card

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  static const List<_BarData> _bars = [
    _BarData('14 Sep', '\u20B91,280', 1280, false),
    _BarData('21 Sep', '\u20B91,080', 1080, false),
    _BarData('28 Sep', '\u20B91,140', 1140, false),
    _BarData('5 Oct', '\u20B9920', 920, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: _C.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(label: 'Spent this week', value: '\u20B9920'),
              ),
              Expanded(
                child: _Stat(label: 'Saved this week', value: '\u20B9600'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.arrow_downward, size: 12, color: _C.positive),
              SizedBox(width: 4),
              Text(
                '19% less spending than last week',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: _C.positive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 124,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [for (final b in _bars) _Bar(data: b)],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: _C.textMutedDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: _C.textDark,
          ),
        ),
      ],
    );
  }
}

class _BarData {
  final String label;
  final String amountLabel;
  final double amount;
  final bool highlighted;

  const _BarData(this.label, this.amountLabel, this.amount, this.highlighted);
}

class _Bar extends StatelessWidget {
  final _BarData data;

  const _Bar({required this.data});

  static const double _maxAmount = 1280;
  static const double _maxHeight = 66;

  @override
  Widget build(BuildContext context) {
    final height = (data.amount / _maxAmount) * _maxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.amountLabel,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w400,
            color: _C.textMutedDark,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: data.highlighted ? _C.lime : _C.barGreen,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _C.textMutedDark,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------- breakdown card

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const SizedBox(
              height: 6,
              child: Row(
                children: [
                  Expanded(flex: 54, child: ColoredBox(color: _C.blueChip)),
                  Expanded(flex: 31, child: ColoredBox(color: _C.peachChip)),
                  Expanded(flex: 15, child: ColoredBox(color: _C.lavender)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const _CategoryRow(
            chipColor: _C.blueChip,
            icon: Icons.sports_esports_outlined,
            title: 'Gaming',
            subtitle: '54% of this week\u2019s spending',
            amount: '\u20B9499',
          ),
          const SizedBox(height: 16),
          const _CategoryRow(
            chipColor: _C.peachChip,
            icon: Icons.local_cafe_outlined,
            title: 'Food & drinks',
            subtitle: '31% of this week\u2019s spending',
            amount: '\u20B9280',
          ),
          const SizedBox(height: 16),
          const _CategoryRow(
            chipColor: _C.lavender,
            icon: Icons.directions_transit_outlined,
            title: 'Transport',
            subtitle: '15% of this week\u2019s spending',
            amount: '\u20B9141',
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final Color chipColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  const _CategoryRow({
    required this.chipColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: _C.textDark),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _C.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: _C.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: _C.textDark,
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------ mission card

class _MissionCard extends StatelessWidget {
  const _MissionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.lavender,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u20B9280 left in your weekly mission',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: _C.textDark,
            ),
          ),
          const SizedBox(height: 12),
          const _ProgressBar(value: 920 / 1200),
          const SizedBox(height: 12),
          const Text(
            '\u20B9920 of \u20B91,200 spent. Keep it mindful until Sunday to complete your challenge.',
            style: TextStyle(
              fontSize: 11,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: _C.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: _C.track,
        valueColor: const AlwaysStoppedAnimation<Color>(_C.textDark),
      ),
    );
  }
}

// ------------------------------------------------------------------ button

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _OutlinedActionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const StadiumBorder(
        side: BorderSide(color: _C.outline, width: 1),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_forward, size: 16, color: _C.textDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _C.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}