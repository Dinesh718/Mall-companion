import 'package:flutter/material.dart';

class LoginBenefitsCard extends StatelessWidget {
  final VoidCallback onLoginTap;

  const LoginBenefitsCard({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE5F5), // surface-container-high
        borderRadius: BorderRadius.circular(28.0), // rounded-xxl (28px)
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.3),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(24.0), // p-6
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Simulated 3D car illustration or icon
          Container(
            width: 80.0,
            height: 80.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_sync_rounded,
              color: Color(0xFF6100D6),
              size: 40.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Unlock Smart Parking',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20.0, // headline-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Sign in to save your vehicle location across devices and access premium valet services.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton(
              onPressed: onLoginTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6100D6), // primary
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0.0,
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14.0, // label-lg
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
