import 'package:flutter/material.dart';
import '../../../domain/entities/profile_entities.dart';
import '../common/profile_avatar.dart';

class UserHeader extends StatelessWidget {
  final UserProfileEntity userProfile;

  const UserHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1FF), // bg-surface-container-low
        borderRadius: BorderRadius.circular(32.0), // rounded-card
        border: Border.all(
          color: const Color(0xFF7B2FF7).withOpacity(
            0.1,
          ), // gradient-border (linear-gradient border simulated)
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          // User Avatar
          ProfileAvatar(
            avatarUrl: userProfile.avatarUrl,
            isVerified: userProfile.isVerified,
            radius: 48.0,
          ),
          const SizedBox(height: 16.0),
          // User Name
          Text(
            userProfile.name,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24.0, // headline-md
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1A25), // on-surface
            ),
          ),
          const SizedBox(height: 4.0),
          // User Email
          Text(
            userProfile.email,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14.0, // body-md
              color: Color(0xFF4A4456), // on-surface-variant
            ),
          ),
          const SizedBox(height: 16.0),
          // Badge Rows
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF7B2FF7,
                  ).withOpacity(0.1), // primary-container
                  borderRadius: BorderRadius.circular(9999.0), // rounded-full
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: Color(0xFF6100D6), size: 14.0),
                    SizedBox(width: 6.0),
                    Text(
                      'Gold Member',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.0, // label-lg
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E2FF), // secondary-fixed
                  borderRadius: BorderRadius.circular(9999.0),
                ),
                child: Text(
                  'Member since ${userProfile.membership.memberSince}',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.0, // label-lg
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF001A42), // on-secondary-fixed
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Edit Profile & QR Code Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Edit Profile is not implemented in this demo.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6100D6), // primary
                      borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_square,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14.0, // label-lg
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: () {
                  _showMembershipQRCode(context);
                },
                child: Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0), // rounded-2xl
                    border: Border.all(
                      color: const Color(0xFFCCC3D9), // outline-variant
                      width: 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.qr_code_2,
                    color: Color(0xFF4A4456), // on-surface-variant
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMembershipQRCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Membership ID',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1A25),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  userProfile.membership.id,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: const Color(0xFFCCC3D9).withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.qr_code,
                    size: 160.0,
                    color: Color(0xFF1D1A25),
                  ),
                ),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE5F5),
                      borderRadius: BorderRadius.circular(9999.0),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6100D6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
