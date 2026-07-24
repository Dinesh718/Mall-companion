import 'dart:math';
import 'package:visitor_mall/features/map/domain/entities/map_entities.dart';
import 'package:visitor_mall/features/map/domain/entities/position_entities.dart';
import 'package:visitor_mall/features/map/domain/services/pathfinding_service.dart';

class DestinationSwitchService {
  static NavigationRouteEntity? switchDestination({
    required MapEntity mapEntity,
    required IndoorPositionEntity currentPosition,
    required String newDestinationShopId,
  }) {
    // 1. Resolve start node ID
    final startNodeId = resolveStartNodeId(
      mapEntity: mapEntity,
      latestPos: currentPosition,
    );
    if (startNodeId.isEmpty) return null;

    // 2. Resolve end node ID from shop ID
    String? endNodeId;
    for (final floor in mapEntity.floors) {
      for (final shop in floor.shops) {
        if (shop.id == newDestinationShopId) {
          if (shop.entranceNodeIds.isNotEmpty) {
            endNodeId = shop.entranceNodeIds.first;
          }
          break;
        }
      }
      if (endNodeId != null) break;
    }
    if (endNodeId == null) return null;

    // 3. Find user's floor navigation graph
    FloorEntity? userFloor;
    for (final floor in mapEntity.floors) {
      if (floor.id == currentPosition.floorId) {
        userFloor = floor;
        break;
      }
    }
    final pathfindGraph = (userFloor ?? mapEntity.floors.first).navigationGraph;

    // 4. Find path
    final nodes = PathfindingService.findPath(
      graph: pathfindGraph,
      startNodeId: startNodeId,
      endNodeId: endNodeId,
      floors: mapEntity.floors,
    );

    if (nodes.isEmpty) return null;

    // 5. Generate route segments (same logic as in MapBloc)
    final List<RouteSegmentEntity> segments = [];
    final List<int> floorChangeIndices = [];
    for (int i = 0; i < nodes.length - 1; i++) {
      if (nodes[i].floorId != nodes[i + 1].floorId) {
        floorChangeIndices.add(i);
      }
    }

    if (floorChangeIndices.isEmpty) {
      segments.add(
        RouteSegmentEntity(floorId: nodes.first.floorId, nodes: nodes),
      );
    } else {
      int startIdx = 0;
      for (final changeIdx in floorChangeIndices) {
        segments.add(
          RouteSegmentEntity(
            floorId: nodes[startIdx].floorId,
            nodes: nodes.sublist(startIdx, changeIdx + 1),
          ),
        );
        segments.add(
          RouteSegmentEntity(
            floorId: 'transition',
            nodes: [nodes[changeIdx], nodes[changeIdx + 1]],
          ),
        );
        startIdx = changeIdx + 1;
      }
      if (startIdx < nodes.length) {
        segments.add(
          RouteSegmentEntity(
            floorId: nodes[startIdx].floorId,
            nodes: nodes.sublist(startIdx),
          ),
        );
      }
    }

    // 6. Compute total distance (same logic as in MapBloc)
    double totalDistance = 0.0;
    for (int i = 0; i < nodes.length - 1; i++) {
      final n1 = nodes[i];
      final n2 = nodes[i + 1];
      double dist = 0.0;

      if (n1.floorId == n2.floorId) {
        final floor = mapEntity.floors.firstWhere(
          (f) => f.id == n1.floorId,
        );
        for (final edge in floor.navigationGraph.edges) {
          if ((edge.fromNodeId == n1.id && edge.toNodeId == n2.id) ||
              (edge.fromNodeId == n2.id && edge.toNodeId == n1.id)) {
            dist = edge.distance;
            break;
          }
        }
      }

      if (dist == 0.0) {
        final dx = n1.x - n2.x;
        final dy = n1.y - n2.y;
        dist = sqrt(dx * dx + dy * dy);
      }
      totalDistance += dist;
    }

    return NavigationRouteEntity(
      completeRoute: nodes,
      segments: segments,
      totalDistance: totalDistance,
    );
  }

  static String resolveStartNodeId({
    required MapEntity mapEntity,
    required IndoorPositionEntity latestPos,
  }) {
    FloorEntity? userFloor;
    for (final floor in mapEntity.floors) {
      if (floor.id == latestPos.floorId) {
        userFloor = floor;
        break;
      }
    }

    userFloor ??= mapEntity.floors.first;

    ShopEntity? containingShop;
    for (final shop in userFloor.shops) {
      if (shop.category == 'Corridor' || shop.category == 'Escalator') {
        continue;
      }
      if (shop.geometry.contains(Point2D(latestPos.x, latestPos.y))) {
        containingShop = shop;
        break;
      }
    }

    if (containingShop != null && containingShop.entranceNodeIds.isNotEmpty) {
      return containingShop.entranceNodeIds.first;
    } else {
      double minDistanceSq = double.infinity;
      NavigationNodeEntity? nearestNode;
      for (final node in userFloor.navigationGraph.nodes) {
        final dx = latestPos.x - node.x;
        final dy = latestPos.y - node.y;
        final distSq = dx * dx + dy * dy;
        if (distSq < minDistanceSq) {
          minDistanceSq = distSq;
          nearestNode = node;
        }
      }
      if (nearestNode != null) {
        return nearestNode.id;
      }
    }
    return '';
  }
}
