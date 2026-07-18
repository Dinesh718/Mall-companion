import 'package:equatable/equatable.dart';

class Point2D extends Equatable {
  final double x;
  final double y;

  const Point2D(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}

abstract class GeometryEntity extends Equatable {
  const GeometryEntity();

  bool contains(Point2D point);
}

class RectangleGeometry extends GeometryEntity {
  final double x;
  final double y;
  final double width;
  final double height;

  const RectangleGeometry({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  @override
  bool contains(Point2D point) {
    return point.x >= x &&
        point.x <= x + width &&
        point.y >= y &&
        point.y <= y + height;
  }

  @override
  List<Object?> get props => [x, y, width, height];
}

class PolygonGeometry extends GeometryEntity {
  final List<Point2D> points;

  const PolygonGeometry({required this.points});

  @override
  bool contains(Point2D point) {
    if (points.isEmpty) return false;
    bool isInside = false;
    int j = points.length - 1;
    for (int i = 0; i < points.length; i++) {
      if ((points[i].y > point.y) != (points[j].y > point.y) &&
          (point.x <
              (points[j].x - points[i].x) *
                      (point.y - points[i].y) /
                      (points[j].y - points[i].y) +
                  points[i].x)) {
        isInside = !isInside;
      }
      j = i;
    }
    return isInside;
  }

  @override
  List<Object?> get props => [points];
}

class ShopEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String status;
  final double rating;
  final String offer;
  final GeometryEntity geometry;
  final List<String> entranceNodeIds;

  const ShopEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.status,
    required this.rating,
    required this.offer,
    required this.geometry,
    required this.entranceNodeIds,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    description,
    status,
    rating,
    offer,
    geometry,
    entranceNodeIds,
  ];
}

class NavigationNodeEntity extends Equatable {
  final String id;
  final double x;
  final double y;
  final String floorId;
  final String type;

  const NavigationNodeEntity({
    required this.id,
    required this.x,
    required this.y,
    required this.floorId,
    required this.type,
  });

  @override
  List<Object?> get props => [id, x, y, floorId, type];
}

class NavigationEdgeEntity extends Equatable {
  final String fromNodeId;
  final String toNodeId;
  final double distance;

  const NavigationEdgeEntity({
    required this.fromNodeId,
    required this.toNodeId,
    required this.distance,
  });

  @override
  List<Object?> get props => [fromNodeId, toNodeId, distance];
}

class NavigationGraphEntity extends Equatable {
  final List<NavigationNodeEntity> nodes;
  final List<NavigationEdgeEntity> edges;

  const NavigationGraphEntity({required this.nodes, required this.edges});

  @override
  List<Object?> get props => [nodes, edges];
}

class ConnectorEntity extends Equatable {
  final String id;
  final String floorId;
  final String navigationNodeId;
  final String? connectedConnectorId;
  final String connectorType;
  final bool accessible;
  final Map<String, dynamic>? metadata;

  const ConnectorEntity({
    required this.id,
    required this.floorId,
    required this.navigationNodeId,
    this.connectedConnectorId,
    required this.connectorType,
    required this.accessible,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    floorId,
    navigationNodeId,
    connectedConnectorId,
    connectorType,
    accessible,
    metadata,
  ];
}

class RouteSegmentEntity extends Equatable {
  final String floorId;
  final List<NavigationNodeEntity> nodes;

  const RouteSegmentEntity({required this.floorId, required this.nodes});

  @override
  List<Object?> get props => [floorId, nodes];
}

class NavigationRouteEntity extends Equatable {
  final List<NavigationNodeEntity> completeRoute;
  final List<RouteSegmentEntity> segments;
  final double totalDistance;
  final String? destinationMetadata;

  const NavigationRouteEntity({
    required this.completeRoute,
    required this.segments,
    required this.totalDistance,
    this.destinationMetadata,
  });

  @override
  List<Object?> get props => [
    completeRoute,
    segments,
    totalDistance,
    destinationMetadata,
  ];
}

class FloorEntity extends Equatable {
  final String id;
  final String name;
  final String svgPath;
  final List<ShopEntity> shops;
  final NavigationGraphEntity navigationGraph;
  final List<ConnectorEntity> connectors;

  const FloorEntity({
    required this.id,
    required this.name,
    required this.svgPath,
    required this.shops,
    required this.navigationGraph,
    required this.connectors,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    svgPath,
    shops,
    navigationGraph,
    connectors,
  ];
}

class MapEntity extends Equatable {
  final String id;
  final List<FloorEntity> floors;

  const MapEntity({required this.id, required this.floors});

  @override
  List<Object?> get props => [id, floors];
}

enum NavigationStatus {
  idle,
  calculating,
  navigating,
  waitingForConnector,
  transitioningFloor,
  recalculating,
  arrived,
  cancelled,
}

class NavigationSessionEntity extends Equatable {
  final String destinationShopId;
  final String destinationEntranceId;
  final NavigationRouteEntity route;
  final List<RouteSegmentEntity> segments;
  final int currentSegmentIndex;
  final String currentFloorId;
  final String? nextConnectorId;
  final double remainingDistance;
  final double estimatedWalkingDistance;
  final NavigationStatus navigationStatus;

  const NavigationSessionEntity({
    required this.destinationShopId,
    required this.destinationEntranceId,
    required this.route,
    required this.segments,
    required this.currentSegmentIndex,
    required this.currentFloorId,
    this.nextConnectorId,
    required this.remainingDistance,
    required this.estimatedWalkingDistance,
    required this.navigationStatus,
  });

  RouteSegmentEntity? get activeSegment {
    if (currentSegmentIndex >= 0 && currentSegmentIndex < segments.length) {
      return segments[currentSegmentIndex];
    }
    return null;
  }

  @override
  List<Object?> get props => [
    destinationShopId,
    destinationEntranceId,
    route,
    segments,
    currentSegmentIndex,
    currentFloorId,
    nextConnectorId,
    remainingDistance,
    estimatedWalkingDistance,
    navigationStatus,
  ];
}
