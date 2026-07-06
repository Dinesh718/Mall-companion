import 'package:flutter_test/flutter_test.dart';
import 'package:visitor_mall/features/authentication/domain/entities/auth_user.dart';
import 'package:visitor_mall/features/authentication/domain/repositories/auth_repository.dart';
import 'package:visitor_mall/features/authentication/domain/usecases/complete_profile_usecase.dart';
import 'package:visitor_mall/features/authentication/domain/usecases/continue_as_guest_usecase.dart';
import 'package:visitor_mall/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:visitor_mall/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:visitor_mall/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:visitor_mall/features/authentication/presentation/bloc/auth_event.dart';
import 'package:visitor_mall/features/authentication/presentation/bloc/auth_state.dart';

class MockAuthRepository implements AuthRepository {
  AuthUser? dummyUser;
  bool shouldOtpFail = false;

  @override
  Future<AuthUser> continueAsGuest() async {
    return const AuthUser(
      uid: 'guest_user',
      isGuest: true,
      isProfileComplete: true,
    );
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {}

  @override
  Future<AuthUser> verifyOtp(String phoneNumber, String otp) async {
    if (shouldOtpFail || otp != '123456') {
      throw Exception('Invalid OTP. Please enter 123456.');
    }

    if (phoneNumber == '9876543210') {
      return AuthUser(
        uid: 'user_9876543210',
        phoneNumber: phoneNumber,
        fullName: 'John Doe',
        email: 'johndoe@example.com',
        isGuest: false,
        isProfileComplete: true,
      );
    } else {
      return AuthUser(
        uid: 'user_new',
        phoneNumber: phoneNumber,
        isGuest: false,
        isProfileComplete: false,
      );
    }
  }

  @override
  Future<AuthUser> completeProfile(
    String uid,
    String fullName,
    String email,
  ) async {
    return AuthUser(
      uid: uid,
      fullName: fullName,
      email: email,
      isGuest: false,
      isProfileComplete: true,
    );
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return dummyUser;
  }
}

void main() {
  late MockAuthRepository mockRepository;
  late ContinueAsGuestUseCase continueAsGuestUseCase;
  late SendOtpUseCase sendOtpUseCase;
  late VerifyOtpUseCase verifyOtpUseCase;
  late CompleteProfileUseCase completeProfileUseCase;
  late AuthenticationBloc bloc;

  setUp(() {
    mockRepository = MockAuthRepository();
    continueAsGuestUseCase = ContinueAsGuestUseCase(mockRepository);
    sendOtpUseCase = SendOtpUseCase(mockRepository);
    verifyOtpUseCase = VerifyOtpUseCase(mockRepository);
    completeProfileUseCase = CompleteProfileUseCase(mockRepository);
    bloc = AuthenticationBloc(
      continueAsGuestUseCase: continueAsGuestUseCase,
      sendOtpUseCase: sendOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      completeProfileUseCase: completeProfileUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is correct', () {
    expect(bloc.state.currentScreen, AuthScreen.welcome);
    expect(bloc.state.status, AuthStatus.initial);
    expect(bloc.state.timerCountdown, 30);
    expect(bloc.state.isTimerActive, false);
  });

  test('ShowPhoneInputEvent updates screen to phone input', () async {
    bloc.add(const ShowPhoneInputEvent());
    await Future.delayed(Duration.zero);
    expect(bloc.state.currentScreen, AuthScreen.phoneInput);
  });

  test('ContinueAsGuestEvent logs in guest successfully', () async {
    bloc.add(const ContinueAsGuestEvent());
    // Wait for the mock delay/async execution
    await Future.delayed(const Duration(milliseconds: 600));
    expect(bloc.state.status, AuthStatus.success);
    expect(bloc.state.user?.isGuest, true);
    expect(bloc.state.user?.uid, 'guest_user');
  });

  test('SendOtpEvent shifts to otpVerification view', () async {
    bloc.add(const SendOtpEvent('9876543210'));
    await Future.delayed(const Duration(milliseconds: 900));
    expect(bloc.state.currentScreen, AuthScreen.otpVerification);
    expect(bloc.state.phoneNumber, '9876543210');
    expect(bloc.state.isTimerActive, true);
  });

  test(
    'VerifyOtpEvent succeeds for existing user and completes auth',
    () async {
      bloc.add(const SendOtpEvent('9876543210'));
      await Future.delayed(const Duration(milliseconds: 900));

      bloc.add(const VerifyOtpEvent('123456'));
      await Future.delayed(const Duration(milliseconds: 900));

      expect(bloc.state.status, AuthStatus.success);
      expect(bloc.state.user?.isProfileComplete, true);
      expect(bloc.state.user?.uid, 'user_9876543210');
    },
  );

  test('VerifyOtpEvent moves to completeProfile screen for new user', () async {
    bloc.add(const SendOtpEvent('9999999999'));
    await Future.delayed(const Duration(milliseconds: 900));

    bloc.add(const VerifyOtpEvent('123456'));
    await Future.delayed(const Duration(milliseconds: 900));

    expect(bloc.state.currentScreen, AuthScreen.completeProfile);
    expect(bloc.state.user?.isProfileComplete, false);
  });

  test('VerifyOtpEvent fails when incorrect OTP entered', () async {
    bloc.add(const SendOtpEvent('9876543210'));
    await Future.delayed(const Duration(milliseconds: 900));

    bloc.add(const VerifyOtpEvent('000000'));
    await Future.delayed(const Duration(milliseconds: 900));

    expect(bloc.state.status, AuthStatus.failure);
    expect(bloc.state.errorMessage, 'Invalid OTP. Please enter 123456.');
  });
}
