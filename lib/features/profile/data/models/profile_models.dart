import '../../domain/entities/profile_entities.dart';

class MembershipModel extends MembershipEntity {
  const MembershipModel({
    required super.id,
    required super.tier,
    required super.points,
    required super.memberSince,
  });
}

class RewardModel extends RewardEntity {
  const RewardModel({
    required super.points,
    required super.description,
  });
}

class ReservationSummaryModel extends ReservationSummaryEntity {
  const ReservationSummaryModel({
    required super.title,
    required super.subtitle,
    required super.timeText,
  });
}

class FavoriteSummaryModel extends FavoriteSummaryEntity {
  const FavoriteSummaryModel({
    required super.count,
    required super.label,
  });
}

class ParkingSummaryModel extends ParkingSummaryEntity {
  const ParkingSummaryModel({
    required super.level,
    required super.spot,
  });
}

class PreferenceModel extends PreferenceEntity {
  const PreferenceModel({
    required super.language,
    required super.theme,
    required super.accessibility,
    required super.recentSearches,
    required super.favoriteRoutes,
    required super.pushNotificationsEnabled,
  });
}

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.name,
    required super.email,
    required super.avatarUrl,
    super.isVerified,
    required super.membership,
    required super.parking,
    required super.reservation,
    required super.favorites,
    required super.preferences,
  });
}

class GuestProfileModel extends GuestProfileEntity {
  const GuestProfileModel({
    required super.preferences,
  });
}
