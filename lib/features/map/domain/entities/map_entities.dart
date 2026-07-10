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

  const ShopEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.status,
    required this.rating,
    required this.offer,
    required this.geometry,
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
  ];
}

class FloorEntity extends Equatable {
  final String id;
  final String name;
  final String svgPath;
  final List<ShopEntity> shops;

  const FloorEntity({
    required this.id,
    required this.name,
    required this.svgPath,
    required this.shops,
  });

  @override
  List<Object?> get props => [id, name, svgPath, shops];
}

class MapEntity extends Equatable {
  final String id;
  final List<FloorEntity> floors;

  const MapEntity({required this.id, required this.floors});

  @override
  List<Object?> get props => [id, floors];
}
