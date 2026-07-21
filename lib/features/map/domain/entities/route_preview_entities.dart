import 'package:equatable/equatable.dart';
import 'map_entities.dart';

class RouteBoundsEntity extends Equatable {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  const RouteBoundsEntity({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  @override
  List<Object?> get props => [minX, maxX, minY, maxY];
}

class RouteStatisticsEntity extends Equatable {
  final double totalDistance;
  final int estimatedWalkingTimeMinutes;
  final int floorCount;
  final int connectorCount;
  final List<String> connectorNames;
  final String destinationName;
  final String floorSummary;

  const RouteStatisticsEntity({
    required this.totalDistance,
    required this.estimatedWalkingTimeMinutes,
    required this.floorCount,
    required this.connectorCount,
    required this.connectorNames,
    required this.destinationName,
    required this.floorSummary,
  });

  @override
  List<Object?> get props => [
    totalDistance,
    estimatedWalkingTimeMinutes,
    floorCount,
    connectorCount,
    connectorNames,
    destinationName,
    floorSummary,
  ];
}

class NavigationPreviewEntity extends Equatable {
  final NavigationRouteEntity route;
  final RouteStatisticsEntity statistics;
  final RouteBoundsEntity bounds;
  final bool isPreviewReady;

  const NavigationPreviewEntity({
    required this.route,
    required this.statistics,
    required this.bounds,
    this.isPreviewReady = true,
  });

  @override
  List<Object?> get props => [route, statistics, bounds, isPreviewReady];
}
