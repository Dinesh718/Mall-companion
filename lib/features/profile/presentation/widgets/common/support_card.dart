import 'package:flutter/material.dart';
import 'menu_tile.dart';
import '../../../../maintenance/presentation/pages/my_reports_page.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(0xFFCCC3D9).withOpacity(0.2), // outline-variant/20
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuTile(
            leadingIcon: Icons.help,
            title: 'Help Center',
            showDivider: true,
            onTap: () {},
          ),
          MenuTile(
            leadingIcon: Icons.quiz,
            title: 'FAQs',
            showDivider: true,
            onTap: () {},
          ),
          MenuTile(
            leadingIcon: Icons.support_agent,
            title: 'Contact Support',
            showDivider: true,
            onTap: () {},
          ),
          MenuTile(
            leadingIcon: Icons.assignment_outlined,
            title: 'My Maintenance Reports',
            showDivider: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyReportsPage()),
              );
            },
          ),
          MenuTile(
            leadingIcon: Icons.description,
            title: 'Terms & Privacy',
            showDivider: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
