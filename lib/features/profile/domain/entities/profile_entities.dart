class MembershipEntity {
  final String id;
  final String tier;
  final int points;
  final String memberSince;

  const MembershipEntity({
    required this.id,
    required this.tier,
    required this.points,
    required this.memberSince,
  });
}

class RewardEntity {
  final int points;
  final String description;

  const RewardEntity({required this.points, required this.description});
}

class ReservationSummaryEntity {
  final String title;
  final String subtitle;
  final String timeText;

  const ReservationSummaryEntity({
    required this.title,
    required this.subtitle,
    required this.timeText,
  });
}

class FavoriteSummaryEntity {
  final int count;
  final String label;

  const FavoriteSummaryEntity({required this.count, required this.label});
}

class ParkingSummaryEntity {
  final String level;
  final String spot;

  const ParkingSummaryEntity({required this.level, required this.spot});
}

class PreferenceEntity {
  final String language;
  final String theme;
  final String accessibility;
  final List<String> recentSearches;
  final List<String> favoriteRoutes;
  final bool pushNotificationsEnabled;

  const PreferenceEntity({
    required this.language,
    required this.theme,
    required this.accessibility,
    required this.recentSearches,
    required this.favoriteRoutes,
    required this.pushNotificationsEnabled,
  });

  PreferenceEntity copyWith({
    String? language,
    String? theme,
    String? accessibility,
    List<String>? recentSearches,
    List<String>? favoriteRoutes,
    bool? pushNotificationsEnabled,
  }) {
    return PreferenceEntity(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      accessibility: accessibility ?? this.accessibility,
      recentSearches: recentSearches ?? this.recentSearches,
      favoriteRoutes: favoriteRoutes ?? this.favoriteRoutes,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}

class UserProfileEntity {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isVerified;
  final MembershipEntity membership;
  final ParkingSummaryEntity parking;
  final ReservationSummaryEntity reservation;
  final FavoriteSummaryEntity favorites;
  final PreferenceEntity preferences;

  const UserProfileEntity({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isVerified = false,
    required this.membership,
    required this.parking,
    required this.reservation,
    required this.favorites,
    required this.preferences,
  });

  UserProfileEntity copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    bool? isVerified,
    MembershipEntity? membership,
    ParkingSummaryEntity? parking,
    ReservationSummaryEntity? reservation,
    FavoriteSummaryEntity? favorites,
    PreferenceEntity? preferences,
  }) {
    return UserProfileEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      membership: membership ?? this.membership,
      parking: parking ?? this.parking,
      reservation: reservation ?? this.reservation,
      favorites: favorites ?? this.favorites,
      preferences: preferences ?? this.preferences,
    );
  }
}

class GuestProfileEntity {
  final PreferenceEntity preferences;

  const GuestProfileEntity({required this.preferences});

  GuestProfileEntity copyWith({PreferenceEntity? preferences}) {
    return GuestProfileEntity(preferences: preferences ?? this.preferences);
  }
}
