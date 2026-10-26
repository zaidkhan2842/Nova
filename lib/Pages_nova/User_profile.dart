import 'package:flutter/material.dart';

/// Private colors so this file never clashes with the shared NovaColors theme.
class _C {
  _C._();

  static const Color page = Color(0xFFF7F8F2);
  static const Color softGreen = Color(0xFFEDF6DC);
  static const Color lime = Color(0xFFC4F566);
  static const Color lavender = Color(0xFFEBE8F7);
  static const Color track = Color(0xFFE3E6DC);
  static const Color textDark = Color(0xFF20251F);
  static const Color textMuted = Color(0xFFA7ACA2);
  static const Color textMutedDark = Color(0xFF8E958A);
  static const Color positive = Color(0xFF4D6C35);
  static const Color outline = Color(0xFFE3E6DC);
}

class ProfileSecurityPage extends StatefulWidget {
  const ProfileSecurityPage({super.key});

  @override
  State<ProfileSecurityPage> createState() => _ProfileSecurityPageState();
}

class _ProfileSecurityPageState extends State<ProfileSecurityPage> {
  bool _faceId = true;
  bool _paymentAlerts = true;

  @override
  Widget build(BuildContext context) {
    final protected = _faceId && _paymentAlerts;

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
                title: 'Profile & security',
                subtitle: 'A safe space for your money.',
              ),
              const SizedBox(height: 20),
              _ProfileRow(onEdit: () {}),
              const SizedBox(height: 18),
              _ProtectedCard(protected: protected),
              const SizedBox(height: 26),
              const _SectionTitle('Your account'),
              const SizedBox(height: 12),
              _GroupCard(
                children: [
                  _NavRow(
                    chipColor: _C.softGreen,
                    icon: Icons.person_outline,
                    title: 'Personal details',
                    subtitle: 'Your name and contact information',
                    onTap: () {},
                  ),
                  _NavRow(
                    chipColor: _C.lavender,
                    letter: 'P',
                    title: 'Linked parent \u00B7 Priya',
                    subtitle: 'Managing money together',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Security'),
              const SizedBox(height: 12),
              _GroupCard(
                children: [
                  _SwitchRow(
                    chipColor: _C.softGreen,
                    icon: Icons.face_retouching_natural,
                    title: 'Face ID',
                    subtitle: 'A quick, secure way to sign in',
                    value: _faceId,
                    onChanged: (v) => setState(() => _faceId = v),
                  ),
                  _NavRow(
                    chipColor: _C.softGreen,
                    icon: Icons.key_outlined,
                    title: 'Change app PIN',
                    subtitle: 'Use a PIN only you know',
                    onTap: () {},
                  ),
                  _NavRow(
                    chipColor: _C.lavender,
                    icon: Icons.smartphone_outlined,
                    title: 'Manage devices',
                    subtitle: '1 trusted device \u00B7 This iPhone',
                    onTap: () {},
                  ),
                  _SwitchRow(
                    chipColor: _C.softGreen,
                    icon: Icons.notifications_none_outlined,
                    title: 'Payment alerts',
                    subtitle: 'Know whenever your money moves',
                    value: _paymentAlerts,
                    onChanged: (v) => setState(() => _paymentAlerts = v),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const _SectionTitle('Here to help'),
              const SizedBox(height: 12),
              _GroupCard(
                children: [
                  _NavRow(
                    chipColor: _C.lavender,
                    icon: Icons.chat_bubble_outline,
                    title: 'Help & support',
                    subtitle: 'Talk to the NOVA team',
                    onTap: () {},
                  ),
                  _NavRow(
                    chipColor: _C.softGreen,
                    icon: Icons.description_outlined,
                    title: 'Privacy & terms',
                    subtitle: 'Your data, explained simply',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _LogoutButton(onPressed: () {}),
              const SizedBox(height: 18),
              const Center(
                child: Text(
                  'NOVA \u00B7 Smart money. Real life.',
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

// ------------------------------------------------------------- profile row

class _ProfileRow extends StatelessWidget {
  final VoidCallback onEdit;

  const _ProfileRow({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: _C.lime,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'A',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: _C.textDark,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aarav',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _C.textDark,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Teen \u00B7 Linked to Priya',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: _C.textMutedDark,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _C.positive,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------- protected card

class _ProtectedCard extends StatelessWidget {
  final bool protected;

  const _ProtectedCard({required this.protected});

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
          Row(
            children: [
              const SizedBox(
                width: 36,
                child: Icon(
                  Icons.gpp_good_outlined,
                  size: 22,
                  color: _C.textDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      protected
                          ? 'Your account is protected'
                          : 'Add a little more protection',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _C.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      protected
                          ? 'App lock and payment alerts are on'
                          : 'Turn on Face ID and payment alerts',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: _C.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'A few small steps keep your money safe.',
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

// ------------------------------------------------------------- group card

class _GroupCard extends StatelessWidget {
  final List<Widget> children;

  const _GroupCard({required this.children});

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
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String? letter;

  const _IconChip({required this.color, this.icon, this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: letter != null
          ? Text(
              letter!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _C.textDark,
              ),
            )
          : Icon(icon, size: 18, color: _C.textDark),
    );
  }
}

class _RowText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RowText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _NavRow extends StatelessWidget {
  final Color chipColor;
  final IconData? icon;
  final String? letter;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavRow({
    required this.chipColor,
    this.icon,
    this.letter,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          _IconChip(color: chipColor, icon: icon, letter: letter),
          const SizedBox(width: 12),
          Expanded(child: _RowText(title: title, subtitle: subtitle)),
          const Icon(Icons.chevron_right, size: 18, color: _C.textDark),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final Color chipColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
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
        _IconChip(color: chipColor, icon: icon),
        const SizedBox(width: 12),
        Expanded(child: _RowText(title: title, subtitle: subtitle)),
        _NovaSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// ------------------------------------------------------------------ button

class _LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LogoutButton({required this.onPressed});

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
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 16, color: _C.textDark),
              SizedBox(width: 8),
              Text(
                'Log out',
                style: TextStyle(
                  fontSize: 13,
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