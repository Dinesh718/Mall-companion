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

    // 1. Find nearest node on the active segment (using <= to select the later node on exact ties)
    double minDistance = double.infinity;
    NavigationNodeEntity nearestNode = activeSegment.nodes.first;
    int localNearestIndex = 0;

    for (int i = 0; i < activeSegment.nodes.length; i++) {
      final node = activeSegment.nodes[i];
      final dx = position.x - node.x;
      final dy = position.y - node.y;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist <= minDistance) {
        minDistance = dist;
        nearestNode = node;
        localNearestIndex = i;
      }
    }

    final nearestRouteIndex = route.completeRoute.indexWhere(
      (n) => n.id == nearestNode.id,
    );

    // 2. Next node calculation
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

    // 3. Connector reached check
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

    // 4. Destination reached check
    final finalSegment = segments.last;
    final destNode = finalSegment.nodes.last;
    final destDx = position.x - destNode.x;
    final destDy = position.y - destNode.y;
    final distanceToDestination = sqrt(destDx * destDx + destDy * destDy);
    final hasReachedDestination =
        (currentSegmentIndex == segments.length - 1) &&
        (distanceToDestination <= threshold);

    // 5. Remaining distance calculation
    double remainingDistance = 0.0;
    remainingDistance += minDistance;

    // Remaining path on the active segment
    for (int i = localNearestIndex; i < activeSegment.nodes.length - 1; i++) {
      final n1 = activeSegment.nodes[i];
      final n2 = activeSegment.nodes[i + 1];
      final dx = n1.x - n2.x;
      final dy = n1.y - n2.y;
      remainingDistance += sqrt(dx * dx + dy * dy);
    }

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

    return NavigationProgressResult(
      nearestNodeId: nearestNode.id,
      nearestRouteIndex: nearestRouteIndex,
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
