// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/permission_bloc.dart';
import '../bloc/permission_event.dart';
import '../bloc/permission_state.dart';
import '../widgets/location_permission_slide.dart';
import '../widgets/camera_permission_slide.dart';
import '../widgets/notification_permission_slide.dart';
import '../../../mall_detection/presentation/pages/mall_detection_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PermissionBloc(),
      child: BlocConsumer<PermissionBloc, PermissionState>(
        listener: (context, state) {
          // Handle screen navigation when flow is completed
          if (state.status == PermissionRequestStatus.navigateNext) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MallDetectionPage()),
            );
          }

          // Handle standard denial message
          if (state.status == PermissionRequestStatus.denied &&
              state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: const Color(0xFFBA1A1A),
                duration: const Duration(seconds: 3),
              ),
            );
          }

          // Handle permanently denied dialog
          if (state.status == PermissionRequestStatus.permanentlyDenied) {
            _showPermanentlyDeniedDialog(context, state.currentPermissionType);
          }

          // Sync PageView index when state index changes
          if (_pageController.hasClients) {
            final page = _pageController.page?.round();
            if (page != state.currentPageIndex) {
              _pageController.animateToPage(
                state.currentPageIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            body: Stack(
              children: [
                // 1. Background Blur shapes (per page accenting)
                _buildBackgroundDecorations(state.currentPageIndex),

                // 2. Safe Area layout content
                SafeArea(
                  child: Column(
                    children: [
                      // Header Navigation Bar
                      _buildHeader(context, state),

                      // Swiping Slides
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            context.read<PermissionBloc>().add(
                              UpdatePageIndex(index),
                            );
                          },
                          children: const [
                            LocationPermissionSlide(),
                            CameraPermissionSlide(),
                            NotificationPermissionSlide(),
                          ],
                        ),
                      ),

                      // Dots Indicator static at the bottom
                      _buildStaticDots(state.currentPageIndex),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundDecorations(int pageIndex) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Stack(
                children: [
                  if (pageIndex == 0) ...[
                    // Location: top-left soft purple container glow
                    Positioned(
                      top: -80,
                      left: -80,
                      width: 260,
                      height: 260,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7B2FF7).withOpacity(0.08),
                        ),
                      ),
                    ),
                  ] else if (pageIndex == 1) ...[
                    // Camera: soft primary center radial glow
                    Positioned(
                      top: 100,
                      left: 100,
                      width: 200,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6100D6).withOpacity(0.05),
                        ),
                      ),
                    ),
                  ] else if (pageIndex == 2) ...[
                    // Notifications: soft pulse slow background glow
                    Positioned(
                      top: 150,
                      right: -50,
                      width: 300,
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7423F0).withOpacity(0.06),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PermissionState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          IconButton(
            onPressed: () {
              // Pressing close exits/skips flow on optional, warning on required
              if (state.currentPageIndex < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${state.currentPageIndex == 0 ? "Location" : "Camera"} permission is required to proceed.',
                    ),
                    backgroundColor: const Color(0xFFBA1A1A),
                  ),
                );
              } else {
                context.read<PermissionBloc>().add(
                  const SkipNotificationPermission(),
                );
              }
            },
            icon: const Icon(Icons.close, color: Color(0xFF121C2A), size: 24.0),
            splashRadius: 20.0,
          ),
          // Skip button (Hidden / Ignored on mandatory slides, Skip event on optional)
          AnimatedOpacity(
            opacity: state.currentPageIndex == 2 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: state.currentPageIndex < 2,
              child: TextButton(
                onPressed: () {
                  context.read<PermissionBloc>().add(
                    const SkipNotificationPermission(),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6100D6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticDots(int currentPageIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = currentPageIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: isActive ? 10.0 : 8.0,
            height: isActive ? 10.0 : 8.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? const Color(0xFF6100D6)
                  : const Color(0xFFCCC3D9).withOpacity(0.4),
            ),
          );
        }),
      ),
    );
  }

  void _showPermanentlyDeniedDialog(
    BuildContext context,
    Permission? permissionType,
  ) {
    final name = permissionType == Permission.location ? 'Location' : 'Camera';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Text(
          '$name Permission Required',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'We need $name access to provide you with mall features. Please open system settings, enable $name, and return to the application.',
          style: const TextStyle(fontFamily: 'Inter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Inter', color: Color(0xFF4A4456)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6100D6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
