import 'package:flutter/material.dart';
import '../../domain/entities/emergency_entities.dart';

class EmergencyContactCard extends StatelessWidget {
  final List<EmergencyContactEntity> contacts;
  final ValueChanged<String> onCallTap;

  const EmergencyContactCard({
    super.key,
    required this.contacts,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              top: 20.0,
              right: 20.0,
              bottom: 8.0,
            ),
            child: Text(
              'Quick Dial Contacts',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0, // title-lg
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1.0, color: Color(0xFFEFF4FF)),
            itemBuilder: (context, index) {
              final contact = contacts[index];

              // Icon mapping
              IconData icon = Icons.phone;
              Color circleColor = const Color(0xFFEFF4FF);
              Color iconColor = const Color(0xFF6100D6);

              if (contact.iconName == 'security') {
                icon = Icons.security;
                circleColor = const Color(0xFFEFF4FF);
                iconColor = const Color(0xFF6100D6);
              } else if (contact.iconName == 'local_police') {
                icon = Icons.local_police;
                circleColor = const Color(0xFFFFDAD6);
                iconColor = const Color(0xFFBA1A1A);
              } else if (contact.iconName == 'ambulance') {
                icon = Icons.local_hospital;
                circleColor = const Color(0xFFFFDAD6);
                iconColor = const Color(0xFFBA1A1A);
              } else if (contact.iconName == 'local_fire_department') {
                icon = Icons.fire_extinguisher;
                circleColor = const Color(0xFFFFDAD6);
                iconColor = const Color(0xFFBA1A1A);
              } else if (contact.iconName == 'info') {
                icon = Icons.info;
                circleColor = const Color(0xFFEFF4FF);
                iconColor = const Color(0xFF6100D6);
              }

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 4.0,
                ),
                leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: iconColor, size: 20.0),
                ),
                title: Text(
                  contact.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0, // body-lg
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0B1C30),
                  ),
                ),
                subtitle: Text(
                  contact.number,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.0,
                    color: Color(0xFF4A4456),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => onCallTap(contact.number),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6100D6), // primary
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
