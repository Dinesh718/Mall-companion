import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/presentation/widgets/navigation_graph_debug_layer.dart';

void main() {
  testWidgets('NavigationGraphDebugLayer renders and paints correctly', (
    WidgetTester tester,
  ) async {
    const graph = NavigationGraphEntity(
      nodes: [
        NavigationNodeEntity(
          id: 'N001',
          x: 10.0,
          y: 20.0,
          floorId: 'ground_floor',
          type: 'shop',
        ),
        NavigationNodeEntity(
          id: 'H001',
          x: 50.0,
          y: 50.0,
          floorId: 'ground_floor',
          type: 'hallway',
        ),
      ],
      edges: [
        NavigationEdgeEntity(
          fromNodeId: 'N001',
          toNodeId: 'H001',
          distance: 50.0,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NavigationGraphDebugLayer(
            navigationGraph: graph,
            width: 200.0,
            height: 200.0,
          ),
        ),
      ),
    );

    // Verify that custom paint widget is created and rendered successfully inside the debug layer
    final debugLayerFinder = find.byType(NavigationGraphDebugLayer);
    expect(debugLayerFinder, findsOneWidget);
    expect(
      find.descendant(of: debugLayerFinder, matching: find.byType(CustomPaint)),
      findsOneWidget,
    );
  });
}
