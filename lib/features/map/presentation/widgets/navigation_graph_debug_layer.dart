import 'package:flutter/material.dart';
import '../../domain/entities/map_entities.dart';

class NavigationGraphDebugLayer extends StatelessWidget {
  final NavigationGraphEntity navigationGraph;
  final double width;
  final double height;

  const NavigationGraphDebugLayer({
    super.key,
    required this.navigationGraph,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: NavigationGraphPainter(navigationGraph: navigationGraph),
    );
  }
}

class NavigationGraphPainter extends CustomPainter {
  final NavigationGraphEntity navigationGraph;

  NavigationGraphPainter({required this.navigationGraph});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint configuration for edges
    final edgePaint = Paint()
      ..color =
          const Color(0x809E9E9E) // Translucent grey
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 2. Paint configuration for nodes
    final hallwayNodePaint = Paint()
      ..color =
          const Color(0xFF2196F3) // Blue for hallway junctions
      ..style = PaintingStyle.fill;

    final shopNodePaint = Paint()
      ..color =
          const Color(0xFF4CAF50) // Green for shop nodes
      ..style = PaintingStyle.fill;

    // 3. Draw edges connecting the nodes
    for (final edge in navigationGraph.edges) {
      NavigationNodeEntity? fromNode;
      NavigationNodeEntity? toNode;

      for (final n in navigationGraph.nodes) {
        if (n.id == edge.fromNodeId) fromNode = n;
        if (n.id == edge.toNodeId) toNode = n;
        if (fromNode != null && toNode != null) break;
      }

      if (fromNode != null && toNode != null) {
        canvas.drawLine(
          Offset(fromNode.x, fromNode.y),
          Offset(toNode.x, toNode.y),
          edgePaint,
        );
      }
    }

    // 4. Draw node circles
    for (final node in navigationGraph.nodes) {
      final paint = node.type == 'shop' ? shopNodePaint : hallwayNodePaint;
      canvas.drawCircle(
        Offset(node.x, node.y),
        4.0, // Node radius
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NavigationGraphPainter oldDelegate) {
    return oldDelegate.navigationGraph != navigationGraph;
  }
}
