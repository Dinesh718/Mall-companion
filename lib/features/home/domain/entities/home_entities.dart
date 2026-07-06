class VisitorEntity {
  final String name;
  final String avatarUrl;

  const VisitorEntity({required this.name, required this.avatarUrl});
}

class MallEntity {
  final String name;
  final String floor;
  final bool isOpen;
  final String openTimeText;
  final String mapImageUrl;

  const MallEntity({
    required this.name,
    required this.floor,
    required this.isOpen,
    required this.openTimeText,
    required this.mapImageUrl,
  });
}

class QuickActionEntity {
  final String id;
  final String title;
  final String iconName;
  final String colorHex;

  const QuickActionEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.colorHex,
  });
}

class AmenityEntity {
  final String id;
  final String title;
  final String iconName;
  final String distanceText;

  const AmenityEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.distanceText,
  });
}

class OfferEntity {
  final String id;
  final String storeName;
  final String storeLogoUrl;
  final String title;
  final String subtitle;
  final String distanceText;

  const OfferEntity({
    required this.id,
    required this.storeName,
    required this.storeLogoUrl,
    required this.title,
    required this.subtitle,
    required this.distanceText,
  });
}

class EventEntity {
  final String id;
  final String title;
  final String subtitle;
  final String dateText;
  final String locationText;
  final String imageUrl;

  const EventEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.dateText,
    required this.locationText,
    required this.imageUrl,
  });
}

class RestaurantEntity {
  final String id;
  final String name;
  final String cuisine;
  final int waitTimeMinutes;
  final String imageUrl;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.waitTimeMinutes,
    required this.imageUrl,
  });
}

class ParkingLevelEntity {
  final String id;
  final String levelName;
  final int availableSpots;
  final bool isFull;

  const ParkingLevelEntity({
    required this.id,
    required this.levelName,
    required this.availableSpots,
    required this.isFull,
  });
}

class EmergencyShortcutEntity {
  final String title;
  final String subtitle;

  const EmergencyShortcutEntity({required this.title, required this.subtitle});
}

class HomeDataEntity {
  final VisitorEntity visitor;
  final MallEntity mall;
  final List<QuickActionEntity> quickActions;
  final List<AmenityEntity> amenities;
  final List<OfferEntity> offers;
  final List<EventEntity> events;
  final List<RestaurantEntity> restaurants;
  final List<ParkingLevelEntity> parkingLevels;
  final EmergencyShortcutEntity emergency;

  const HomeDataEntity({
    required this.visitor,
    required this.mall,
    required this.quickActions,
    required this.amenities,
    required this.offers,
    required this.events,
    required this.restaurants,
    required this.parkingLevels,
    required this.emergency,
  });
}
