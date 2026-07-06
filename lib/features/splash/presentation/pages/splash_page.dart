import 'package:flutter/material.dart';
import '../widgets/splash_image.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _navigate(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashImage(onCompleted: () => _navigate(context)));
  }
}
