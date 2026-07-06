// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitor_mall/features/permission/presentation/pages/permission_page.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_slide_layout.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
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
      create: (_) => OnboardingBloc(),
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) {
          // Navigate to Home screen when onboarding is completed
          if (state.onboardingCompleted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PermissionPage()),
            );
          }

          // Sync PageView index when state changes (e.g. Next / Skip pressed)
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
                // 1. Animated Background Decorations
                _buildBackgroundDecorations(state.currentPageIndex),

                // 2. Safe Area Content
                SafeArea(
                  child: Column(
                    children: [
                      // Header Navigation Bar
                      _buildHeader(context, state),

                      // Main Swiping Content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            context.read<OnboardingBloc>().add(
                              OnboardingPageChanged(index),
                            );
                          },
                          children: const [
                            OnboardingSlideLayout(pageIndex: 0),
                            OnboardingSlideLayout(pageIndex: 1),
                            OnboardingSlideLayout(pageIndex: 2),
                          ],
                        ),
                      ),

                      // Footer Actions & Page Indicator
                      _buildFooter(context, state),
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
          // Blurred background blobs
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Stack(
                children: [
                  if (pageIndex == 0) ...[
                    // Page 1: Top-Left Purple Blur
                    Positioned(
                      top: -100,
                      left: -100,
                      width: 300,
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD2BBFF).withOpacity(0.4),
                        ),
                      ),
                    ),
                  ] else if (pageIndex == 1) ...[
                    // Page 2: Top-Right Violet, Bottom-Left Blue Blur
                    Positioned(
                      top: -50,
                      right: -50,
                      width: 250,
                      height: 250,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6100D6).withOpacity(0.15),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      left: -100,
                      width: 350,
                      height: 350,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0058BE).withOpacity(0.15),
                        ),
                      ),
                    ),
                  ] else if (pageIndex == 2) ...[
                    // Page 3: Top-Right Violet Blur
                    Positioned(
                      top: -150,
                      right: -150,
                      width: 400,
                      height: 400,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6100D6).withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Page 3 Bottom Linear Gradient Wave (Not blurred)
          if (pageIndex == 2)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00F8F9FF),
                      Color(0x0D6100D6), // 5% purple gradient tint
                      Color(0xFFF8F9FF),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close Icon
          IconButton(
            onPressed: () {
              context.read<OnboardingBloc>().add(
                const OnboardingFinishRequested(),
              );
            },
            icon: const Icon(Icons.close, color: Color(0xFF6100D6), size: 24.0),
            splashRadius: 20.0,
          ),
          // Skip Button (Hidden on last page)
          AnimatedOpacity(
            opacity: state.isLastPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: state.isLastPage,
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                    const OnboardingSkipRequested(),
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

  Widget _buildFooter(BuildContext context, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Page Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = state.currentPageIndex == index;
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
          const SizedBox(height: 24.0),
          // 2. Primary Gradient CTA Button
          _GradientButton(
            text: state.isLastPage ? 'Get Started' : 'Next',
            icon: state.isLastPage
                ? null
                : const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18.0,
                  ),
            onPressed: () {
              context.read<OnboardingBloc>().add(
                const OnboardingNextPageRequested(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;

  const _GradientButton({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7).withOpacity(0.24),
            blurRadius: 16.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            if (icon != null) ...[const SizedBox(width: 8.0), icon!],
          ],
        ),
      ),
    );
  }
}
