import 'package:flutter/material.dart';

class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.0,
            height: 1.5,
            color: Color(0xFF6B7280),
          ),
          children: [
            TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6100D6),
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6100D6),
              ),
            ),
            TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
