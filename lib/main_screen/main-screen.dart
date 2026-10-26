
import 'package:flutter/material.dart';
import 'package:nova/Pages_nova/Goal_page.dart';
import 'package:nova/Pages_nova/User_profile.dart';

import '../Pages_nova/home_page.dart';
import '../Pages_nova/card_page.dart';
import '../Nova_theme/nove_theme.dart';

// Import your actual pages when ready.
// import '../Pages_nova/goals_page.dart';
// import '../Pages_nova/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0;

  static const Color _navSelected = Color(0xFFE4F1CF);

  List<Widget> get _pages => [
    HomePage(
    onCardsTap: () => _onTabTapped(1),
    onGoalsTap: () => _onTabTapped(2),
    onProfileTap: () => _onTabTapped(3),
  ),
    const CardScreen(),
    const GoalsPage(),
    const ProfileSecurityPage()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, 'Home'),
      (Icons.credit_card_outlined, 'Cards'),
      (Icons.track_changes, 'Goals'),
      (Icons.person_outline, 'Profile'),
    ];

    return Scaffold(
      body: _pages[_navIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: NovaColors.background,
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
        child: SafeArea(
          top: false,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = _navIndex == i;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onTabTapped(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? _navSelected
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[i].$1,
                          size: 22,
                          color: selected
                              ? NovaColors.navy
                              : NovaColors.slate,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i].$2,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? NovaColors.navy
                                : NovaColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
