import 'package:flutter/material.dart';
import '../../domain/entities/map_entities.dart';

class ShopHighlightPainter extends CustomPainter {
  final GeometryEntity geometry;
  final Color color;

  ShopHighlightPainter({required this.geometry, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
          .withOpacity(0.2) // Translucent highlight fill
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    if (geometry is RectangleGeometry) {
      final rectGeom = geometry as RectangleGeometry;
      final rect = Rect.fromLTWH(
        rectGeom.x,
        rectGeom.y,
        rectGeom.width,
        rectGeom.height,
      );
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, borderPaint);
    } else if (geometry is PolygonGeometry) {
      final polyGeom = geometry as PolygonGeometry;
      if (polyGeom.points.isNotEmpty) {
        final path = Path();
        path.moveTo(polyGeom.points.first.x, polyGeom.points.first.y);
        for (int i = 1; i < polyGeom.points.length; i++) {
          path.lineTo(polyGeom.points[i].x, polyGeom.points[i].y);
        }
        path.close();
        canvas.drawPath(path, paint);
        canvas.drawPath(path, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ShopHighlightPainter oldDelegate) {
    return oldDelegate.geometry != geometry || oldDelegate.color != color;
  }
}

class ShopHighlightLayer extends StatelessWidget {
  final ShopEntity? selectedShop;
  final double width;
  final double height;
  final Color highlightColor;

  const ShopHighlightLayer({
    super.key,
    required this.selectedShop,
    required this.width,
    required this.height,
    this.highlightColor = const Color(0xFF6100D6), // App primary color
  });

  @override
  Widget build(BuildContext context) {
    if (selectedShop == null) return const SizedBox.shrink();

    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: ShopHighlightPainter(
            geometry: selectedShop!.geometry,
            color: highlightColor,
          ),
        ),
      ),
    );
  }
}
