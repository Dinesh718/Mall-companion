import 'package:flutter/foundation.dart';

@immutable
class OnboardingState {
  final int currentPageIndex;
  final bool onboardingCompleted;

  const OnboardingState({
    required this.currentPageIndex,
    required this.onboardingCompleted,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      currentPageIndex: 0,
      onboardingCompleted: false,
    );
  }

  OnboardingState copyWith({int? currentPageIndex, bool? onboardingCompleted}) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  bool get isLastPage => currentPageIndex == 2;
}
