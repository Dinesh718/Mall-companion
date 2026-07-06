import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_user.dart';

enum AuthScreen { welcome, phoneInput, otpVerification, completeProfile }

enum AuthStatus { initial, loading, success, failure }

@immutable
class AuthState {
  final AuthScreen currentScreen;
  final AuthStatus status;
  final String? phoneNumber;
  final String? otp;
  final int timerCountdown;
  final bool isTimerActive;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({
    required this.currentScreen,
    required this.status,
    this.phoneNumber,
    this.otp,
    required this.timerCountdown,
    required this.isTimerActive,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      currentScreen: AuthScreen.welcome,
      status: AuthStatus.initial,
      timerCountdown: 30,
      isTimerActive: false,
    );
  }

  AuthState copyWith({
    AuthScreen? currentScreen,
    AuthStatus? status,
    String? phoneNumber,
    String? otp,
    int? timerCountdown,
    bool? isTimerActive,
    AuthUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      currentScreen: currentScreen ?? this.currentScreen,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      timerCountdown: timerCountdown ?? this.timerCountdown,
      isTimerActive: isTimerActive ?? this.isTimerActive,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
