import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nova/Pages_nova/Card_control_page.dart';

/// Every color is sampled directly from the Figma design.
class _CardColors {
  _CardColors._();

  /// Page / scaffold background (warm off-white).
  static const Color pageBackground = Color(0xFFF7F8F2);

  /// Soft light-green used for chips, the limits box, badge and nav pill.
  static const Color softGreen = Color(0xFFEDF6DC);

  /// Lime accent — primary button, toggles, card contactless, mastercard dot.
  static const Color lime = Color(0xFFC4F566);

  /// Dark card background.
  static const Color cardDark = Color(0xFF222922);

  /// Lighter circle blob on the card.
  static const Color cardBlob = Color(0xFF374234);

  /// Thin ring outline on the card blob.
  static const Color cardRing = Color(0xFF465246);

  /// Grey mastercard circle.
  static const Color cardGreyCircle = Color(0xFFA2AB9C);

  /// Main dark text (headings, titles, amounts, button labels).
  static const Color textDark = Color(0xFF20251F);

  /// Muted text (subtitles, footnotes).
  static const Color textMuted = Color(0xFFA7ACA2);

  /// Slightly darker muted text (labels inside the limits box).
  static const Color textMutedDark = Color(0xFF959C8D);

  /// Light text on the dark card.
  static const Color cardTextLight = Color(0xFFCBD1C7);

  /// Active badge text + dot greens.
  static const Color badgeText = Color(0xFF4D6C35);
  static const Color badgeDot = Color(0xFF42632A);

  /// Warm chip background for the "Lost or damaged card?" row.
  static const Color chipWarm = Color(0xFFF8E9DD);

  /// Outlined button border.
  static const Color outline = Color(0xFFE3E6DC);

  /// Bottom nav divider.
 
}

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool onlinePayments = true;
  bool contactlessPayments = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _CardColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const _CardSectionLabel(),
                    const SizedBox(height: 16),
                    const _NovaCard(),
                    const SizedBox(height: 20),
                    const _ActionButtons(),
                    const SizedBox(height: 22),
                    const _LimitsBox(),
                    const SizedBox(height: 32),
                    const _ManageCardHeading(),
                    const SizedBox(height: 16),
                    _ManageCard(
                      onlinePayments: onlinePayments,
                      contactlessPayments: contactlessPayments,
                      onOnlinePayments: (v) =>
                          setState(() => onlinePayments = v),
                      onContactless: (v) =>
                          setState(() => contactlessPayments = v),
                    ),
                    const SizedBox(height: 24),
                    const _FooterNote(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------- section label row

class _CardSectionLabel extends StatelessWidget {
  const _CardSectionLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'NOVA debit card',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _CardColors.textDark,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _CardColors.softGreen,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _CardColors.badgeDot,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _CardColors.badgeText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------- card

class _NovaCard extends StatelessWidget {
  const _NovaCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 190,
        color: _CardColors.cardDark,
        child: Stack(
          children: [
            // Decorative circle blob (top-right).
            Positioned(
              right: -95,
              top: -55,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: _CardColors.cardBlob,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Thin ring accent on the blob.
            Positioned(
              right: -55,
              top: -10,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _CardColors.cardRing,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NOVA',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.contactless,
                        size: 24,
                        color: _CardColors.lime,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Chip icon.
                      Container(
                        width: 20,
                        height: 27,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.85),
                            width: 1.4,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Container(
                            width: 1.4,
                            height: 17,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Masked dots.
                      for (int i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                      const Text(
                        '4821',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AARAV',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                          color: _CardColors.cardTextLight,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '09/29',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _CardColors.cardTextLight,
                            ),
                          ),
                          const SizedBox(width: 40),
                          // Mastercard-style circles.
                          SizedBox(
                            width: 44,
                            height: 28,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 16,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      color: _CardColors.cardGreyCircle,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: _CardColors.lime,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- buttons

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: 'Show details',
            icon: Icons.visibility_outlined,
            background: _CardColors.lime,
            border: null,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CardControlsPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PillButton(
            label: 'Freeze card',
            icon: Icons.ac_unit,
            background: Colors.white,
            border: _CardColors.outline,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color? border;
  final VoidCallback onPressed;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.background,
    required this.border,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: StadiumBorder(
        side: border == null
            ? BorderSide.none
            : BorderSide(color: border!, width: 1),
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
              Icon(icon, size: 18, color: _CardColors.textDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _CardColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- limits box

class _LimitsBox extends StatelessWidget {
  const _LimitsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: _CardColors.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LimitItem(
                  label: 'Available to spend',
                  amount: '\u20B93,680',
                ),
              ),
              Expanded(
                child: _LimitItem(
                  label: 'Daily limit',
                  amount: '\u20B91,500',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Limits are managed together with your parent.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: _CardColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitItem extends StatelessWidget {
  final String label;
  final String amount;

  const _LimitItem({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _CardColors.textMutedDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: _CardColors.textDark,
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------- manage card

class _ManageCardHeading extends StatelessWidget {
  const _ManageCardHeading();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Manage card',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _CardColors.textDark,
      ),
    );
  }
}

class _ManageCard extends StatelessWidget {
  final bool onlinePayments;
  final bool contactlessPayments;
  final ValueChanged<bool> onOnlinePayments;
  final ValueChanged<bool> onContactless;

  const _ManageCard({
    required this.onlinePayments,
    required this.contactlessPayments,
    required this.onOnlinePayments,
    required this.onContactless,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const _ManageRow(
            chipColor: _CardColors.softGreen,
            icon: Icons.key_outlined,
            title: 'Change card PIN',
            subtitle: 'Keep your four-digit PIN private.',
            trailing: _Chevron(),
          ),
          const SizedBox(height: 18),
          _ManageRow(
            chipColor: _CardColors.softGreen,
            icon: Icons.language,
            title: 'Online payments',
            subtitle: 'Enabled \u00B7 within your daily limit',
            trailing: _NovaSwitch(
              value: onlinePayments,
              onChanged: onOnlinePayments,
            ),
          ),
          const SizedBox(height: 18),
          _ManageRow(
            chipColor: _CardColors.softGreen,
            icon: Icons.contactless,
            title: 'Contactless payments',
            subtitle: 'Tap and go is on.',
            trailing: _NovaSwitch(
              value: contactlessPayments,
              onChanged: onContactless,
            ),
          ),
          const SizedBox(height: 18),
          const _ManageRow(
            chipColor: _CardColors.chipWarm,
            icon: Icons.gpp_maybe_outlined,
            title: 'Lost or damaged card?',
            subtitle: 'Report it and request a replacement.',
            trailing: _Chevron(),
          ),
        ],
      ),
    );
  }
}

class _ManageRow extends StatelessWidget {
  final Color chipColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _ManageRow({
    required this.chipColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 20, color: _CardColors.textDark),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: _CardColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _CardColors.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.chevron_right,
      size: 20,
      color: _CardColors.textDark,
    );
  }
}

class _NovaSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NovaSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      width: 46,
      child: Transform.scale(
        scale: 0.78,
        transformHitTests: false,
        child: Switch(
          value: value,
          onChanged: onChanged,

          // White thumb in both states (right when ON, left when OFF).
          thumbColor: const WidgetStatePropertyAll(Colors.white),

          // Only the track background changes.
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return _CardColors.lime;
            }
            return _CardColors.outline;
          }),

          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------- footer note

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Never share your card details, PIN or OTP.',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: _CardColors.textMuted,
        ),
      ),
    );
  }
}