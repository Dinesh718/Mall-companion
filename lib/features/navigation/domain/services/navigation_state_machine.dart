import '../entities/navigation_lifecycle_entity.dart';

class NavigationStateMachine {
  NavigationLifecycleState _currentState;

  NavigationStateMachine({
    NavigationLifecycleState initialState = NavigationLifecycleState.idle,
  }) : _currentState = initialState;

  NavigationLifecycleState get currentState => _currentState;

  static final Map<NavigationLifecycleState, Set<NavigationLifecycleState>>
  _validTransitions = {
    NavigationLifecycleState.idle: {
      NavigationLifecycleState.previewing,
      NavigationLifecycleState.navigating,
    },
    NavigationLifecycleState.previewing: {
      NavigationLifecycleState.navigating,
      NavigationLifecycleState.cancelled,
      NavigationLifecycleState.idle,
    },
    NavigationLifecycleState.navigating: {
      NavigationLifecycleState.waitingForFloorTransition,
      NavigationLifecycleState.arrived,
      NavigationLifecycleState.cancelled,
    },
    NavigationLifecycleState.waitingForFloorTransition: {
      NavigationLifecycleState.navigating,
      NavigationLifecycleState.cancelled,
    },
    NavigationLifecycleState.arrived: {
      NavigationLifecycleState.completed,
      NavigationLifecycleState.cancelled,
    },
    NavigationLifecycleState.completed: {NavigationLifecycleState.idle},
    NavigationLifecycleState.cancelled: {NavigationLifecycleState.idle},
  };

  bool isValidTransition(NavigationLifecycleState nextState) {
    if (_currentState == nextState) return true;
    final allowed = _validTransitions[_currentState];
    return allowed != null && allowed.contains(nextState);
  }

  void transitionTo(NavigationLifecycleState nextState) {
    if (!isValidTransition(nextState)) {
      throw StateError(
        'Invalid navigation transition from $_currentState to $nextState',
      );
    }
    _currentState = nextState;
  }

  void startPreview() => transitionTo(NavigationLifecycleState.previewing);
  void startNavigation() => transitionTo(NavigationLifecycleState.navigating);
  void waitForFloorTransition() =>
      transitionTo(NavigationLifecycleState.waitingForFloorTransition);
  void arrive() => transitionTo(NavigationLifecycleState.arrived);
  void complete() => transitionTo(NavigationLifecycleState.completed);
  void cancel() => transitionTo(NavigationLifecycleState.cancelled);
  void reset() => transitionTo(NavigationLifecycleState.idle);
}
