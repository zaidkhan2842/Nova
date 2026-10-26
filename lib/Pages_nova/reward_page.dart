import 'package:flutter/material.dart';
import 'package:nova/Pages_nova/Goal_page.dart';
import 'package:nova/Pages_nova/check_goal.dart'; // file that defines SavingGoal

/// Private colors so this file never clashes with the shared NovaColors theme.
class _C {
  _C._();

  static const Color page = Color(0xFFF7F8F2);
  static const Color softGreen = Color(0xFFEDF6DC);
  static const Color lime = Color(0xFFC4F566);
  static const Color lavender = Color(0xFFEBE8F7);
  static const Color track = Color(0xFFDDE0D6);
  static const Color textDark = Color(0xFF20251F);
  static const Color textMuted = Color(0xFFA7ACA2);
  static const Color textMutedDark = Color(0xFF8E958A);
  static const Color positive = Color(0xFF4D6C35);
}

class RewardsPage extends StatelessWidget {
  final SavingGoal goal;

  const RewardsPage({super.key, required this.goal});

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
                title: 'Rewards',
                subtitle: 'Good habits deserve a little celebration.',
              ),
              const SizedBox(height: 20),
               _ExperienceCard(goal: goal),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle('Your badges'),
                  Text(
                    '2 earned',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: _C.positive,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: _BadgeCard(
                      circleColor: _C.softGreen,
                      icon: Icons.eco_outlined,
                      title: 'First saver',
                      subtitle: 'Made your first save',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _BadgeCard(
                      circleColor: _C.lavender,
                      icon: Icons.auto_awesome_outlined,
                      title: 'Money curious',
                      subtitle: 'Reviewed your activity',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionTitle('Your next reward'),
              const SizedBox(height: 12),
              _NextRewardCard(goal: goal),
              const SizedBox(height: 16),
              _PrimaryButton(
                label: 'Continue Money Mission',
                onPressed: () {
                   Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MoneyMissionPage()),
        );
                },
              ),
              const SizedBox(height: 24),
              const _SectionTitle('How you earned it'),
              const SizedBox(height: 12),
              const _EarnedCard(),
              const SizedBox(height: 20),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'XP celebrates learning and saving. It isn\u2019t money and can\u2019t be withdrawn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: _C.textMuted,
                    ),
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

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0).toDouble(),
        minHeight: 6,
        backgroundColor: _C.track,
        valueColor: const AlwaysStoppedAnimation<Color>(_C.textDark),
      ),
    );
  }
}

// ---------------------------------------------------------- experience card

class _ExperienceCard extends StatelessWidget {
  final SavingGoal goal;

  const _ExperienceCard({required this.goal});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.lavender,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your experience',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: _C.textMutedDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '240 XP',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        color: _C.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  size: 26,
                  color: _C.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Level 2 \u00B7 Money Explorer',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.textDark,
            ),
          ),
          const SizedBox(height: 10),
          _ProgressBar(value: goal.progress),
          const SizedBox(height: 12),
          const Text(
            '60 XP to the next level. You\u2019re getting there.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: _C.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------- badge card

class _BadgeCard extends StatelessWidget {
  final Color circleColor;
  final IconData icon;
  final String title;
  final String subtitle;

  const _BadgeCard({
    required this.circleColor,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: _C.textDark),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _C.textDark,
            ),
          ),
          const SizedBox(height: 3),
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
    );
  }
}

// ------------------------------------------------------- next reward card

class _NextRewardCard extends StatelessWidget {
  final SavingGoal goal;

  const _NextRewardCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 20,
                  color: _C.textDark,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mindful Spender',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _C.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Weekly challenge \u00B7 Ends Sun, 11 Oct',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: _C.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '100 XP',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _C.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ProgressBar(value: goal.progress),
          const SizedBox(height: 12),
          const Text(
            '2 of 3 steps complete. Finish under \u20B91,200 this week to earn XP and your next badge.',
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

// ------------------------------------------------------------------ button

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _C.lime,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_forward, size: 16, color: _C.textDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
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

// ------------------------------------------------------------- earned card

class _EarnedCard extends StatelessWidget {
  const _EarnedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          _EarnedRow(
            icon: Icons.eco_outlined,
            title: 'First savings goal',
            subtitle: 'Started your headphones pot',
            xp: '+100 XP',
          ),
          SizedBox(height: 16),
          _EarnedRow(
            icon: Icons.bar_chart_rounded,
            title: 'Spending check-in',
            subtitle: 'Took a closer look at your habits',
            xp: '+90 XP',
          ),
          SizedBox(height: 16),
          _EarnedRow(
            icon: Icons.check_circle_outline,
            title: 'Getting started',
            subtitle: 'Completed your NOVA setup',
            xp: '+50 XP',
          ),
        ],
      ),
    );
  }
}

class _EarnedRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String xp;

  const _EarnedRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _C.softGreen,
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
        Text(
          xp,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _C.positive,
          ),
        ),
      ],
    );
  }
}