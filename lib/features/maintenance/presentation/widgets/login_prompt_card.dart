import 'package:flutter/material.dart';

class LoginPromptCard extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onContinueAsGuestTap;

  const LoginPromptCard({
    super.key,
    required this.onLoginTap,
    required this.onContinueAsGuestTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: const Color(
            0xFFD3E4FE,
          ).withOpacity(0.5), // border border-surface-variant/30
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Illustration Placeholder
          Container(
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF), // bg-surface-container-low
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Blueprint background lines
                CustomPaint(
                  size: const Size(double.infinity, 180.0),
                  painter: _BlueprintGridPainter(),
                ),
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAfbz0Z7FscWco9_PMV29IKl5ATLzS6qRwXu9XJY0KGR0QnCKXWg7vRSaG8SFjukcyXwHe83bD-b3MCf6epc20oFa0eEQgIhrAqct2Ik-MizEKsj3RnICOPq4Bv9XDQn95_tyXNn-TNPFOk4NdszbvIJ9G_sEUPqOPYHH8AOdVcJ5vvr7EU0O1nBXU4iTOmqt3ik7S1gL7H26K9wtqLI_6twg0aZ96_VTR3cZfugW3yRx63TU0LkfIDn6cz0icfVmOMtJio7arXGQ',
                  width: 160.0,
                  height: 160.0,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          const Text(
            'Login to Track Your Reports',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22.0, // headline-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30), // on-surface
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Sign in to access ticket history, receive status updates and synchronize reports across devices.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32.0),
          // Action Buttons
          GestureDetector(
            onTap: onLoginTap,
            child: Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999.0), // rounded-full
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7B2FF7),
                    Color(0xFF3B82F6),
                  ], // primary-gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Login / Sign Up',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.0, // label-lg
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: onContinueAsGuestTap,
            child: const Text(
              'Continue as guest',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.0, // label-sm
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B7488), // outline
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlueprintGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0058BE).withOpacity(0.04)
      ..strokeWidth = 1.0;

    double gridSpacing = 20.0;

    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
