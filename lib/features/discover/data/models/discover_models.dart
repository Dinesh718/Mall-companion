import '../../domain/entities/discover_entities.dart';

class DiscoverCategoryModel extends DiscoverCategoryEntity {
  const DiscoverCategoryModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.colorHex,
    required super.bgHex,
  });

  factory DiscoverCategoryModel.fromJson(Map<String, dynamic> json) {
    return DiscoverCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
      bgHex: json['bgHex'] as String,
    );
  }
}

class DiscoverStoreModel extends DiscoverStoreEntity {
  const DiscoverStoreModel({
    required super.id,
    required super.name,
    required super.category,
    required super.floorText,
    required super.imageUrl,
    required super.rating,
  });

  factory DiscoverStoreModel.fromJson(Map<String, dynamic> json) {
    return DiscoverStoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      floorText: json['floorText'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class DiscoverRestaurantModel extends DiscoverRestaurantEntity {
  const DiscoverRestaurantModel({
    required super.id,
    required super.name,
    required super.cuisine,
    required super.floorText,
    required super.imageUrl,
    required super.rating,
    required super.waitTimeText,
    required super.walkTimeText,
    required super.isOpen,
  });

  factory DiscoverRestaurantModel.fromJson(Map<String, dynamic> json) {
    return DiscoverRestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      floorText: json['floorText'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      waitTimeText: json['waitTimeText'] as String,
      walkTimeText: json['walkTimeText'] as String,
      isOpen: json['isOpen'] as bool,
    );
  }
}

class DiscoverAmenityModel extends DiscoverAmenityEntity {
  const DiscoverAmenityModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.distanceText,
  });

  factory DiscoverAmenityModel.fromJson(Map<String, dynamic> json) {
    return DiscoverAmenityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      distanceText: json['distanceText'] as String,
    );
  }
}

class DiscoverTheatreModel extends DiscoverTheatreEntity {
  const DiscoverTheatreModel({
    required super.id,
    required super.title,
    required super.cinemaName,
    required super.imageUrl,
  });

  factory DiscoverTheatreModel.fromJson(Map<String, dynamic> json) {
    return DiscoverTheatreModel(
      id: json['id'] as String,
      title: json['title'] as String,
      cinemaName: json['cinemaName'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class DiscoverDataModel extends DiscoverDataEntity {
  const DiscoverDataModel({
    required List<DiscoverCategoryModel> super.categories,
    required List<DiscoverStoreModel> super.popularStores,
    required List<DiscoverRestaurantModel> super.trendingDining,
    required List<DiscoverAmenityModel> super.amenities,
    required List<DiscoverTheatreModel> super.popularTheatres,
  });
}

class ScheduleItemModel extends ScheduleItemEntity {
  const ScheduleItemModel({
    required super.timeText,
    required super.title,
    super.isLiveNow,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      timeText: json['timeText'] as String,
      title: json['title'] as String,
      isLiveNow: json['isLiveNow'] as bool? ?? false,
    );
  }
}

class MallEventModel extends MallEventEntity {
  const MallEventModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.dateText,
    required super.timeText,
    required super.venueName,
    required super.floorText,
    required super.organizerName,
    required super.organizerLogoUrl,
    required super.remainingSeats,
    required super.entryType,
    required super.price,
    required super.interestedCount,
    super.isBookmarked,
    super.isRegistered,
    required super.imageUrl,
    required super.galleryUrls,
    required super.statusText,
    required List<ScheduleItemModel> super.schedule,
  });

  factory MallEventModel.fromJson(Map<String, dynamic> json) {
    return MallEventModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      dateText: json['dateText'] as String,
      timeText: json['timeText'] as String,
      venueName: json['venueName'] as String,
      floorText: json['floorText'] as String,
      organizerName: json['organizerName'] as String,
      organizerLogoUrl: json['organizerLogoUrl'] as String,
      remainingSeats: json['remainingSeats'] as int,
      entryType: json['entryType'] as String,
      price: (json['price'] as num).toDouble(),
      interestedCount: json['interestedCount'] as int,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isRegistered: json['isRegistered'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String,
      galleryUrls: List<String>.from(json['galleryUrls'] as List),
      statusText: json['statusText'] as String,
      schedule: (json['schedule'] as List)
          .map(
            (item) => ScheduleItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
