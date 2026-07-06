import '../../domain/entities/home_entities.dart';

class VisitorModel extends VisitorEntity {
  const VisitorModel({required super.name, required super.avatarUrl});

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }
}

class MallModel extends MallEntity {
  const MallModel({
    required super.name,
    required super.floor,
    required super.isOpen,
    required super.openTimeText,
    required super.mapImageUrl,
  });

  factory MallModel.fromJson(Map<String, dynamic> json) {
    return MallModel(
      name: json['name'] as String,
      floor: json['floor'] as String,
      isOpen: json['isOpen'] as bool,
      openTimeText: json['openTimeText'] as String,
      mapImageUrl: json['mapImageUrl'] as String,
    );
  }
}

class QuickActionModel extends QuickActionEntity {
  const QuickActionModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.colorHex,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
    );
  }
}

class AmenityModel extends AmenityEntity {
  const AmenityModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.distanceText,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      distanceText: json['distanceText'] as String,
    );
  }
}

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.storeName,
    required super.storeLogoUrl,
    required super.title,
    required super.subtitle,
    required super.distanceText,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      storeName: json['storeName'] as String,
      storeLogoUrl: json['storeLogoUrl'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      distanceText: json['distanceText'] as String,
    );
  }
}

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.dateText,
    required super.locationText,
    required super.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      dateText: json['dateText'] as String,
      locationText: json['locationText'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.cuisine,
    required super.waitTimeMinutes,
    required super.imageUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      waitTimeMinutes: json['waitTimeMinutes'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class ParkingLevelModel extends ParkingLevelEntity {
  const ParkingLevelModel({
    required super.id,
    required super.levelName,
    required super.availableSpots,
    required super.isFull,
  });

  factory ParkingLevelModel.fromJson(Map<String, dynamic> json) {
    return ParkingLevelModel(
      id: json['id'] as String,
      levelName: json['levelName'] as String,
      availableSpots: json['availableSpots'] as int,
      isFull: json['isFull'] as bool,
    );
  }
}

class EmergencyShortcutModel extends EmergencyShortcutEntity {
  const EmergencyShortcutModel({required super.title, required super.subtitle});

  factory EmergencyShortcutModel.fromJson(Map<String, dynamic> json) {
    return EmergencyShortcutModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
    );
  }
}

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required VisitorModel super.visitor,
    required MallModel super.mall,
    required List<QuickActionModel> super.quickActions,
    required List<AmenityModel> super.amenities,
    required List<OfferModel> super.offers,
    required List<EventModel> super.events,
    required List<RestaurantModel> super.restaurants,
    required List<ParkingLevelModel> super.parkingLevels,
    required EmergencyShortcutModel super.emergency,
  });
}
