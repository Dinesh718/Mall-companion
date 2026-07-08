import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';
import '../../../maintenance/presentation/pages/report_issue_page.dart';
import '../../../parking/presentation/pages/parking_page.dart';

class QuickActionsGrid extends StatelessWidget {
  final List<QuickActionEntity> actions;

  const QuickActionsGrid({super.key, required this.actions});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'near_me':
        return Icons.near_me_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'local_parking':
        return Icons.local_parking_outlined;
      case 'wc':
        return Icons.wc_outlined;
      case 'sell':
        return Icons.sell_outlined;
      case 'qr_code_2':
        return Icons.qr_code_2_outlined;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'construction':
        return Icons.construction_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1A25),
                ),
              ),
              TextButton(
                onPressed: () {
                  // See all action
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final action = actions[index];
              final isSos = action.id == 'sos';
              final color = Color(int.parse(action.colorHex));

              return GestureDetector(
                onTap: () {
                  if (action.id == 'report_issue') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReportIssuePage(),
                      ),
                    );
                  } else if (action.id == 'parking') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ParkingPage()),
                    );
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: isSos ? const Color(0xFFFFEBEE) : Colors.white,
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ), // rounded-2xl
                        border: Border.all(
                          color: isSos
                              ? const Color(0xFFFFCDD2)
                              : const Color(0xFFCCC3D9).withOpacity(0.2),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getIconData(action.iconName),
                        color: color,
                        size: 28.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      action.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A4456), // on-surface-variant
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
