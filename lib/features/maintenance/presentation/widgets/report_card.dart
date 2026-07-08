import 'package:flutter/material.dart';
import '../../domain/entities/maintenance_entities.dart';

class ReportCard extends StatelessWidget {
  final MaintenanceReportEntity report;
  final VoidCallback onViewDetails;
  final VoidCallback onTrackStatus;

  const ReportCard({
    super.key,
    required this.report,
    required this.onViewDetails,
    required this.onTrackStatus,
  });

  @override
  Widget build(BuildContext context) {
    // Icon mapping
    IconData categoryIcon = Icons.help_outline;
    if (report.category == 'Cleaning') {
      categoryIcon = Icons.cleaning_services_outlined;
    } else if (report.category == 'Broken Equipment') {
      categoryIcon = Icons.construction_outlined;
    } else if (report.category == 'Escalator') {
      categoryIcon = Icons.stairs_outlined;
    } else if (report.category == 'Elevator') {
      categoryIcon = Icons.elevator_outlined;
    } else if (report.category == 'Lighting') {
      categoryIcon = Icons.lightbulb_outline;
    } else if (report.category == 'Restroom') {
      categoryIcon = Icons.wc_outlined;
    } else if (report.category == 'Water Leakage') {
      categoryIcon = Icons.water_drop_outlined;
    } else if (report.category == 'Electrical') {
      categoryIcon = Icons.bolt_outlined;
    } else if (report.category == 'Air Conditioning') {
      categoryIcon = Icons.ac_unit_outlined;
    }

    // Priority color mapping
    Color priorityBg;
    Color priorityFg;
    if (report.priority == 'High' || report.priority == 'Urgent') {
      priorityBg = const Color(0xFFFFDAD6); // error-container
      priorityFg = const Color(0xFFBA1A1A); // error
    } else if (report.priority == 'Medium') {
      priorityBg = const Color(0xFFFFDCCB); // tertiary-container
      priorityFg = const Color(0xFF813800); // tertiary
    } else {
      priorityBg = const Color(0xFFEFF4FF); // surface-container-low
      priorityFg = const Color(0xFF0058BE); // secondary
    }

    // Status color mapping
    Color statusBg;
    Color statusFg;
    if (report.status == 'Resolved') {
      statusBg = const Color(0xFFDCFCE7); // green-50
      statusFg = const Color(0xFF16A34A); // green-600
    } else if (report.status == 'Assigned' ||
        report.status == 'In Progress' ||
        report.status == 'Repairing') {
      statusBg = const Color(0xFFEADDFF); // primary-fixed
      statusFg = const Color(0xFF6100D6); // primary
    } else {
      statusBg = const Color(0xFFEFF4FF); // surface-container-low
      statusFg = const Color(0xFF4A4456); // on-surface-variant
    }

    // Progress bar timeline calculation
    double progressPercent = 0.1;
    int currentStep = 0;
    if (report.status == 'Submitted') {
      progressPercent = 0.1;
      currentStep = 0;
    } else if (report.status == 'Assigned') {
      progressPercent = 0.45;
      currentStep = 1;
    } else if (report.status == 'Repairing' || report.status == 'In Progress') {
      progressPercent = 0.75;
      currentStep = 2;
    } else if (report.status == 'Resolved') {
      progressPercent = 1.0;
      currentStep = 3;
    }

    // Format DateTime nicely
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr =
        '${months[report.createdTime.month - 1]} ${report.createdTime.day}, ${report.createdTime.year}';

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0), // rounded-3xl (24-28px)
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
          // Header ID & Category Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.ticketId,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0, // label-sm
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B7488), // outline
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(
                          categoryIcon,
                          color: const Color(0xFF6100D6),
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            report.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.0, // title-md/body-lg
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1C30), // on-surface
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF4A4456),
                          size: 12.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.0, // label-sm
                            color: Color(0xFF4A4456),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF4A4456),
                          size: 12.0,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            report.location,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.0,
                              color: Color(0xFF4A4456),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: priorityBg,
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: Text(
                      '${report.priority} Priority'.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: priorityFg,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: statusFg,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          // Horizontal Mini-timeline
          _buildMiniTimeline(currentStep, progressPercent),
          const SizedBox(height: 20.0),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onViewDetails,
                  child: Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0, // label-lg
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: GestureDetector(
                  onTap: onTrackStatus,
                  child: Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFF6100D6),
                        width: 1.0,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Track Status',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTimeline(int currentStep, double progressPercent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gray background line
          Container(
            height: 2.0,
            width: double.infinity,
            color: const Color(0xFFEFF4FF),
          ),
          // Purple active line
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progressPercent,
              child: Container(height: 2.0, color: const Color(0xFF6100D6)),
            ),
          ),
          // Step circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineNode('Sub.', currentStep >= 0),
              _buildTimelineNode('Asg.', currentStep >= 1),
              _buildTimelineNode('Rep.', currentStep >= 2),
              _buildTimelineNode('Res.', currentStep >= 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF6100D6) : const Color(0xFFEFF4FF),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4.0),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9.0,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF6100D6) : const Color(0xFF7B7488),
          ),
        ),
      ],
    );
  }
}
