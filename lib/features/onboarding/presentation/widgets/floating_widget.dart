import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final double
  delayFraction; // Value between 0.0 and 1.0 to offset animation starts

  const FloatingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 4),
    this.offset = 10.0,
    this.delayFraction = 0.0,
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.offset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.delayFraction > 0.0) {
      Future.delayed(
        Duration(
          milliseconds: (widget.duration.inMilliseconds * widget.delayFraction)
              .toInt(),
        ),
        () {
          if (mounted) {
            _controller.repeat(reverse: true);
          }
        },
      );
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
