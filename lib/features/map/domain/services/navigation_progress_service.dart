import 'dart:math';
import '../entities/position_entities.dart';
import '../entities/map_entities.dart';
import '../entities/navigation_progress_result.dart';

class NavigationProgressService {
  static NavigationProgressResult evaluateProgress({
    required IndoorPositionEntity position,
    required NavigationSessionEntity session,
    double threshold = 15.0,
  }) {
    final route = session.route;
    final segments = session.segments;
    final currentSegmentIndex = session.currentSegmentIndex;

    if (segments.isEmpty || currentSegmentIndex >= segments.length) {
      return const NavigationProgressResult(
        nearestNodeId: '',
        nearestRouteIndex: -1,
        remainingDistance: 0.0,
        hasReachedNextNode: false,
        hasReachedConnector: false,
        hasReachedDestination: false,
        shouldAdvanceSegment: false,
        shouldBeginFloorTransition: false,
        distanceToNextNode: 0.0,
        distanceToDestination: 0.0,
      );
    }

    final activeSegment = segments[currentSegmentIndex];

    // If floor ID does not match, return basic state to prevent incorrect evaluations
    if (position.floorId != activeSegment.floorId) {
      return NavigationProgressResult(
        nearestNodeId: activeSegment.nodes.first.id,
        nearestRouteIndex: route.completeRoute.indexWhere(
          (n) => n.id == activeSegment.nodes.first.id,
        ),
        currentRouteNodeIndex: session.currentRouteNodeIndex,
        remainingDistance: session.remainingDistance,
        hasReachedNextNode: false,
        hasReachedConnector: false,
        hasReachedDestination: false,
        shouldAdvanceSegment: false,
        shouldBeginFloorTransition: false,
        distanceToNextNode: 0.0,
        distanceToDestination: 0.0,
      );
    }

    // 1. Determine local starting node index on active segment corresponding to currentRouteNodeIndex
    int startLocalIndex = 0;
    if (session.currentRouteNodeIndex > 0) {
      final currentNodeId = route.completeRoute[
        min(session.currentRouteNodeIndex, route.completeRoute.length - 1)
      ].id;
      final foundIndex = activeSegment.nodes.indexWhere((n) => n.id == currentNodeId);
      if (foundIndex != -1) {
        startLocalIndex = foundIndex;
      }
    }

    // 2. Physical Blue Dot node progress: advance localNearestIndex ONLY when Blue Dot physically reaches next node
    int localNearestIndex = startLocalIndex;
    if (startLocalIndex < activeSegment.nodes.length - 1) {
      final nextNode = activeSegment.nodes[startLocalIndex + 1];
      final dxNext = position.x - nextNode.x;
      final dyNext = position.y - nextNode.y;
      final distToNext = sqrt(dxNext * dxNext + dyNext * dyNext);

      final currentNode = activeSegment.nodes[startLocalIndex];
      final abx = nextNode.x - currentNode.x;
      final aby = nextNode.y - currentNode.y;
      final lenSq = abx * abx + aby * aby;
      double t = 0.0;
      if (lenSq > 0.0) {
        final apx = position.x - currentNode.x;
        final apy = position.y - currentNode.y;
        t = ((apx * abx + apy * aby) / lenSq).clamp(0.0, 1.0);
      }

      // Advance node progress only if Blue Dot is within threshold to next node or has completed edge traversal (t >= 0.95)
      if (distToNext <= threshold || t >= 0.95) {
        localNearestIndex = startLocalIndex + 1;
      }
    }

    NavigationNodeEntity nearestNode = activeSegment.nodes[localNearestIndex];
    final nearestRouteIndex = route.completeRoute.indexWhere(
      (n) => n.id == nearestNode.id,
    );

    final updatedRouteNodeIndex = max(
      session.currentRouteNodeIndex,
      nearestRouteIndex != -1 ? nearestRouteIndex : session.currentRouteNodeIndex,
    );

    // 3. Next node calculation
    final dxNearest = position.x - nearestNode.x;
    final dyNearest = position.y - nearestNode.y;
    final distanceToNearest = sqrt(
      dxNearest * dxNearest + dyNearest * dyNearest,
    );
    final hasReachedNearest = distanceToNearest <= threshold;

    NavigationNodeEntity? nextNode;
    double distanceToNextNode = 0.0;
    bool hasReachedNextNode = false;

    if (hasReachedNearest) {
      hasReachedNextNode = true;
      distanceToNextNode = 0.0;
      if (localNearestIndex < activeSegment.nodes.length - 1) {
        nextNode = activeSegment.nodes[localNearestIndex + 1];
        final dx = position.x - nextNode.x;
        final dy = position.y - nextNode.y;
        distanceToNextNode = sqrt(dx * dx + dy * dy);
      } else if (currentSegmentIndex < segments.length - 1) {
        nextNode = segments[currentSegmentIndex + 1].nodes.first;
        final dx = position.x - nextNode.x;
        final dy = position.y - nextNode.y;
        distanceToNextNode = sqrt(dx * dx + dy * dy);
      }
    } else {
      nextNode = nearestNode;
      distanceToNextNode = distanceToNearest;
      hasReachedNextNode = false;
    }

    // 4. Connector reached check
    bool hasReachedConnector = false;
    bool shouldBeginFloorTransition = false;
    bool shouldAdvanceSegment = false;

    if (session.nextConnectorId != null) {
      final connectorNode = activeSegment.nodes.last;
      final dx = position.x - connectorNode.x;
      final dy = position.y - connectorNode.y;
      final distanceToConnector = sqrt(dx * dx + dy * dy);
      if (distanceToConnector <= threshold) {
        hasReachedConnector = true;
        shouldAdvanceSegment = true;
        shouldBeginFloorTransition = true;
      }
    }

    // 5. Remaining distance calculation
    final activeSegDist = calculatePathRemainingDistance(
      path: activeSegment.nodes,
      px: position.x,
      py: position.y,
      startIndex: startLocalIndex,
      endIndex: activeSegment.nodes.length - 1,
    );
    double remainingDistance = activeSegDist;

    // Subsequent segments
    for (int s = currentSegmentIndex + 1; s < segments.length; s++) {
      final seg = segments[s];
      for (int i = 0; i < seg.nodes.length - 1; i++) {
        final n1 = seg.nodes[i];
        final n2 = seg.nodes[i + 1];
        final dx = n1.x - n2.x;
        final dy = n1.y - n2.y;
        remainingDistance += sqrt(dx * dx + dy * dy);
      }
    }

    // 6. Destination reached check (Strict physical Blue Dot arrival)
    final finalSegment = segments.last;
    final destNode = finalSegment.nodes.last;
    final destDx = position.x - destNode.x;
    final destDy = position.y - destNode.y;
    final distanceToDestination = sqrt(destDx * destDx + destDy * destDy);

    final isFinalSegment = currentSegmentIndex == segments.length - 1;

    bool hasReachedDestination = false;
    if (isFinalSegment && position.floorId == finalSegment.floorId) {
      // Arrived ONLY when Blue Dot is physically within threshold of destination entrance
      if (distanceToDestination <= threshold) {
        hasReachedDestination = true;
        remainingDistance = 0.0;
      }
    }

    return NavigationProgressResult(
      nearestNodeId: nearestNode.id,
      nearestRouteIndex: nearestRouteIndex,
      currentRouteNodeIndex: updatedRouteNodeIndex,
      remainingDistance: remainingDistance,
      hasReachedNextNode: hasReachedNextNode,
      hasReachedConnector: hasReachedConnector,
      hasReachedDestination: hasReachedDestination,
      shouldAdvanceSegment: shouldAdvanceSegment,
      shouldBeginFloorTransition: shouldBeginFloorTransition,
      distanceToNextNode: distanceToNextNode,
      distanceToDestination: distanceToDestination,
    );
  }

  static double calculatePathRemainingDistance({
    required List<NavigationNodeEntity> path,
    required double px,
    required double py,
    required int startIndex,
    required int endIndex,
  }) {
    if (path.isEmpty || startIndex < 0 || endIndex < startIndex) return 0.0;
    if (startIndex == endIndex) {
      final node = path[startIndex];
      final dx = px - node.x;
      final dy = py - node.y;
      return sqrt(dx * dx + dy * dy);
    }

    double minEdgeDist = double.infinity;
    int closestEdgeIndex = startIndex;
    double closestT = 0.0;

    for (int i = startIndex; i < endIndex; i++) {
      final a = path[i];
      final b = path[i + 1];
      final abx = b.x - a.x;
      final aby = b.y - a.y;
      final lenSq = abx * abx + aby * aby;

      double t = 0.0;
      if (lenSq > 0.0) {
        final apx = px - a.x;
        final apy = py - a.y;
        t = (apx * abx + apy * aby) / lenSq;
        t = t.clamp(0.0, 1.0);
      }

      final projX = a.x + t * abx;
      final projY = a.y + t * aby;
      final dx = px - projX;
      final dy = py - projY;
      final dist = sqrt(dx * dx + dy * dy);

      if (dist < minEdgeDist) {
        minEdgeDist = dist;
        closestEdgeIndex = i;
        closestT = t;
      }
    }

    final edgeA = path[closestEdgeIndex];
    final edgeB = path[closestEdgeIndex + 1];
    final eDx = edgeB.x - edgeA.x;
    final eDy = edgeB.y - edgeA.y;
    final edgeLen = sqrt(eDx * eDx + eDy * eDy);
    double dist = (1.0 - closestT) * edgeLen;

    for (int i = closestEdgeIndex + 1; i < endIndex; i++) {
      final n1 = path[i];
      final n2 = path[i + 1];
      final dx = n2.x - n1.x;
      final dy = n2.y - n1.y;
      dist += sqrt(dx * dx + dy * dy);
    }

    return dist;
  }

  static double _distanceToSegment({
    required double px,
    required double py,
    required double ax,
    required double ay,
    required double bx,
    required double by,
  }) {
    final dx = bx - ax;
    final dy = by - ay;
    final lenSq = dx * dx + dy * dy;
    if (lenSq == 0) {
      final dx2 = px - ax;
      final dy2 = py - ay;
      return sqrt(dx2 * dx2 + dy2 * dy2);
    }
    final t = max(0.0, min(1.0, ((px - ax) * dx + (py - ay) * dy) / lenSq));
    final cx = ax + t * dx;
    final cy = ay + t * dy;
    final dx3 = px - cx;
    final dy3 = py - cy;
    return sqrt(dx3 * dx3 + dy3 * dy3);
  }

  static bool checkOffRoute({
    required IndoorPositionEntity position,
    required NavigationSessionEntity session,
    double threshold = 30.0,
  }) {
    final segments = session.segments;
    if (segments.isEmpty) return false;

    // If user's sensor floor is different from active segment floor, they are off-route
    if (session.currentSegmentIndex < segments.length) {
      final currentSegment = segments[session.currentSegmentIndex];
      if (position.floorId != currentSegment.floorId) {
        return true;
      }
    }

    double minDistanceToRoute = double.infinity;
    bool hasSegmentOnSameFloor = false;

    for (final segment in segments) {
      if (segment.floorId != position.floorId) continue;
      if (segment.nodes.isEmpty) continue;

      hasSegmentOnSameFloor = true;

      if (segment.nodes.length == 1) {
        final node = segment.nodes.first;
        final dx = position.x - node.x;
        final dy = position.y - node.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < minDistanceToRoute) {
          minDistanceToRoute = dist;
        }
        continue;
      }

      for (int i = 0; i < segment.nodes.length - 1; i++) {
        final n1 = segment.nodes[i];
        final n2 = segment.nodes[i + 1];
        final dist = _distanceToSegment(
          px: position.x,
          py: position.y,
          ax: n1.x,
          ay: n1.y,
          bx: n2.x,
          by: n2.y,
        );
        if (dist < minDistanceToRoute) {
          minDistanceToRoute = dist;
        }
      }
    }

    if (!hasSegmentOnSameFloor) {
      return true;
    }

    return minDistanceToRoute > threshold;
  }
}
