import '../../domain/entities/profile_entities.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  const ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> checkAuthStatus() async {
    return await localDataSource.checkAuthStatus();
  }

  @override
  Future<GuestProfileEntity> getGuestProfile() async {
    return await localDataSource.getGuestProfile();
  }

  @override
  Future<UserProfileEntity> getUserProfile() async {
    return await localDataSource.getUserProfile();
  }

  @override
  Future<void> signIn() async {
    await localDataSource.signIn();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }

  @override
  Future<void> updatePreferences({
    bool? pushNotifications,
    String? language,
    String? theme,
    String? accessibility,
  }) async {
    await localDataSource.updatePreferences(
      pushNotifications: pushNotifications,
      language: language,
      theme: theme,
      accessibility: accessibility,
    );
  }
}
