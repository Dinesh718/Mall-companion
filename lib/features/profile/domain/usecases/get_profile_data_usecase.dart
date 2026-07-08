import '../entities/profile_entities.dart';
import '../repository/profile_repository.dart';

class GetProfileData {
  final ProfileRepository repository;

  const GetProfileData(this.repository);

  Future<UserProfileEntity> getUserProfile() async {
    return await repository.getUserProfile();
  }

  Future<GuestProfileEntity> getGuestProfile() async {
    return await repository.getGuestProfile();
  }

  Future<bool> checkAuthStatus() async {
    return await repository.checkAuthStatus();
  }
}

class SignInUseCase {
  final ProfileRepository repository;

  const SignInUseCase(this.repository);

  Future<void> call() async {
    await repository.signIn();
  }
}

class LogoutUseCase {
  final ProfileRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}

class UpdateProfilePreferences {
  final ProfileRepository repository;

  const UpdateProfilePreferences(this.repository);

  Future<void> call({
    bool? pushNotifications,
    String? language,
    String? theme,
    String? accessibility,
  }) async {
    await repository.updatePreferences(
      pushNotifications: pushNotifications,
      language: language,
      theme: theme,
      accessibility: accessibility,
    );
  }
}
