import '../../domain/entities/position_entities.dart';
import '../../domain/entities/map_entities.dart';

class NavigationSimulationService {
  static List<IndoorPositionEntity> generateSimulationPath(
    NavigationRouteEntity route, {
    int positionsPerEdge = 20,
  }) {
    final List<IndoorPositionEntity> path = [];
    final nodes = route.completeRoute;

    if (nodes.isEmpty) return path;
    if (nodes.length == 1) {
      final n = nodes.first;
      path.add(
        IndoorPositionEntity(
          id: 'sim_pos_${n.floorId}_0',
          floorId: n.floorId,
          x: n.x,
          y: n.y,
          accuracy: 1.0,
          timestamp: DateTime.now(),
          source: PositionSource.simulation,
        ),
      );
      return path;
    }

    int count = 0;
    for (int i = 0; i < nodes.length - 1; i++) {
      final n1 = nodes[i];
      final n2 = nodes[i + 1];

      final dx = n2.x - n1.x;
      final dy = n2.y - n1.y;

      if (dx == 0.0 && dy == 0.0) {
        path.add(
          IndoorPositionEntity(
            id: 'sim_pos_${n1.floorId}_$count',
            floorId: n1.floorId,
            x: n1.x,
            y: n1.y,
            accuracy: 1.0,
            timestamp: DateTime.now(),
            source: PositionSource.simulation,
          ),
        );
        count++;
        continue;
      }

      for (int step = 0; step < positionsPerEdge; step++) {
        final ratio = step / positionsPerEdge;
        final x = n1.x + dx * ratio;
        final y = n1.y + dy * ratio;

        String floorId;
        if (n1.floorId == 'transition' && n2.floorId != 'transition') {
          floorId = ratio < 0.9 ? n1.floorId : n2.floorId;
        } else if (n1.floorId != 'transition' && n2.floorId == 'transition') {
          floorId = n2.floorId;
        } else {
          floorId = ratio < 0.5 ? n1.floorId : n2.floorId;
        }

        path.add(
          IndoorPositionEntity(
            id: 'sim_pos_${n1.floorId}_$count',
            floorId: floorId,
            x: x,
            y: y,
            accuracy: 1.0,
            timestamp: DateTime.now(),
            source: PositionSource.simulation,
          ),
        );
        count++;
      }
    }

    final lastNode = nodes.last;
    path.add(
      IndoorPositionEntity(
        id: 'sim_pos_${lastNode.floorId}_$count',
        floorId: lastNode.floorId,
        x: lastNode.x,
        y: lastNode.y,
        accuracy: 1.0,
        timestamp: DateTime.now(),
        source: PositionSource.simulation,
      ),
    );

    return path;
  }
}
