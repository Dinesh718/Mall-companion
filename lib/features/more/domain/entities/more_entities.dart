class UserProfileEntity {
  final String name;
  final String phone;
  final String avatarUrl;
  final String membershipStatus;
  final int points;

  const UserProfileEntity({
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.membershipStatus,
    required this.points,
  });

  UserProfileEntity copyWith({
    String? name,
    String? phone,
    String? avatarUrl,
    String? membershipStatus,
    int? points,
  }) {
    return UserProfileEntity(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      points: points ?? this.points,
    );
  }
}

class QuickActionEntity {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String type; // e.g., 'parking', 'atm', 'emergency'

  const QuickActionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.type,
  });
}

class MallServiceEntity {
  final String id;
  final String title;
  final String description;
  final String iconName;

  const MallServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class PopularServiceEntity {
  final String id;
  final String title;
  final String description;
  final String iconName;

  const PopularServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class ParkingFloorEntity {
  final String level;
  final int totalSlots;
  final int occupiedSlots;
  final String status; // 'Available', 'Filling Fast', 'Full'

  const ParkingFloorEntity({
    required this.level,
    required this.totalSlots,
    required this.occupiedSlots,
    required this.status,
  });

  ParkingFloorEntity copyWith({
    int? occupiedSlots,
    String? status,
  }) {
    return ParkingFloorEntity(
      level: level,
      totalSlots: totalSlots,
      occupiedSlots: occupiedSlots ?? this.occupiedSlots,
      status: status ?? this.status,
    );
  }
}

class AmenityItemEntity {
  final String id;
  final String title;
  final String description;
  final String locationText;
  final String status; // 'Open', '24/7 Access', etc.
  final String iconName;

  const AmenityItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.locationText,
    required this.status,
    required this.iconName,
  });
}
