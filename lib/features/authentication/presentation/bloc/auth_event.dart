import 'package:flutter/foundation.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

class ShowWelcomeEvent extends AuthEvent {
  const ShowWelcomeEvent();
}

class ShowPhoneInputEvent extends AuthEvent {
  const ShowPhoneInputEvent();
}

class ContinueAsGuestEvent extends AuthEvent {
  const ContinueAsGuestEvent();
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  const VerifyOtpEvent(this.otp);
}

class CompleteProfileEvent extends AuthEvent {
  final String fullName;
  final String email;
  const CompleteProfileEvent({required this.fullName, required this.email});
}

class TimerTickedEvent extends AuthEvent {
  final int duration;
  const TimerTickedEvent(this.duration);
}

class ResendOtpEvent extends AuthEvent {
  const ResendOtpEvent();
}
