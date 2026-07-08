import '../entities/profile_entities.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();
  Future<GuestProfileEntity> getGuestProfile();
  Future<bool> checkAuthStatus();
  Future<void> signIn();
  Future<void> logout();
  Future<void> updatePreferences({
    bool? pushNotifications,
    String? language,
    String? theme,
    String? accessibility,
  });
}
