import '../../domain/entities/profile_entities.dart';
import '../models/profile_models.dart';

abstract class ProfileLocalDataSource {
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

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  // Stateful simulation of login state and user preferences in memory
  static bool _isLoggedIn = true;
  
  static PreferenceEntity _preferences = const PreferenceModel(
    language: 'English',
    theme: 'Light Theme',
    accessibility: 'High Contrast',
    recentSearches: ['Coffee Shops', 'Luxe Boutique', 'Food Court'],
    favoriteRoutes: ['Parking P2 to Atrium', 'North Wing to South Wing'],
    pushNotificationsEnabled: true,
  );

  @override
  Future<bool> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _isLoggedIn;
  }

  @override
  Future<void> signIn() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoggedIn = true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoggedIn = false;
  }

  @override
  Future<void> updatePreferences({
    bool? pushNotifications,
    String? language,
    String? theme,
    String? accessibility,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _preferences = _preferences.copyWith(
      pushNotificationsEnabled: pushNotifications,
      language: language,
      theme: theme,
      accessibility: accessibility,
    );
  }

  @override
  Future<GuestProfileEntity> getGuestProfile() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return GuestProfileModel(preferences: _preferences);
  }

  @override
  Future<UserProfileEntity> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return UserProfileModel(
      name: 'Alex Thompson',
      email: 'alex.thompson@prime-mail.com',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB8MNXy2RGJBdgt-wOnapTYeNzSgRDMm2FhLlh6Xtj47GKARFt2EL1ZANOsfw5Bzq-zJIMqbih-_OYeBrpj9E-8yxEB8kxHDCi_gZasbAaaVTs4iGRPvueOKOxIVAJA61xGeWXUxPh-z3oRCwxOwqAw29x26BkkTuHs5vtovWydvgHXBODyEtoui7Q5t0gRsqxm55sAOC836OKO98v9X53E7OL9k8ugd2EKVtwKsWLGfWYfh0BIL1UEyhwDQh_KHqvzDpBTeGfCPwE',
      isVerified: true,
      membership: const MembershipModel(
        id: '8829 • 4910 • 2024',
        tier: 'Platinum', // or Gold Member
        points: 12450,
        memberSince: '2022',
      ),
      parking: const ParkingSummaryModel(
        level: 'Level 3',
        spot: 'Zone B',
      ),
      reservation: const ReservationSummaryModel(
        title: 'Reservations',
        subtitle: 'Today, 7:00 PM',
        timeText: '7:00 PM',
      ),
      favorites: const FavoriteSummaryModel(
        count: 12,
        label: 'Saved Brands',
      ),
      preferences: _preferences,
    );
  }
}
