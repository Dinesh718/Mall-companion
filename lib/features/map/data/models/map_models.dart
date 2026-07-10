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
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    final geomJson = json['geometry'] as Map<String, dynamic>?;
    final GeometryModel geom = geomJson != null
        ? GeometryModel.fromJson(geomJson)
        : const RectangleGeometryModel(x: 0, y: 0, width: 0, height: 0);

    return ShopModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      offer: json['offer'] as String? ?? 'No Active Offer',
      geometry: geom,
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
    );
  }
}

class FloorModel extends FloorEntity {
  const FloorModel({
    required super.id,
    required super.name,
    required super.svgPath,
    required List<ShopModel> super.shops,
  });

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    return FloorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      svgPath: json['svgPath'] as String? ?? '',
      shops: (json['shops'] as List<dynamic>? ?? [])
          .map((s) => ShopModel.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'svgPath': svgPath,
      'shops': shops.map((s) => (s as ShopModel).toJson()).toList(),
    };
  }

  FloorModel copyWith({
    String? id,
    String? name,
    String? svgPath,
    List<ShopModel>? shops,
  }) {
    return FloorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      svgPath: svgPath ?? this.svgPath,
      shops: shops ?? this.shops.map((s) => s as ShopModel).toList(),
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
