import 'package:equatable/equatable.dart';

class NavigationProgressResult extends Equatable {
  final String nearestNodeId;
  final int nearestRouteIndex;
  final int currentRouteNodeIndex;
  final double remainingDistance;
  final bool hasReachedNextNode;
  final bool hasReachedConnector;
  final bool hasReachedDestination;
  final bool shouldAdvanceSegment;
  final bool shouldBeginFloorTransition;
  final double distanceToNextNode;
  final double distanceToDestination;

  const NavigationProgressResult({
    required this.nearestNodeId,
    required this.nearestRouteIndex,
    this.currentRouteNodeIndex = 0,
    required this.remainingDistance,
    required this.hasReachedNextNode,
    required this.hasReachedConnector,
    required this.hasReachedDestination,
    required this.shouldAdvanceSegment,
    required this.shouldBeginFloorTransition,
    required this.distanceToNextNode,
    required this.distanceToDestination,
  });

  @override
  List<Object?> get props => [
    nearestNodeId,
    nearestRouteIndex,
    currentRouteNodeIndex,
    remainingDistance,
    hasReachedNextNode,
    hasReachedConnector,
    hasReachedDestination,
    shouldAdvanceSegment,
    shouldBeginFloorTransition,
    distanceToNextNode,
    distanceToDestination,
  ];
}
