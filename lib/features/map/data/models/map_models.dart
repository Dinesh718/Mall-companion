import '../../domain/entities/map_entities.dart';

abstract class GeometryModel extends GeometryEntity {
  const GeometryModel();

  factory GeometryModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'rectangle';
    if (type == 'polygon') {
      return PolygonGeometryModel.fromJson(json);
    } else {
      return RectangleGeometryModel.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class RectangleGeometryModel extends RectangleGeometry
    implements GeometryModel {
  const RectangleGeometryModel({
    required super.x,
    required super.y,
    required super.width,
    required super.height,
  });

  factory RectangleGeometryModel.fromJson(Map<String, dynamic> json) {
    return RectangleGeometryModel(
      x: (json['x'] as num? ?? 0.0).toDouble(),
      y: (json['y'] as num? ?? 0.0).toDouble(),
      width: (json['width'] as num? ?? 0.0).toDouble(),
      height: (json['height'] as num? ?? 0.0).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'rectangle',
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }

  RectangleGeometryModel copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    return RectangleGeometryModel(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

class PolygonGeometryModel extends PolygonGeometry implements GeometryModel {
  const PolygonGeometryModel({required super.points});

  factory PolygonGeometryModel.fromJson(Map<String, dynamic> json) {
    final pointsList = json['points'] as List<dynamic>? ?? [];
    final points = pointsList.map((pt) {
      final x = (pt['x'] as num? ?? 0.0).toDouble();
      final y = (pt['y'] as num? ?? 0.0).toDouble();
      return Point2D(x, y);
    }).toList();
    return PolygonGeometryModel(points: points);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'polygon',
      'points': points.map((p) => {'x': p.x, 'y': p.y}).toList(),
    };
  }

  PolygonGeometryModel copyWith({List<Point2D>? points}) {
    return PolygonGeometryModel(points: points ?? this.points);
  }
}

class ShopModel extends ShopEntity {
  const ShopModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.status,
    required super.rating,
    required super.offer,
    required GeometryModel super.geometry,
    required super.entranceNodeIds,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    final geomJson = json['geometry'] as Map<String, dynamic>?;
    final GeometryModel geom = geomJson != null
        ? GeometryModel.fromJson(geomJson)
        : const RectangleGeometryModel(x: 0, y: 0, width: 0, height: 0);

    final entranceList = json['entranceNodeIds'] as List<dynamic>? ?? [];
    final entranceNodeIds = entranceList.map((e) => e.toString()).toList();

    return ShopModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      offer: json['offer'] as String? ?? 'No Active Offer',
      geometry: geom,
      entranceNodeIds: entranceNodeIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'status': status,
      'rating': rating,
      'offer': offer,
      'geometry': (geometry as GeometryModel).toJson(),
      'entranceNodeIds': entranceNodeIds,
    };
  }

  ShopModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? status,
    double? rating,
    String? offer,
    GeometryModel? geometry,
    List<String>? entranceNodeIds,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      offer: offer ?? this.offer,
      geometry: geometry ?? (this.geometry as GeometryModel),
      entranceNodeIds: entranceNodeIds ?? this.entranceNodeIds,
    );
  }
}

class NavigationNodeModel extends NavigationNodeEntity {
  const NavigationNodeModel({
    required super.id,
    required super.x,
    required super.y,
    required super.floorId,
    required super.type,
  });

  factory NavigationNodeModel.fromJson(Map<String, dynamic> json) {
    return NavigationNodeModel(
      id: json['id'] as String? ?? '',
      x: (json['x'] as num? ?? 0.0).toDouble(),
      y: (json['y'] as num? ?? 0.0).toDouble(),
      floorId: json['floorId'] as String? ?? '',
      type: json['type'] as String? ?? 'hallway',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'x': x, 'y': y, 'floorId': floorId, 'type': type};
  }

  NavigationNodeModel copyWith({
    String? id,
    double? x,
    double? y,
    String? floorId,
    String? type,
  }) {
    return NavigationNodeModel(
      id: id ?? this.id,
      x: x ?? this.x,
      y: y ?? this.y,
      floorId: floorId ?? this.floorId,
      type: type ?? this.type,
    );
  }
}

class NavigationEdgeModel extends NavigationEdgeEntity {
  const NavigationEdgeModel({
    required super.fromNodeId,
    required super.toNodeId,
    required super.distance,
  });

  factory NavigationEdgeModel.fromJson(Map<String, dynamic> json) {
    return NavigationEdgeModel(
      fromNodeId: json['fromNodeId'] as String? ?? '',
      toNodeId: json['toNodeId'] as String? ?? '',
      distance: (json['distance'] as num? ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromNodeId': fromNodeId,
      'toNodeId': toNodeId,
      'distance': distance,
    };
  }

  NavigationEdgeModel copyWith({
    String? fromNodeId,
    String? toNodeId,
    double? distance,
  }) {
    return NavigationEdgeModel(
      fromNodeId: fromNodeId ?? this.fromNodeId,
      toNodeId: toNodeId ?? this.toNodeId,
      distance: distance ?? this.distance,
    );
  }
}

class NavigationGraphModel extends NavigationGraphEntity {
  const NavigationGraphModel({
    required List<NavigationNodeModel> super.nodes,
    required List<NavigationEdgeModel> super.edges,
  });

  factory NavigationGraphModel.fromJson(Map<String, dynamic> json) {
    final nodesList = json['nodes'] as List<dynamic>? ?? [];
    final edgesList = json['edges'] as List<dynamic>? ?? [];
    return NavigationGraphModel(
      nodes: nodesList
          .map((n) => NavigationNodeModel.fromJson(n as Map<String, dynamic>))
          .toList(),
      edges: edgesList
          .map((e) => NavigationEdgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((n) => (n as NavigationNodeModel).toJson()).toList(),
      'edges': edges.map((e) => (e as NavigationEdgeModel).toJson()).toList(),
    };
  }

  NavigationGraphModel copyWith({
    List<NavigationNodeModel>? nodes,
    List<NavigationEdgeModel>? edges,
  }) {
    return NavigationGraphModel(
      nodes: nodes ?? this.nodes.map((n) => n as NavigationNodeModel).toList(),
      edges: edges ?? this.edges.map((e) => e as NavigationEdgeModel).toList(),
    );
  }
}

class ConnectorModel extends ConnectorEntity {
  const ConnectorModel({
    required super.id,
    required super.floorId,
    required super.navigationNodeId,
    super.connectedConnectorId,
    required super.connectorType,
    required super.accessible,
    super.metadata,
  });

  factory ConnectorModel.fromJson(Map<String, dynamic> json) {
    return ConnectorModel(
      id: json['id'] as String? ?? '',
      floorId: json['floorId'] as String? ?? '',
      navigationNodeId: json['navigationNodeId'] as String? ?? '',
      connectedConnectorId: json['connectedConnectorId'] as String?,
      connectorType: json['connectorType'] as String? ?? 'escalator',
      accessible: json['accessible'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floorId': floorId,
      'navigationNodeId': navigationNodeId,
      if (connectedConnectorId != null)
        'connectedConnectorId': connectedConnectorId,
      'connectorType': connectorType,
      'accessible': accessible,
      if (metadata != null) 'metadata': metadata,
    };
  }

  ConnectorModel copyWith({
    String? id,
    String? floorId,
    String? navigationNodeId,
    String? connectedConnectorId,
    String? connectorType,
    bool? accessible,
    Map<String, dynamic>? metadata,
  }) {
    return ConnectorModel(
      id: id ?? this.id,
      floorId: floorId ?? this.floorId,
      navigationNodeId: navigationNodeId ?? this.navigationNodeId,
      connectedConnectorId: connectedConnectorId ?? this.connectedConnectorId,
      connectorType: connectorType ?? this.connectorType,
      accessible: accessible ?? this.accessible,
      metadata: metadata ?? this.metadata,
    );
  }
}

class FloorModel extends FloorEntity {
  const FloorModel({
    required super.id,
    required super.name,
    required super.svgPath,
    required List<ShopModel> super.shops,
    required NavigationGraphModel super.navigationGraph,
    required List<ConnectorModel> super.connectors,
  });

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    final navJson = json['navigation'] as Map<String, dynamic>?;
    final NavigationGraphModel navGraph = navJson != null
        ? NavigationGraphModel.fromJson(navJson)
        : const NavigationGraphModel(nodes: [], edges: []);

    final connList = json['connectors'] as List<dynamic>? ?? [];
    final List<ConnectorModel> connectors = connList
        .map((c) => ConnectorModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return FloorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      svgPath: json['svgPath'] as String? ?? '',
      shops: (json['shops'] as List<dynamic>? ?? [])
          .map((s) => ShopModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      navigationGraph: navGraph,
      connectors: connectors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'svgPath': svgPath,
      'shops': shops.map((s) => (s as ShopModel).toJson()).toList(),
      'navigation': (navigationGraph as NavigationGraphModel).toJson(),
      'connectors': connectors
          .map((c) => (c as ConnectorModel).toJson())
          .toList(),
    };
  }

  FloorModel copyWith({
    String? id,
    String? name,
    String? svgPath,
    List<ShopModel>? shops,
    NavigationGraphModel? navigationGraph,
    List<ConnectorModel>? connectors,
  }) {
    return FloorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      svgPath: svgPath ?? this.svgPath,
      shops: shops ?? this.shops.map((s) => s as ShopModel).toList(),
      navigationGraph:
          navigationGraph ?? (this.navigationGraph as NavigationGraphModel),
      connectors:
          connectors ??
          this.connectors.map((c) => c as ConnectorModel).toList(),
    );
  }
}

class MapModel extends MapEntity {
  const MapModel({required super.id, required List<FloorModel> super.floors});

  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      id: json['id'] as String? ?? '',
      floors: (json['floors'] as List<dynamic>? ?? [])
          .map((f) => FloorModel.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floors': floors.map((f) => (f as FloorModel).toJson()).toList(),
    };
  }

  MapModel copyWith({String? id, List<FloorModel>? floors}) {
    return MapModel(
      id: id ?? this.id,
      floors: floors ?? this.floors.map((f) => f as FloorModel).toList(),
    );
  }
}
