import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/services/pathfinding_service.dart';

void main() {
  group('A* Pathfinding Service Tests', () {
    const graph = NavigationGraphEntity(
      nodes: [
        NavigationNodeEntity(
          id: 'N001',
          x: 0.0,
          y: 0.0,
          floorId: 'ground_floor',
          type: 'shop',
        ),
        NavigationNodeEntity(
          id: 'H001',
          x: 10.0,
          y: 0.0,
          floorId: 'ground_floor',
          type: 'hallway',
        ),
        NavigationNodeEntity(
          id: 'H002',
          x: 20.0,
          y: 0.0,
          floorId: 'ground_floor',
          type: 'hallway',
        ),
        NavigationNodeEntity(
          id: 'N002',
          x: 20.0,
          y: 10.0,
          floorId: 'ground_floor',
          type: 'shop',
        ),
        NavigationNodeEntity(
          id: 'X001',
          x: 100.0,
          y: 100.0,
          floorId: 'ground_floor',
          type: 'shop',
        ),
      ],
      edges: [
        NavigationEdgeEntity(
          fromNodeId: 'N001',
          toNodeId: 'H001',
          distance: 10.0,
        ),
        NavigationEdgeEntity(
          fromNodeId: 'H001',
          toNodeId: 'H002',
          distance: 10.0,
        ),
        NavigationEdgeEntity(
          fromNodeId: 'H002',
          toNodeId: 'N002',
          distance: 10.0,
        ),
      ],
    );

    test('Same node request returns a single node path', () {
      final path = PathfindingService.findPath(
        graph: graph,
        startNodeId: 'N001',
        endNodeId: 'N001',
      );

      expect(path.length, 1);
      expect(path.first.id, 'N001');
    });

    test('Shortest path calculation is correct across multiple edges', () {
      final path = PathfindingService.findPath(
        graph: graph,
        startNodeId: 'N001',
        endNodeId: 'N002',
      );

      expect(path.length, 4);
      expect(path[0].id, 'N001');
      expect(path[1].id, 'H001');
      expect(path[2].id, 'H002');
      expect(path[3].id, 'N002');
    });

    test('Disconnected node request returns empty path list', () {
      final path = PathfindingService.findPath(
        graph: graph,
        startNodeId: 'N001',
        endNodeId: 'X001',
      );

      expect(path, isEmpty);
    });

    test('Invalid node ID request returns empty path list', () {
      final path = PathfindingService.findPath(
        graph: graph,
        startNodeId: 'N001',
        endNodeId: 'INVALID_ID',
      );

      expect(path, isEmpty);
    });
  });
}
