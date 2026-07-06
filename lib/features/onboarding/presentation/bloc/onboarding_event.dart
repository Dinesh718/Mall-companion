import 'package:flutter/foundation.dart';

@immutable
sealed class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingPageChanged extends OnboardingEvent {
  final int index;
  const OnboardingPageChanged(this.index);
}

class OnboardingNextPageRequested extends OnboardingEvent {
  const OnboardingNextPageRequested();
}

class OnboardingPreviousPageRequested extends OnboardingEvent {
  const OnboardingPreviousPageRequested();
}

class OnboardingSkipRequested extends OnboardingEvent {
  const OnboardingSkipRequested();
}

class OnboardingFinishRequested extends OnboardingEvent {
  const OnboardingFinishRequested();
}
