import 'package:flutter/material.dart';

/// Private colors so this file never clashes with the shared NovaColors theme.
class _C {
  _C._();

  static const Color page = Color(0xFFF7F8F2);
  static const Color softGreen = Color(0xFFEDF6DC);
  static const Color lime = Color(0xFFC4F566);
  static const Color lavender = Color(0xFFEBE8F7);
  static const Color peach = Color(0xFFF8E9DD);
  static const Color cardDark = Color(0xFF222922);
  static const Color cardBlob = Color(0xFF374234);
  static const Color cardRing = Color(0xFF465246);
  static const Color cardTextLight = Color(0xFFCBD1C7);
  static const Color track = Color(0xFFE3E6DC);
  static const Color progressTrack = Color(0xFFE3E6DC);
  static const Color textDark = Color(0xFF20251F);
  static const Color textMuted = Color(0xFFA7ACA2);
  static const Color textMutedDark = Color(0xFF8E958A);
  static const Color outline = Color(0xFFE3E6DC);
}

class CardControlsPage extends StatefulWidget {
  const CardControlsPage({super.key});

  @override
  State<CardControlsPage> createState() => _CardControlsPageState();
}

class _CardControlsPageState extends State<CardControlsPage> {
  bool _frozen = false;
  bool _online = true;
  bool _contactless = true;
  bool _international = false;
  bool _atm = false;

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
                title: 'Card controls',
                subtitle: 'Your card. A little more peace of mind.',
              ),
              const SizedBox(height: 20),
              _CardPreview(frozen: _frozen),
              const SizedBox(height: 16),
              _FreezeCard(
                frozen: _frozen,
                onChanged: (v) => setState(() => _frozen = v),
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Payment preferences'),
              const SizedBox(height: 12),
              _PreferencesCard(
                online: _online,
                contactless: _contactless,
                international: _international,
                atm: _atm,
                onOnline: (v) => setState(() => _online = v),
                onContactless: (v) => setState(() => _contactless = v),
                onInternational: (v) => setState(() => _international = v),
                onAtm: (v) => setState(() => _atm = v),
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Your spending limits'),
              const SizedBox(height: 12),
              const _LimitsCard(),
              const SizedBox(height: 14),
              _OutlinedActionButton(
                label: 'Request a limit change',
                onPressed: () {},
              ),
              const SizedBox(height: 18),
              const _SecurityCard(),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Never share your card details, PIN or OTP.',
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
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: _C.textDark,
      ),
    );
  }
}

// ------------------------------------------------------------ card preview

class _CardPreview extends StatelessWidget {
  final bool frozen;

  const _CardPreview({required this.frozen});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: frozen ? 0.6 : 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 130,
          width: double.infinity,
          color: _C.cardDark,
          child: Stack(
            children: [
              Positioned(
                right: -70,
                top: -50,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    color: _C.cardBlob,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -40,
                top: -20,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.cardRing, width: 1.2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'NOVA',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.contactless, size: 18, color: _C.lime),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        for (int i = 0; i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: 5),
                          Container(
                            width: 10,
                            height: 10,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
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
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            color: _C.cardTextLight,
                          ),
                        ),
                        const Text(
                          '09/29',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _C.cardTextLight,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: frozen ? _C.cardTextLight : _C.lime,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              frozen ? 'Frozen' : 'Active',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: frozen ? _C.cardTextLight : _C.lime,
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
      ),
    );
  }
}

// ------------------------------------------------------------- freeze card

class _FreezeCard extends StatelessWidget {
  final bool frozen;
  final ValueChanged<bool> onChanged;

  const _FreezeCard({required this.frozen, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _C.softGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 36,
                child: Icon(Icons.ac_unit, size: 20, color: _C.textDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Freeze card',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _C.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      frozen
                          ? 'On \u00B7 Payments are paused'
                          : 'Off \u00B7 Your card is ready to use',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: _C.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              _NovaSwitch(value: frozen, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Pause payments instantly. Unfreeze anytime.',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              color: _C.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------- preferences card

class _PreferencesCard extends StatelessWidget {
  final bool online;
  final bool contactless;
  final bool international;
  final bool atm;
  final ValueChanged<bool> onOnline;
  final ValueChanged<bool> onContactless;
  final ValueChanged<bool> onInternational;
  final ValueChanged<bool> onAtm;

  const _PreferencesCard({
    required this.online,
    required this.contactless,
    required this.international,
    required this.atm,
    required this.onOnline,
    required this.onContactless,
    required this.onInternational,
    required this.onAtm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _PrefRow(
            chipColor: _C.softGreen,
            icon: Icons.language,
            title: 'Online payments',
            subtitle: online
                ? 'Enabled \u00B7 Within your payment limits'
                : 'Off \u00B7 Online payments are blocked',
            value: online,
            onChanged: onOnline,
          ),
          const SizedBox(height: 16),
          _PrefRow(
            chipColor: _C.softGreen,
            icon: Icons.contactless,
            title: 'Contactless payments',
            subtitle: contactless ? 'Tap and go is on' : 'Tap and go is off',
            value: contactless,
            onChanged: onContactless,
          ),
          const SizedBox(height: 16),
          _PrefRow(
            chipColor: _C.lavender,
            icon: Icons.flight_outlined,
            title: 'International use',
            subtitle: international
                ? 'On \u00B7 Within your payment limits'
                : 'Off \u00B7 Parent approval needed',
            value: international,
            onChanged: onInternational,
          ),
          const SizedBox(height: 16),
          _PrefRow(
            chipColor: _C.lavender,
            icon: Icons.local_atm_outlined,
            title: 'ATM withdrawals',
            subtitle: atm
                ? 'On \u00B7 Within your daily limit'
                : 'Off \u00B7 Parent approval needed',
            value: atm,
            onChanged: onAtm,
          ),
        ],
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final Color chipColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrefRow({
    required this.chipColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
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
            borderRadius: BorderRadius.circular(10),
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
                  fontSize: 13,
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
        _NovaSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// ------------------------------------------------------------ limits card

class _LimitsCard extends StatelessWidget {
  const _LimitsCard();

  static const double _spent = 920;
  static const double _weeklyLimit = 2000;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LimitItem(label: 'Daily limit', amount: '\u20B91,500'),
              ),
              Expanded(
                child: _LimitItem(label: 'Weekly limit', amount: '\u20B92,000'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const LinearProgressIndicator(
              value: _spent / _weeklyLimit,
              minHeight: 6,
              backgroundColor: _C.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(_C.textDark),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '\u20B9920 spent this week \u00B7 \u20B91,080 remaining. Limits are managed together with your parent.',
            style: TextStyle(
              fontSize: 10.5,
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
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: _C.textMutedDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: _C.textDark,
          ),
        ),
      ],
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
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- security card

class _SecurityCard extends StatelessWidget {
  const _SecurityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          _LinkRow(
            chipColor: _C.softGreen,
            icon: Icons.key_outlined,
            title: 'Change card PIN',
            subtitle: 'Keep your four-digit PIN private',
          ),
          SizedBox(height: 16),
          _LinkRow(
            chipColor: _C.peach,
            icon: Icons.gpp_maybe_outlined,
            title: 'Lost or damaged card?',
            subtitle: 'Report it and request a replacement',
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final Color chipColor;
  final IconData icon;
  final String title;
  final String subtitle;

  const _LinkRow({
    required this.chipColor,
    required this.icon,
    required this.title,
    required this.subtitle,
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
            borderRadius: BorderRadius.circular(10),
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
                  fontSize: 13,
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
        const Icon(Icons.chevron_right, size: 18, color: _C.textDark),
      ],
    );
  }
}

// ------------------------------------------------------------------ switch

class _NovaSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NovaSwitch({required this.value, required this.onChanged});

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
          thumbColor: const WidgetStatePropertyAll(Colors.white),
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) return _C.lime;
            return _C.track;
          }),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
    );
  }
}