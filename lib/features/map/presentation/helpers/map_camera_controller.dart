import 'package:flutter/material.dart';
import '../../domain/entities/map_entities.dart';

class MapCameraController {
  final TransformationController transformationController;
  final TickerProvider vsync;
  AnimationController? _animationController;

  MapCameraController({
    required this.transformationController,
    required this.vsync,
  });

  /// Smoothly animates the camera to center on the given geometry shape.
  void animateToGeometry(
    GeometryEntity geometry,
    Size viewportSize, {
    double targetScale = 1.5,
  }) {
    Point2D center;
    if (geometry is RectangleGeometry) {
      center = Point2D(
        geometry.x + geometry.width / 2,
        geometry.y + geometry.height / 2,
      );
    } else if (geometry is PolygonGeometry) {
      if (geometry.points.isEmpty) return;
      double sumX = 0;
      double sumY = 0;
      for (final p in geometry.points) {
        sumX += p.x;
        sumY += p.y;
      }
      center = Point2D(
        sumX / geometry.points.length,
        sumY / geometry.points.length,
      );
    } else {
      return; // Unknown geometry type
    }

    animateTo(center, viewportSize, targetScale: targetScale);
  }

  /// Smoothly animates the camera to center on the target point in canvas coordinates.
  void animateTo(
    Point2D target,
    Size viewportSize, {
    double targetScale = 1.5,
  }) {
    _animationController?.stop();
    _animationController?.dispose();

    final startMatrix = transformationController.value;
    final startScale = startMatrix.getMaxScaleOnAxis();
    final startTranslation = startMatrix.getTranslation();

    final endScale = targetScale;
    final endTx = (viewportSize.width / 2) - (target.x * endScale);
    final endTy = (viewportSize.height / 2) - (target.y * endScale);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    final animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.fastOutSlowIn,
    );

    _animationController!.addListener(() {
      final t = animation.value;

      // Linearly interpolate scale and translation
      final currentScale = startScale + (endScale - startScale) * t;
      final currentTx = startTranslation.x + (endTx - startTranslation.x) * t;
      final currentTy = startTranslation.y + (endTy - startTranslation.y) * t;

      transformationController.value = Matrix4.identity()
        ..translate(currentTx, currentTy)
        ..scale(currentScale);
    });

    _animationController!.forward();
  }

  void dispose() {
    _animationController?.stop();
    _animationController?.dispose();
  }
}
