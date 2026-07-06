import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/continue_as_guest_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthEvent, AuthState> {
  final ContinueAsGuestUseCase continueAsGuestUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final CompleteProfileUseCase completeProfileUseCase;

  StreamSubscription<int>? _timerSubscription;

  AuthenticationBloc({
    ContinueAsGuestUseCase? continueAsGuestUseCase,
    SendOtpUseCase? sendOtpUseCase,
    VerifyOtpUseCase? verifyOtpUseCase,
    CompleteProfileUseCase? completeProfileUseCase,
  }) : continueAsGuestUseCase =
           continueAsGuestUseCase ??
           ContinueAsGuestUseCase(AuthRepositoryImpl()),
       sendOtpUseCase = sendOtpUseCase ?? SendOtpUseCase(AuthRepositoryImpl()),
       verifyOtpUseCase =
           verifyOtpUseCase ?? VerifyOtpUseCase(AuthRepositoryImpl()),
       completeProfileUseCase =
           completeProfileUseCase ??
           CompleteProfileUseCase(AuthRepositoryImpl()),
       super(AuthState.initial()) {
    on<ShowWelcomeEvent>(_onShowWelcome);
    on<ShowPhoneInputEvent>(_onShowPhoneInput);
    on<ContinueAsGuestEvent>(_onContinueAsGuest);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CompleteProfileEvent>(_onCompleteProfile);
    on<TimerTickedEvent>(_onTimerTicked);
    on<ResendOtpEvent>(_onResendOtp);
  }

  void _onShowWelcome(ShowWelcomeEvent event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        currentScreen: AuthScreen.welcome,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onShowPhoneInput(ShowPhoneInputEvent event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        currentScreen: AuthScreen.phoneInput,
        status: AuthStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onContinueAsGuest(
    ContinueAsGuestEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await continueAsGuestUseCase();
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await sendOtpUseCase(event.phoneNumber);
      emit(
        state.copyWith(
          status: AuthStatus.initial,
          currentScreen: AuthScreen.otpVerification,
          phoneNumber: event.phoneNumber,
          timerCountdown: 30,
          isTimerActive: true,
        ),
      );
      _startTimer();
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await verifyOtpUseCase(state.phoneNumber ?? '', event.otp);
      _timerSubscription?.cancel();

      if (!user.isProfileComplete) {
        emit(
          state.copyWith(
            status: AuthStatus.initial,
            currentScreen: AuthScreen.completeProfile,
            user: user,
            isTimerActive: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.success,
            user: user,
            isTimerActive: false,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onCompleteProfile(
    CompleteProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await completeProfileUseCase(
        state.user?.uid ?? '',
        event.fullName,
        event.email,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _onTimerTicked(TimerTickedEvent event, Emitter<AuthState> emit) {
    if (event.duration > 0) {
      emit(state.copyWith(timerCountdown: event.duration, isTimerActive: true));
    } else {
      emit(state.copyWith(timerCountdown: 0, isTimerActive: false));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await sendOtpUseCase(state.phoneNumber ?? '');
      emit(
        state.copyWith(
          status: AuthStatus.initial,
          timerCountdown: 30,
          isTimerActive: true,
        ),
      );
      _startTimer();
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void _startTimer() {
    _timerSubscription?.cancel();
    _timerSubscription =
        Stream.periodic(
          const Duration(seconds: 1),
          (x) => 29 - x,
        ).take(30).listen((tick) {
          add(TimerTickedEvent(tick));
        });
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}
