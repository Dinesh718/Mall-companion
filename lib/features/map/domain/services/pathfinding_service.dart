import 'dart:math';
import '../entities/map_entities.dart';

class PathfindingService {
  /// Computes the shortest path using the A* algorithm.
  /// Returns an empty list if no path is found.
  static List<NavigationNodeEntity> findPath({
    required NavigationGraphEntity graph,
    required String startNodeId,
    required String endNodeId,
    List<FloorEntity>? floors,
  }) {
    // 1. Locate start and target nodes
    NavigationNodeEntity? startNode;
    NavigationNodeEntity? endNode;
    final Map<String, NavigationNodeEntity> nodeMap = {};

    FloorEntity? startFloor;
    FloorEntity? endFloor;

    if (floors != null) {
      for (final floor in floors) {
        for (final node in floor.navigationGraph.nodes) {
          nodeMap[node.id] = node;
          if (node.id == startNodeId) {
            startNode = node;
            startFloor = floor;
          }
          if (node.id == endNodeId) {
            endNode = node;
            endFloor = floor;
          }
        }
      }
    } else {
      for (final node in graph.nodes) {
        nodeMap[node.id] = node;
        if (node.id == startNodeId) startNode = node;
        if (node.id == endNodeId) endNode = node;
      }
    }

    if (startNode == null || endNode == null) {
      return const [];
    }

    // 2. Handle same-node edge case
    if (startNodeId == endNodeId) {
      return [startNode];
    }

    // 3. Precompute neighbors map
    final Map<String, List<_NeighborLink>> neighbors = {};
    for (final id in nodeMap.keys) {
      neighbors[id] = [];
    }

    final bool isCrossFloor =
        startFloor != null && endFloor != null && startFloor.id != endFloor.id;

    if (isCrossFloor) {
      // Build combined adjacency list using all edges across all floors
      for (final floor in floors!) {
        for (final edge in floor.navigationGraph.edges) {
          final from = edge.fromNodeId;
          final to = edge.toNodeId;
          final dist = edge.distance;

          if (neighbors.containsKey(from) && neighbors.containsKey(to)) {
            neighbors[from]!.add(_NeighborLink(nodeId: to, distance: dist));
            neighbors[to]!.add(_NeighborLink(nodeId: from, distance: dist));
          }
        }

        // Add edges for connectors on this floor
        for (final conn in floor.connectors) {
          if (conn.connectedConnectorId == null) continue;

          // Find the connected connector across all floors
          ConnectorEntity? otherConn;
          for (final otherFloor in floors) {
            for (final c in otherFloor.connectors) {
              if (c.id == conn.connectedConnectorId) {
                otherConn = c;
                break;
              }
            }
            if (otherConn != null) break;
          }

          if (otherConn != null) {
            final fromNodeId = conn.navigationNodeId;
            final toNodeId = otherConn.navigationNodeId;

            if (nodeMap.containsKey(fromNodeId) &&
                nodeMap.containsKey(toNodeId)) {
              final n1 = nodeMap[fromNodeId]!;
              final n2 = nodeMap[toNodeId]!;

              // Calculate transition distance
              final dx = n1.x - n2.x;
              final dy = n1.y - n2.y;
              final dist = sqrt(dx * dx + dy * dy);

              // Avoid duplicating edges since connectors are bidirectionally declared on both floors
              final alreadyConnected = neighbors[fromNodeId]!.any(
                (link) => link.nodeId == toNodeId,
              );
              if (!alreadyConnected) {
                neighbors[fromNodeId]!.add(
                  _NeighborLink(nodeId: toNodeId, distance: dist),
                );
                neighbors[toNodeId]!.add(
                  _NeighborLink(nodeId: fromNodeId, distance: dist),
                );
              }
            }
          }
        }
      }
    } else {
      // Single-floor routing: use provided graph
      for (final edge in graph.edges) {
        final from = edge.fromNodeId;
        final to = edge.toNodeId;
        final dist = edge.distance;

        if (neighbors.containsKey(from) && neighbors.containsKey(to)) {
          neighbors[from]!.add(_NeighborLink(nodeId: to, distance: dist));
          neighbors[to]!.add(_NeighborLink(nodeId: from, distance: dist));
        }
      }
    }

    // 4. A* Search structures
    final Set<String> openSet = {startNodeId};
    final Map<String, String> cameFrom = {};

    final Map<String, double> gScore = {startNodeId: 0.0};
    final Map<String, double> fScore = {
      startNodeId: _euclideanDistance(startNode, endNode),
    };

    double getGScore(String id) => gScore[id] ?? double.infinity;
    double getFScore(String id) => fScore[id] ?? double.infinity;

    while (openSet.isNotEmpty) {
      String currentId = openSet.first;
      double lowestF = getFScore(currentId);

      for (final id in openSet) {
        final f = getFScore(id);
        if (f < lowestF) {
          lowestF = f;
          currentId = id;
        }
      }

      if (currentId == endNodeId) {
        return _reconstructPath(cameFrom, currentId, nodeMap);
      }

      openSet.remove(currentId);

      final links = neighbors[currentId] ?? const [];
      for (final link in links) {
        final neighborId = link.nodeId;
        final tentativeG = getGScore(currentId) + link.distance;

        if (tentativeG < getGScore(neighborId)) {
          cameFrom[neighborId] = currentId;
          gScore[neighborId] = tentativeG;

          final neighborNode = nodeMap[neighborId]!;
          fScore[neighborId] =
              tentativeG + _euclideanDistance(neighborNode, endNode);

          openSet.add(neighborId);
        }
      }
    }

    return const [];
  }

  static double _euclideanDistance(
    NavigationNodeEntity n1,
    NavigationNodeEntity n2,
  ) {
    final dx = n1.x - n2.x;
    final dy = n1.y - n2.y;
    return sqrt(dx * dx + dy * dy);
  }

  static List<NavigationNodeEntity> _reconstructPath(
    Map<String, String> cameFrom,
    String currentId,
    Map<String, NavigationNodeEntity> nodeMap,
  ) {
    final List<NavigationNodeEntity> path = [nodeMap[currentId]!];
    String? next = currentId;

    while (cameFrom.containsKey(next)) {
      next = cameFrom[next];
      if (next != null) {
        path.add(nodeMap[next]!);
      }
    }

    return path.reversed.toList();
  }
}

class _NeighborLink {
  final String nodeId;
  final double distance;

  const _NeighborLink({required this.nodeId, required this.distance});
}
