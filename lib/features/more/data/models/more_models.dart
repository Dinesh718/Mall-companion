import '../../domain/entities/more_entities.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.name,
    required super.phone,
    required super.avatarUrl,
    required super.membershipStatus,
    required super.points,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String,
      membershipStatus: json['membershipStatus'] as String,
      points: json['points'] as int,
    );
  }
}

class QuickActionModel extends QuickActionEntity {
  const QuickActionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
    required super.type,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      type: json['type'] as String,
    );
  }
}

class MallServiceModel extends MallServiceEntity {
  const MallServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
  });

  factory MallServiceModel.fromJson(Map<String, dynamic> json) {
    return MallServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
    );
  }
}

class PopularServiceModel extends PopularServiceEntity {
  const PopularServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconName,
  });

  factory PopularServiceModel.fromJson(Map<String, dynamic> json) {
    return PopularServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
    );
  }
}

class ParkingFloorModel extends ParkingFloorEntity {
  const ParkingFloorModel({
    required super.level,
    required super.totalSlots,
    required super.occupiedSlots,
    required super.status,
  });

  factory ParkingFloorModel.fromJson(Map<String, dynamic> json) {
    return ParkingFloorModel(
      level: json['level'] as String,
      totalSlots: json['totalSlots'] as int,
      occupiedSlots: json['occupiedSlots'] as int,
      status: json['status'] as String,
    );
  }
}

class AmenityItemModel extends AmenityItemEntity {
  const AmenityItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.locationText,
    required super.status,
    required super.iconName,
  });

  factory AmenityItemModel.fromJson(Map<String, dynamic> json) {
    return AmenityItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      locationText: json['locationText'] as String,
      status: json['status'] as String,
      iconName: json['iconName'] as String,
    );
  }
}
