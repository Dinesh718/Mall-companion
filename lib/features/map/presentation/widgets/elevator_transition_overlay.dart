import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';
import '../../domain/entities/map_entities.dart';

class ElevatorTransitionOverlay extends StatelessWidget {
  const ElevatorTransitionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      buildWhen: (previous, current) {
        if (previous is! MapLoaded || current is! MapLoaded) return true;
        return previous.navigationSession?.navigationStatus !=
            current.navigationSession?.navigationStatus;
      },
      builder: (context, state) {
        if (state is! MapLoaded) return const SizedBox.shrink();
        final session = state.navigationSession;
        if (session == null ||
            session.navigationStatus != NavigationStatus.transitioningFloor) {
          return const SizedBox.shrink();
        }

        final currentSegmentIndex = session.currentSegmentIndex;
        if (currentSegmentIndex <= 0 ||
            currentSegmentIndex >= session.segments.length - 1) {
          return const SizedBox.shrink();
        }

        final floors = state.mapEntity.floors.map((f) => f).toList();
        final sourceFloorId = session.segments[currentSegmentIndex - 1].floorId;
        final targetFloorId = session.segments[currentSegmentIndex + 1].floorId;

        final sourceFloor = floors.firstWhere(
          (f) => f.id == sourceFloorId,
          orElse: () => floors.first,
        );
        final targetFloor = floors.firstWhere(
          (f) => f.id == targetFloorId,
          orElse: () => floors.first,
        );

        final sourceIdx = floors.indexOf(sourceFloor);
        final targetIdx = floors.indexOf(targetFloor);
        final isMovingUp = sourceIdx < targetIdx;

        return _ElevatorTransitionDialog(
          sourceFloorName: sourceFloor.name,
          targetFloorName: targetFloor.name,
          isMovingUp: isMovingUp,
        );
      },
    );
  }
}

class _ElevatorTransitionDialog extends StatefulWidget {
  final String sourceFloorName;
  final String targetFloorName;
  final bool isMovingUp;

  const _ElevatorTransitionDialog({
    required this.sourceFloorName,
    required this.targetFloorName,
    required this.isMovingUp,
  });

  @override
  State<_ElevatorTransitionDialog> createState() =>
      _ElevatorTransitionDialogState();
}

class _ElevatorTransitionDialogState extends State<_ElevatorTransitionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _arrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF7FF),
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6100D6).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.elevator_outlined,
                            size: 40.0,
                            color: Color(0xFF6100D6),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  AnimatedBuilder(
                    animation: _arrowAnimation,
                    builder: (context, child) {
                      final double translation = widget.isMovingUp
                          ? -10.0 * (1.0 - _arrowAnimation.value)
                          : 10.0 * (1.0 - _arrowAnimation.value);
                      final double opacity = 1.0 - _arrowAnimation.value;
                      return Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(0.0, translation),
                          child: Icon(
                            widget.isMovingUp
                                ? Icons.keyboard_double_arrow_up
                                : Icons.keyboard_double_arrow_down,
                            color: const Color(0xFF6100D6),
                            size: 32.0,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    widget.isMovingUp ? 'Moving Up' : 'Moving Down',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${widget.sourceFloorName} → ${widget.targetFloorName}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.0,
                      color: Color(0xFF49454F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const SizedBox(
                    width: 140.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      child: LinearProgressIndicator(
                        minHeight: 4.0,
                        backgroundColor: Color(0xFFE6E0E9),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6100D6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Loading destination floor...',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.0,
                      color: Color(0xFF79747E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
