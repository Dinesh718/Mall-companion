import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  final VoidCallback onCenter;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
    required this.onCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      right: 24.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Center Map Button
          FloatingActionButton.small(
            heroTag: 'map_center_btn',
            backgroundColor: const Color(0xFFFEF7FF),
            foregroundColor: const Color(0xFF6100D6),
            onPressed: onCenter,
            child: const Icon(Icons.center_focus_strong_outlined),
          ),
          const SizedBox(height: 8.0),

          // Reset View Button
          FloatingActionButton.small(
            heroTag: 'map_reset_btn',
            backgroundColor: const Color(0xFFFEF7FF),
            foregroundColor: const Color(0xFF6100D6),
            onPressed: onReset,
            child: const Icon(Icons.refresh_outlined),
          ),
          const SizedBox(height: 16.0),

          // Zoom In Button
          FloatingActionButton.small(
            heroTag: 'map_zoomin_btn',
            backgroundColor: const Color(0xFF6100D6),
            foregroundColor: Colors.white,
            onPressed: onZoomIn,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8.0),

          // Zoom Out Button
          FloatingActionButton.small(
            heroTag: 'map_zoomout_btn',
            backgroundColor: const Color(0xFF6100D6),
            foregroundColor: Colors.white,
            onPressed: onZoomOut,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
