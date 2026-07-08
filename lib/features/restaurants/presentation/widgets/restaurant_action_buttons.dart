import 'dart:ui';
import 'package:flutter/material.dart';

class RestaurantActionButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onNavigate;
  final VoidCallback onReserve;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const RestaurantActionButtons({
    super.key,
    required this.isFavorite,
    required this.onNavigate,
    required this.onReserve,
    required this.onFavorite,
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Main Action Button (Reserve Table)
              Expanded(
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF2170E4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0),
                    child: InkWell(
                      onTap: onReserve,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.event_seat, color: Colors.white, size: 18.0),
                          SizedBox(width: 8.0),
                          Text(
                            'Book Table',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
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

              // Navigate Shortcut Button
              GestureDetector(
                onTap: onNavigate,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5F5), // surface-container-high
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.near_me_outlined,
                    color: Color(0xFF6100D6),
                    size: 20.0,
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
                    color: Color(0xFFEDE5F5),
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

              // Favorite Button (Heart Icon)
              GestureDetector(
                onTap: onFavorite,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                    color: isFavorite ? Colors.red : const Color(0xFF6100D6),
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
