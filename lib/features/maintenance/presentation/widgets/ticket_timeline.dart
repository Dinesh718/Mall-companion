import 'package:flutter/material.dart';

class TicketTimeline extends StatelessWidget {
  final String status;
  final String assignedTech;

  const TicketTimeline({
    super.key,
    required this.status,
    required this.assignedTech,
  });

  @override
  Widget build(BuildContext context) {
    // Determine active steps based on status
    int activeStepIndex = 0;
    if (status == 'Submitted') {
      activeStepIndex = 1;
    } else if (status == 'Assigned') {
      activeStepIndex = 2; // Step 3 (index 2) is active
    } else if (status == 'Repairing' || status == 'In Progress') {
      activeStepIndex = 4; // Step 5 is active
    } else if (status == 'Resolved') {
      activeStepIndex = 6;
    }

    final steps = [
      _TimelineStep(
        title: 'Report Submitted',
        timeText: 'Today, 2:15 PM',
        state: activeStepIndex >= 0 ? StepState.completed : StepState.pending,
      ),
      _TimelineStep(
        title: 'Ticket Created',
        timeText: 'Today, 2:18 PM',
        state: activeStepIndex >= 1 ? StepState.completed : StepState.pending,
      ),
      _TimelineStep(
        title: 'Technician Assigned',
        subtitle: 'Assigned to: $assignedTech',
        state: activeStepIndex == 2
            ? StepState.active
            : (activeStepIndex > 2 ? StepState.completed : StepState.pending),
      ),
      _TimelineStep(
        title: 'Technician On the Way',
        subtitle: 'Estimated arrival: 15 mins',
        state: activeStepIndex == 3
            ? StepState.active
            : (activeStepIndex > 3 ? StepState.completed : StepState.pending),
      ),
      _TimelineStep(
        title: 'Issue Under Repair',
        state: activeStepIndex == 4
            ? StepState.active
            : (activeStepIndex > 4 ? StepState.completed : StepState.pending),
      ),
      _TimelineStep(
        title: 'Quality Verification',
        state: activeStepIndex == 5
            ? StepState.active
            : (activeStepIndex > 5 ? StepState.completed : StepState.pending),
      ),
      _TimelineStep(
        title: 'Resolved',
        isLast: true,
        state: activeStepIndex == 6
            ? StepState.active
            : (activeStepIndex > 6 ? StepState.completed : StepState.pending),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Roadmap',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18.0, // title-lg
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 24.0),
          Stack(
            children: [
              // Custom dashed vertical line background
              Positioned(
                left: 15.0,
                top: 8.0,
                bottom: 8.0,
                child: CustomPaint(
                  size: const Size(2.0, double.infinity),
                  painter: _DashedLinePainter(),
                ),
              ),
              // Main timeline columns
              Column(children: steps),
            ],
          ),
        ],
      ),
    );
  }
}

enum StepState { pending, active, completed }

class _TimelineStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? timeText;
  final StepState state;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    this.subtitle,
    this.timeText,
    required this.state,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget indicator;
    if (state == StepState.completed) {
      indicator = Container(
        width: 32.0,
        height: 32.0,
        decoration: const BoxDecoration(
          color: Color(0xFF6100D6), // primary
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.check, color: Colors.white, size: 16.0),
      );
    } else if (state == StepState.active) {
      indicator = Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF6100D6), width: 2.0),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 10.0,
          height: 10.0,
          decoration: const BoxDecoration(
            color: Color(0xFF6100D6),
            shape: BoxShape.circle,
          ),
        ),
      );
    } else {
      indicator = Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFCCC3D9), width: 2.0),
        ),
        alignment: Alignment.center,
        child: isLast
            ? const Icon(
                Icons.flag_outlined,
                color: Color(0xFFCCC3D9),
                size: 16.0,
              )
            : const SizedBox.shrink(),
      );
    }

    final double bottomGap = isLast ? 0.0 : 28.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          indicator,
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.0,
                    fontWeight: state == StepState.active
                        ? FontWeight.bold
                        : FontWeight.w600,
                    color: state == StepState.active
                        ? const Color(0xFF6100D6)
                        : const Color(0xFF0B1C30),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
                if (timeText != null) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    timeText!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.0,
                      color: Color(0xFF4A4456),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCCC3D9)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    double maxExtent = size.height;
    double dashHeight = 5.0;
    double dashGap = 5.0;
    double startY = 8.0;

    while (startY < maxExtent) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
