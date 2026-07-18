import 'package:flutter/material.dart';
import '../../domain/entities/map_entities.dart';

class RouteLayer extends StatelessWidget {
  final List<NavigationNodeEntity>? activeRoute;
  final String currentFloorId;
  final double width;
  final double height;

  const RouteLayer({
    super.key,
    required this.activeRoute,
    required this.currentFloorId,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (activeRoute == null || activeRoute!.isEmpty) {
      return SizedBox(width: width, height: height);
    }

    return CustomPaint(
      size: Size(width, height),
      painter: RoutePainter(
        activeRoute: activeRoute!,
        currentFloorId: currentFloorId,
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  final List<NavigationNodeEntity> activeRoute;
  final String currentFloorId;

  RoutePainter({required this.activeRoute, required this.currentFloorId});

  @override
  void paint(Canvas canvas, Size size) {
    if (activeRoute.isEmpty) return;

    // 1. Draw route line path segments
    final pathPaint = Paint()
      ..color =
          const Color(0xFF6200EE) // Indigo route color
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool isDrawing = false;

    for (int i = 0; i < activeRoute.length - 1; i++) {
      final n1 = activeRoute[i];
      final n2 = activeRoute[i + 1];

      // Draw this line segment only if both nodes belong to the current floor
      if (n1.floorId == currentFloorId && n2.floorId == currentFloorId) {
        if (!isDrawing) {
          path.moveTo(n1.x, n1.y);
          isDrawing = true;
        }
        path.lineTo(n2.x, n2.y);
      } else {
        isDrawing = false;
      }
    }
    canvas.drawPath(path, pathPaint);

    // 2. Draw markers (Start & Destination pins)
    final startOuterPaint = Paint()
      ..color =
          const Color(0xFF4CAF50) // Green
      ..style = PaintingStyle.fill;

    final destOuterPaint = Paint()
      ..color =
          const Color(0xFFE53935) // Red
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw Start Node marker only if it resides on current floor
    final startNode = activeRoute.first;
    if (startNode.floorId == currentFloorId) {
      canvas.drawCircle(Offset(startNode.x, startNode.y), 8.0, startOuterPaint);
      canvas.drawCircle(Offset(startNode.x, startNode.y), 3.0, innerPaint);
    }

    // Draw Destination Node marker only if it resides on current floor (and is different from start node)
    if (activeRoute.length > 1) {
      final destNode = activeRoute.last;
      if (destNode.floorId == currentFloorId) {
        canvas.drawCircle(Offset(destNode.x, destNode.y), 8.0, destOuterPaint);
        canvas.drawCircle(Offset(destNode.x, destNode.y), 3.0, innerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    if (oldDelegate.currentFloorId != currentFloorId) return true;
    if (oldDelegate.activeRoute.length != activeRoute.length) return true;
    for (int i = 0; i < activeRoute.length; i++) {
      if (oldDelegate.activeRoute[i] != activeRoute[i]) return true;
    }
    return false;
  }
}
