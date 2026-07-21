import '../../domain/entities/map_entities.dart';
import 'map_models.dart';

class NavigationSessionModel extends NavigationSessionEntity {
  const NavigationSessionModel({
    required super.destinationShopId,
    required super.destinationEntranceId,
    required super.route,
    required super.segments,
    required super.currentSegmentIndex,
    super.currentRouteNodeIndex = 0,
    required super.currentFloorId,
    super.nextConnectorId,
    required super.remainingDistance,
    required super.estimatedWalkingDistance,
    required super.navigationStatus,
  });

  factory NavigationSessionModel.fromJson(Map<String, dynamic> json) {
    // Parse navigation status enum safely
    final statusStr = json['navigationStatus'] as String? ?? 'idle';
    final navigationStatus = NavigationStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => NavigationStatus.idle,
    );

    // Deep-cast segments
    final segsList = json['segments'] as List<dynamic>? ?? [];
    final List<RouteSegmentEntity> segments = segsList.map((s) {
      final map = s as Map<String, dynamic>;
      final nodesList = map['nodes'] as List<dynamic>? ?? [];
      final nodes = nodesList
          .map((n) => NavigationNodeModel.fromJson(n as Map<String, dynamic>))
          .toList();
      return RouteSegmentEntity(
        floorId: map['floorId'] as String? ?? '',
        nodes: nodes,
      );
    }).toList();

    // Deep-cast complete route nodes
    final routeMap = json['route'] as Map<String, dynamic>? ?? {};
    final compNodesList = routeMap['completeRoute'] as List<dynamic>? ?? [];
    final completeRoute = compNodesList
        .map((n) => NavigationNodeModel.fromJson(n as Map<String, dynamic>))
        .toList();

    // Reconstruct NavigationRouteEntity
    final routeEntity = NavigationRouteEntity(
      completeRoute: completeRoute,
      segments: segments,
      totalDistance: (routeMap['totalDistance'] as num? ?? 0.0).toDouble(),
      destinationMetadata: routeMap['destinationMetadata'] as String?,
    );

    return NavigationSessionModel(
      destinationShopId: json['destinationShopId'] as String? ?? '',
      destinationEntranceId: json['destinationEntranceId'] as String? ?? '',
      route: routeEntity,
      segments: segments,
      currentSegmentIndex: json['currentSegmentIndex'] as int? ?? 0,
      currentRouteNodeIndex: json['currentRouteNodeIndex'] as int? ?? 0,
      currentFloorId: json['currentFloorId'] as String? ?? '',
      nextConnectorId: json['nextConnectorId'] as String?,
      remainingDistance: (json['remainingDistance'] as num? ?? 0.0).toDouble(),
      estimatedWalkingDistance:
          (json['estimatedWalkingDistance'] as num? ?? 0.0).toDouble(),
      navigationStatus: navigationStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destinationShopId': destinationShopId,
      'destinationEntranceId': destinationEntranceId,
      'route': {
        'completeRoute': route.completeRoute
            .map(
              (n) => {
                'id': n.id,
                'x': n.x,
                'y': n.y,
                'floorId': n.floorId,
                'type': n.type,
              },
            )
            .toList(),
        'totalDistance': route.totalDistance,
        if (route.destinationMetadata != null)
          'destinationMetadata': route.destinationMetadata,
      },
      'segments': segments.map((s) {
        return {
          'floorId': s.floorId,
          'nodes': s.nodes
              .map(
                (n) => {
                  'id': n.id,
                  'x': n.x,
                  'y': n.y,
                  'floorId': n.floorId,
                  'type': n.type,
                },
              )
              .toList(),
        };
      }).toList(),
      'currentSegmentIndex': currentSegmentIndex,
      'currentRouteNodeIndex': currentRouteNodeIndex,
      'currentFloorId': currentFloorId,
      if (nextConnectorId != null) 'nextConnectorId': nextConnectorId,
      'remainingDistance': remainingDistance,
      'estimatedWalkingDistance': estimatedWalkingDistance,
      'navigationStatus': navigationStatus.name,
    };
  }

  @override
  NavigationSessionModel copyWith({
    String? destinationShopId,
    String? destinationEntranceId,
    NavigationRouteEntity? route,
    List<RouteSegmentEntity>? segments,
    int? currentSegmentIndex,
    int? currentRouteNodeIndex,
    String? currentFloorId,
    String? nextConnectorId,
    double? remainingDistance,
    double? estimatedWalkingDistance,
    NavigationStatus? navigationStatus,
  }) {
    return NavigationSessionModel(
      destinationShopId: destinationShopId ?? this.destinationShopId,
      destinationEntranceId:
          destinationEntranceId ?? this.destinationEntranceId,
      route: route ?? this.route,
      segments: segments ?? this.segments,
      currentSegmentIndex: currentSegmentIndex ?? this.currentSegmentIndex,
      currentRouteNodeIndex:
          currentRouteNodeIndex ?? this.currentRouteNodeIndex,
      currentFloorId: currentFloorId ?? this.currentFloorId,
      nextConnectorId: nextConnectorId ?? this.nextConnectorId,
      remainingDistance: remainingDistance ?? this.remainingDistance,
      estimatedWalkingDistance:
          estimatedWalkingDistance ?? this.estimatedWalkingDistance,
      navigationStatus: navigationStatus ?? this.navigationStatus,
    );
  }
}
