import 'dart:math';
import 'package:equatable/equatable.dart';
import '../entities/route_preview_entities.dart';

class MapCameraFitEntity extends Equatable {
  final double centerX;
  final double centerY;
  final double recommendedScale;

  const MapCameraFitEntity({
    required this.centerX,
    required this.centerY,
    required this.recommendedScale,
  });

  @override
  List<Object?> get props => [centerX, centerY, recommendedScale];
}

class RouteCameraService {
  static MapCameraFitEntity calculateCameraFit({
    required RouteBoundsEntity bounds,
    required double viewportWidth,
    required double viewportHeight,
    double padding = 60.0,
  }) {
    final centerX = (bounds.minX + bounds.maxX) / 2.0;
    final centerY = (bounds.minY + bounds.maxY) / 2.0;

    final routeWidth = max(10.0, bounds.maxX - bounds.minX);
    final routeHeight = max(10.0, bounds.maxY - bounds.minY);

    final availWidth = max(100.0, viewportWidth - (padding * 2));
    final availHeight = max(100.0, viewportHeight - (padding * 2));

    final scaleX = availWidth / routeWidth;
    final scaleY = availHeight / routeHeight;

    final recommendedScale = min(scaleX, scaleY).clamp(0.5, 3.0);

    return MapCameraFitEntity(
      centerX: centerX,
      centerY: centerY,
      recommendedScale: recommendedScale,
    );
  }
}
