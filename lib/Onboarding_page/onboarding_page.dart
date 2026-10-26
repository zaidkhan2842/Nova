import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nova/main_screen/main-screen.dart';

import '../Nova_theme/nove_theme.dart';


// ---------------------------------------------------------------------------
// IMAGE PATHS - change these 3 lines when you put your original images
// ---------------------------------------------------------------------------
const String kLogoImage = 'assets/images/image.png'; // NOVA logo (top left)
const String kPersonImage = 'assets/images/Group.png'; // character (middle)
const String kStarImage = 'assets/images/Vector.png'; // small star (right side)

/// Used by both the button tap and the swipe-right gesture.
void goToHome(BuildContext context, {bool fromLeft = false}) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const MainScreen(),
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
          begin: Offset(fromLeft ? -1 : 1, 0), // swipe right -> slides in from left
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(slide), child: child);
      },
    ),
  );
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  double _dragDx = 0; // how far the finger moved to the right
  bool _went = false; // makes sure we route only once

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Swipe RIGHT (move finger left -> right) -> home
     onHorizontalDragStart: (_) => _dragDx = 0,
     onHorizontalDragUpdate: (d) {
      _dragDx += d.delta.dx;
      if (!_went && _dragDx < -100) {      // minus = finger moving left
      _went = true;
      goToHome(context);                // home slides in from the right
  }
},
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                
                const SizedBox(height: 18),

                // ---- 1) Logo (top left) ----
               Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: const [
    _Img(kLogoImage, height: 28),
    SizedBox(width: 8),
    Text(
      'NOVA',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: Color(0xFF0F172A),
      ),
    ),
  ],
),
                
                // ---- 2) Person + 3) Star (fills the free space) ----
                Expanded(
                  
                child: Stack(
  clipBehavior: Clip.none,          // lets the star sit past the edge (right: -15)
  alignment: Alignment.center,
  children: [
    // person in the middle, with a fixed width
    Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: _Img(
        kPersonImage,
        width: MediaQuery.of(context).size.width * 0.75, // 62% of screen width
        fit: BoxFit.contain,
      ),
    ),
    // star on the right side (drawn after the person, so it sits on top)
    const Positioned(
      right: -55,
      bottom: 230,
      child: _Img(kStarImage, width: 34),
    ),
  ],
),
                ),

                // ---- Headline + tagline ----
                Text('Your money.\nYour future.', style: textTheme.displaySmall),
                const SizedBox(height: 8),
                Text('Learn. Spend. Save. Grow.', style: textTheme.bodyMedium),
                const SizedBox(height: 28),

                // ---- Button ----
                ElevatedButton.icon(
                  onPressed: () => goToHome(context),
                  icon: const Icon(Icons.arrow_forward, size: 17),
                  label: const Text('Get started'),
                ),
                const SizedBox(height: 40),

                // ---- Log in + legal ----
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO: Login page
                        },
                        child: Text(
                          'Already part of NOVA? Log in',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: NovaColors.slate,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'For ages 13-17, with a parent or guardian.\n'
                        'By continuing, you agree to our Terms & Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          height: 1.5,
                          color: NovaColors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small helper: loads an asset image, and shows a grey "?" box
/// if the file name is wrong, so the app never crashes while testing.
class _Img extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const _Img(this.path, {this.width, this.height, this.fit = BoxFit.contain});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width ?? 60,
        height: height ?? 60,
        color: Colors.black12,
        child: const Icon(Icons.image_not_supported_outlined, size: 20),
      ),
    );
  }
}