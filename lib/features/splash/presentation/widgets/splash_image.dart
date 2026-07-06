import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  final VoidCallback onCompleted;

  const SplashImage({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        onCompleted();
      }
    });

    return SizedBox.expand(
      child: Image.asset(
        'assets/images/splash_mall_companion.png', // Change to your image name
        fit: BoxFit.cover,
      ),
    );
  }
}
