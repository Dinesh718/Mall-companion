import 'dart:ui';
import 'package:flutter/material.dart';

class EventActionButtons extends StatelessWidget {
  final bool isInterested;
  final bool isReminderSet;
  final VoidCallback onNavigate;
  final VoidCallback onInterested;
  final VoidCallback onToggleReminder;
  final VoidCallback onShare;

  const EventActionButtons({
    super.key,
    required this.isInterested,
    required this.isReminderSet,
    required this.onNavigate,
    required this.onInterested,
    required this.onToggleReminder,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0), // fully rounded pill
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75), // glass transparency
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8.0), // p-2
          child: Row(
            children: [
              // Main Action Button (Navigate)
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7423F0), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0),
                    child: InkWell(
                      onTap: onNavigate,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                           Icon(Icons.near_me, color: Colors.white, size: 18.0),
                           SizedBox(width: 8.0),
                           Text(
                            'Navigate to Event',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600, // label-lg
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // Share Button
              GestureDetector(
                onTap: onShare,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5F5), // surface-container-high
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    color: Color(0xFF6100D6),
                    size: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // Reminder Button
              GestureDetector(
                onTap: onToggleReminder,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5F5), // surface-container-high
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isReminderSet
                        ? Icons.notifications_active
                        : Icons.notifications_outlined,
                    color: isReminderSet ? const Color(0xFFBA1A1A) : const Color(0xFF6100D6),
                    size: 20.0,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // Interested Button (Heart Icon)
              GestureDetector(
                onTap: onInterested,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5F5), // surface-container-high
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isInterested
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    color: isInterested ? Colors.red : const Color(0xFF6100D6),
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
