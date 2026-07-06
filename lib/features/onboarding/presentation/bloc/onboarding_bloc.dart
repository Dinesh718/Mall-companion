import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState.initial()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPageRequested>(_onNextPageRequested);
    on<OnboardingPreviousPageRequested>(_onPreviousPageRequested);
    on<OnboardingSkipRequested>(_onSkipRequested);
    on<OnboardingFinishRequested>(_onFinishRequested);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPageIndex: event.index));
  }

  void _onNextPageRequested(
    OnboardingNextPageRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentPageIndex < 2) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex + 1));
    } else {
      emit(state.copyWith(onboardingCompleted: true));
    }
  }

  void _onPreviousPageRequested(
    OnboardingPreviousPageRequested event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.currentPageIndex > 0) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex - 1));
    }
  }

  void _onSkipRequested(
    OnboardingSkipRequested event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(onboardingCompleted: true));
  }

  void _onFinishRequested(
    OnboardingFinishRequested event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(onboardingCompleted: true));
  }
}
