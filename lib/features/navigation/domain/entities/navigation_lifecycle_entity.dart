import 'package:equatable/equatable.dart';

enum NavigationLifecycleState {
  idle,
  previewing,
  navigating,
  waitingForFloorTransition,
  arrived,
  completed,
  cancelled,
}

class NavigationLifecycleEntity extends Equatable {
  final NavigationLifecycleState state;

  const NavigationLifecycleEntity({required this.state});

  @override
  List<Object?> get props => [state];
}
