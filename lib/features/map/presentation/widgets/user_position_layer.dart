import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/position_entities.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_state.dart';

class UserPositionPainter extends CustomPainter {
  final double x;
  final double y;
  final Color color;

  UserPositionPainter({required this.x, required this.y, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Glowing outer translucent ring
    final glowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 12.0, glowPaint);

    // 2. High-contrast white border ring
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 7.0, borderPaint);

    // 3. Core solid position dot
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 5.0, corePaint);
  }

  @override
  bool shouldRepaint(covariant UserPositionPainter oldDelegate) {
    return oldDelegate.x != x ||
        oldDelegate.y != y ||
        oldDelegate.color != color;
  }
}

class UserPositionLayer extends StatelessWidget {
  final double width;
  final double height;

  const UserPositionLayer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MapBloc, MapState, IndoorPositionEntity?>(
      selector: (state) {
        if (state is MapLoaded) {
          if (state.latestPosition != null &&
              state.latestPosition!.floorId == state.currentFloor.id) {
            return state.latestPosition;
          }
        }
        return null;
      },
      builder: (context, position) {
        if (position == null) return const SizedBox.shrink();

        return RepaintBoundary(
          child: SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: UserPositionPainter(
                x: position.x,
                y: position.y,
                color: const Color(0xFF2196F3),
              ),
            ),
          ),
        );
      },
    );
  }
}
