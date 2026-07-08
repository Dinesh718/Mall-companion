import 'package:flutter/material.dart';

class StoreActionButtons extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onShare;
  final VoidCallback onNavigate;

  const StoreActionButtons({
    super.key,
    required this.onCall,
    required this.onShare,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 16.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF).withOpacity(0.85), // glass overlay
        border: Border(
          top: BorderSide(
            color: const Color(0xFFCCC3D9).withOpacity(0.15),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // Call Icon button
          GestureDetector(
            onTap: onCall,
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE5F5), // surface-container-high
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.call_outlined,
                color: Color(0xFF4A4456), // on-surface-variant
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // Share Icon button
          GestureDetector(
            onTap: onShare,
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: const Color(0xFFEDE5F5), // surface-container-high
                borderRadius: BorderRadius.circular(16.0), // rounded-2xl
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.share_outlined,
                color: Color(0xFF4A4456), // on-surface-variant
              ),
            ),
          ),
          const SizedBox(width: 16.0),

          // Navigate Button
          Expanded(
            child: GestureDetector(
              onTap: onNavigate,
              child: Container(
                height: 56.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6100D6),
                      Color(0xFF0058BE),
                    ], // primary-gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6100D6).withOpacity(0.25),
                      blurRadius: 16.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.near_me, color: Colors.white, size: 20.0),
                    SizedBox(width: 8.0),
                    Text(
                      'Navigate to Store',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
