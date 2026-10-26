import 'package:flutter/material.dart';

import './Nova_theme/nove_theme.dart';
import './Onboarding_page/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOVA',
      
      debugShowCheckedModeBanner: false,
      theme: novaTheme,
      home: const OnboardingPage(), // default page
      
    );
  }
}