import 'dart:math';
import '../entities/map_entities.dart';
import '../entities/route_preview_entities.dart';

class RoutePreviewService {
  static NavigationPreviewEntity generatePreview({
    required NavigationRouteEntity route,
    required List<FloorEntity> floors,
    required String destinationShopId,
    double walkingSpeedMetersPerMin = 70.0,
  }) {
    final nodes = route.completeRoute;
    if (nodes.isEmpty) {
      return NavigationPreviewEntity(
        route: route,
        statistics: const RouteStatisticsEntity(
          totalDistance: 0.0,
          estimatedWalkingTimeMinutes: 0,
          floorCount: 0,
          connectorCount: 0,
          connectorNames: [],
          destinationName: 'Destination',
          floorSummary: 'Same Floor',
        ),
        bounds: const RouteBoundsEntity(
          minX: 0.0,
          maxX: 0.0,
          minY: 0.0,
          maxY: 0.0,
        ),
        isPreviewReady: false,
      );
    }

    // 1. Calculate Route Bounds
    double minX = nodes.first.x;
    double maxX = nodes.first.x;
    double minY = nodes.first.y;
    double maxY = nodes.first.y;

    for (final node in nodes) {
      minX = min(minX, node.x);
      maxX = max(maxX, node.x);
      minY = min(minY, node.y);
      maxY = max(maxY, node.y);
    }

    final bounds = RouteBoundsEntity(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
    );

    // 2. Calculate Distance and Estimated Time
    final totalDistance = route.totalDistance;
    final estimatedTime = (totalDistance / walkingSpeedMetersPerMin).ceil();
    final estimatedWalkingTimeMinutes = max(1, estimatedTime);

    // 3. Find Destination Name
    String destinationName = '';
    for (final floor in floors) {
      for (final shop in floor.shops) {
        if (shop.id == destinationShopId) {
          destinationName = shop.name;
          break;
        }
      }
      if (destinationName.isNotEmpty) break;
    }
    if (destinationName.isEmpty) {
      destinationName = 'Destination';
    }

    // 4. Extract Floors and Connectors
    final List<String> floorNames = [];
    final List<String> connectorNames = [];

    for (final segment in route.segments) {
      if (segment.floorId == 'transition') {
        // Transition Segment - find connector name
        final sourceNode = segment.nodes.first;
        String connName = 'Connector';
        for (final floor in floors) {
          for (final conn in floor.connectors) {
            if (conn.navigationNodeId == sourceNode.id) {
              connName = '${conn.connectorType.toUpperCase()} (${floor.name})';
              break;
            }
          }
        }
        if (!connectorNames.contains(connName)) {
          connectorNames.add(connName);
        }
      } else {
        // Floor Segment
        final matchingFloors = floors.where((f) => f.id == segment.floorId);
        final floorName = matchingFloors.isNotEmpty
            ? matchingFloors.first.name
            : segment.floorId;
        if (!floorNames.contains(floorName)) {
          floorNames.add(floorName);
        }
      }
    }

    final floorSummary = floorNames.length > 1
        ? floorNames.join(' → ')
        : (floorNames.isNotEmpty ? floorNames.first : 'Same Floor');

    final statistics = RouteStatisticsEntity(
      totalDistance: totalDistance,
      estimatedWalkingTimeMinutes: estimatedWalkingTimeMinutes,
      floorCount: floorNames.length,
      connectorCount: connectorNames.length,
      connectorNames: connectorNames,
      destinationName: destinationName,
      floorSummary: floorSummary,
    );

    return NavigationPreviewEntity(
      route: route,
      statistics: statistics,
      bounds: bounds,
      isPreviewReady: true,
    );
  }
}
