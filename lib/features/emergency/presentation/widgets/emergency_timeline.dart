import 'package:flutter/material.dart';

class EmergencyTimelineStep {
  final String title;
  final String description;
  final IconData icon;
  final bool isActive;

  const EmergencyTimelineStep({
    required this.title,
    required this.description,
    required this.icon,
    this.isActive = false,
  });
}

class EmergencyTimeline extends StatelessWidget {
  final List<EmergencyTimelineStep> steps;
  final bool isHorizontal;

  const EmergencyTimeline({
    super.key,
    required this.steps,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalTimeline();
    }
    return _buildVerticalTimeline();
  }

  Widget _buildVerticalTimeline() {
    return Stack(
      children: [
        // Dashed line background
        Positioned(
          left: 19.0,
          top: 16.0,
          bottom: 16.0,
          child: Container(
            width: 1.0,
            color: const Color(0xFFCCC3D9).withOpacity(0.5), // dashed line simulation
          ),
        ),
        // Step list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24.0),
          itemBuilder: (context, index) {
            final step = steps[index];
            final circleBg = step.isActive ? const Color(0xFF6100D6) : const Color(0xFFEFF4FF);
            final iconColor = step.isActive ? Colors.white : const Color(0xFF6100D6);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Node
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: circleBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    step.icon,
                    color: iconColor,
                    size: 16.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.0, // title-md
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C30), // on-surface
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        step.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.0, // body-md
                          color: Color(0xFF4A4456), // on-surface-variant
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHorizontalTimeline() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: steps.map((step) {
          final isLast = steps.last == step;
          final circleBorder = step.isActive ? const Color(0xFFBA1A1A) : const Color(0xFFCCC3D9);
          final circleBg = step.isActive ? const Color(0xFFFFDAD6) : const Color(0xFFEFF4FF);
          final iconColor = step.isActive ? const Color(0xFFBA1A1A) : const Color(0xFF7B7488);

          return Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: circleBorder, width: 2.0),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      step.icon,
                      color: iconColor,
                      size: 16.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0B1C30),
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(width: 12.0),
                Container(
                  width: 24.0,
                  height: 1.0,
                  color: const Color(0xFFCCC3D9).withOpacity(0.5),
                ),
                const SizedBox(width: 12.0),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }
}
