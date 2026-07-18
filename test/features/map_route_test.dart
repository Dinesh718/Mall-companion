import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/presentation/widgets/route_layer.dart';

void main() {
  testWidgets('RouteLayer renders and paints path segments correctly', (
    WidgetTester tester,
  ) async {
    const route = [
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
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RouteLayer(
            activeRoute: route,
            currentFloorId: 'ground_floor',
            width: 200.0,
            height: 200.0,
          ),
        ),
      ),
    );

    // Verify that CustomPaint is rendered inside the RouteLayer bounds
    final routeLayerFinder = find.byType(RouteLayer);
    expect(routeLayerFinder, findsOneWidget);
    expect(
      find.descendant(of: routeLayerFinder, matching: find.byType(CustomPaint)),
      findsOneWidget,
    );
  });

  testWidgets('RouteLayer renders empty route case gracefully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RouteLayer(
            activeRoute: null,
            currentFloorId: 'ground_floor',
            width: 200.0,
            height: 200.0,
          ),
        ),
      ),
    );

    // Verify that empty route case does not crash and renders an empty box without CustomPaint
    expect(find.byType(RouteLayer), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(RouteLayer),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });
}
