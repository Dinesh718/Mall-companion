import 'package:flutter/material.dart';

class EmergencyShortcutButton extends StatefulWidget {
  final VoidCallback onTap;

  const EmergencyShortcutButton({super.key, required this.onTap});

  @override
  State<EmergencyShortcutButton> createState() =>
      _EmergencyShortcutButtonState();
}

class _EmergencyShortcutButtonState extends State<EmergencyShortcutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsating outer ring
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 56.0 + (28.0 * _controller.value),
              height: 56.0 + (28.0 * _controller.value),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFBA1A1A,
                ).withOpacity(0.4 * (1.0 - _controller.value)),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
        // Central Button
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: const Color(0xFFBA1A1A), // error red
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBA1A1A).withOpacity(0.3),
                  blurRadius: 15.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'SOS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
