import 'package:flutter/material.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.0), // rounded-card
          border: Border.all(
            color: const Color(0xFFFFDAD6), // border-error-container
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Color(0xFFBA1A1A), // error
              size: 24.0,
            ),
            SizedBox(width: 12.0),
            Text(
              'Logout from Device',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16.0, // body-lg
                fontWeight: FontWeight.bold,
                color: Color(0xFFBA1A1A), // error
              ),
            ),
          ],
        ),
      ),
    );
  }
}
