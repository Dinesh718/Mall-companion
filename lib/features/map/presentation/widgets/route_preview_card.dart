import 'package:flutter/material.dart';
import '../../domain/entities/route_preview_entities.dart';

class RoutePreviewCard extends StatelessWidget {
  final NavigationPreviewEntity preview;
  final VoidCallback onStartNavigation;
  final VoidCallback onClose;

  static const Color primaryColor = Color(0xFF6100D6);
  static const Color surfaceColor = Color(0xFFFEF7FF);
  static const Color textPrimaryColor = Color(0xFF1D1B20);
  static const Color textSecondaryColor = Color(0xFF49454F);

  const RoutePreviewCard({
    super.key,
    required this.preview,
    required this.onStartNavigation,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final stats = preview.statistics;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Destination Name & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route Preview',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      stats.destinationName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                color: textSecondaryColor,
                tooltip: 'Close Preview',
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 1.0, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16.0),

          // Metrics Row: Distance, Time, Floors
          Row(
            children: [
              _MetricItem(
                icon: Icons.directions_walk_rounded,
                value: '${stats.totalDistance.round()} m',
                label: 'Distance',
              ),
              const SizedBox(width: 24.0),
              _MetricItem(
                icon: Icons.access_time_filled_rounded,
                value: '${stats.estimatedWalkingTimeMinutes} min',
                label: 'Walking Time',
              ),
              const SizedBox(width: 24.0),
              _MetricItem(
                icon: Icons.layers_rounded,
                value: stats.floorSummary,
                label: 'Floors',
              ),
            ],
          ),

          if (stats.connectorNames.isNotEmpty) ...[
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Icon(
                  Icons.elevator_rounded,
                  size: 18,
                  color: primaryColor,
                ),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    'Connector: ${stats.connectorNames.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20.0),

          // Primary Button: START NAVIGATION
          SizedBox(
            width: double.infinity,
            height: 52.0,
            child: ElevatedButton.icon(
              onPressed: () {
                debugPrint('START NAVIGATION PRESSED');
                onStartNavigation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              icon: const Icon(Icons.navigation_rounded),
              label: const Text(
                'START NAVIGATION',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: RoutePreviewCard.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(icon, color: RoutePreviewCard.primaryColor, size: 20.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: RoutePreviewCard.textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: RoutePreviewCard.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
