import 'package:flutter/material.dart';
import '../../../domain/entities/profile_entities.dart';

class MembershipCard extends StatelessWidget {
  final UserProfileEntity userProfile;

  const MembershipCard({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withOpacity(0.2),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative blurry circles in background
          Positioned(
            right: -24.0,
            top: -24.0,
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24.0,
            bottom: -24.0,
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Inner Glass Card
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24.0), // rounded-2xl
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header Row (Logo text and contactless indicator)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mall Companion Member',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12.0, // label-lg
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            userProfile.name.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16.0, // title-lg
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.contactless,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                  // Barcode & Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Membership ID',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11.0, // label-md
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            userProfile.membership.id,
                            style: const TextStyle(
                              fontFamily: 'Courier New', // Monospaced look
                              fontSize: 14.0, // body-lg
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // Stats block
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Points',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11.0, // label-md
                                      color: Colors.white60,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    _formatPoints(userProfile.membership.points),
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 20.0, // headline-md (20-24px)
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 32.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Status',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11.0, // label-md
                                      color: Colors.white60,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    userProfile.membership.tier,
                                    style: const TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 20.0, // headline-md (20-24px)
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      // QR Code Icon card
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          color: Color(0xFF1D1A25), // on-surface
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000) {
      final str = points.toString();
      final length = str.length;
      return '${str.substring(0, length - 3)},${str.substring(length - 3)}';
    }
    return points.toString();
  }
}
