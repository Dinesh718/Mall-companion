import 'package:flutter/material.dart';
import '../../domain/entities/home_entities.dart';

class CustomHomeHeader extends StatelessWidget {
  final VisitorEntity visitor;
  final MallEntity mall;

  const CustomHomeHeader({
    super.key,
    required this.visitor,
    required this.mall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gradient border surrounding avatar
          Container(
            width: 44.0,
            height: 44.0,
            padding: const EdgeInsets.all(2.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.network(
                  visitor.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: Color(0xFF4A4456)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          // User welcome and location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Good Morning, ${visitor.name}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1A25),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2.0),
                GestureDetector(
                  onTap: () {
                    // Quick location selection logic
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14.0,
                        color: Color(0xFF6100D6),
                      ),
                      const SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          '${mall.name}, ${mall.floor}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A4456),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 14.0,
                        color: Color(0xFF4A4456),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          // Notifications Bell button
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Notification Hub Action
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF4A4456),
                  size: 24.0,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF3EBFA),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                ),
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1A1A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
