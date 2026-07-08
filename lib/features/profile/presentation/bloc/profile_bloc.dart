import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_data_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileData getProfileData;
  final SignInUseCase signInUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateProfilePreferences updateProfilePreferences;

  ProfileBloc({
    required this.getProfileData,
    required this.signInUseCase,
    required this.logoutUseCase,
    required this.updateProfilePreferences,
  }) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<SignInPressed>(_onSignInPressed);
    on<LogoutPressed>(_onLogoutPressed);
    on<ToggleNotification>(_onToggleNotification);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeTheme>(_onChangeTheme);
    on<ChangeAccessibility>(_onChangeAccessibility);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final isLoggedIn = await getProfileData.checkAuthStatus();
      if (isLoggedIn) {
        final profile = await getProfileData.getUserProfile();
        emit(UserProfileLoaded(userProfile: profile));
      } else {
        final profile = await getProfileData.getGuestProfile();
        emit(GuestProfileLoaded(guestProfile: profile));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final isLoggedIn = await getProfileData.checkAuthStatus();
      if (isLoggedIn) {
        final profile = await getProfileData.getUserProfile();
        emit(UserProfileLoaded(userProfile: profile));
      } else {
        final profile = await getProfileData.getGuestProfile();
        emit(GuestProfileLoaded(guestProfile: profile));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onSignInPressed(
    SignInPressed event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await signInUseCase();
      final profile = await getProfileData.getUserProfile();
      emit(UserProfileLoaded(userProfile: profile));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLogoutPressed(
    LogoutPressed event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await logoutUseCase();
      final profile = await getProfileData.getGuestProfile();
      emit(GuestProfileLoaded(guestProfile: profile));
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onToggleNotification(
    ToggleNotification event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await updateProfilePreferences(
        pushNotifications: event.pushNotificationsEnabled,
      );
      add(const RefreshProfile());
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await updateProfilePreferences(language: event.language);
      add(const RefreshProfile());
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await updateProfilePreferences(theme: event.theme);
      add(const RefreshProfile());
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeAccessibility(
    ChangeAccessibility event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await updateProfilePreferences(accessibility: event.accessibility);
      add(const RefreshProfile());
    } catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }
}
