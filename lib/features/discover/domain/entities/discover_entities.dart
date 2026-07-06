class DiscoverCategoryEntity {
  final String id;
  final String title;
  final String iconName;
  final String colorHex;
  final String bgHex;

  const DiscoverCategoryEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.colorHex,
    required this.bgHex,
  });
}

class DiscoverStoreEntity {
  final String id;
  final String name;
  final String category;
  final String floorText;
  final String imageUrl;
  final double rating;

  const DiscoverStoreEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.floorText,
    required this.imageUrl,
    required this.rating,
  });
}

class DiscoverRestaurantEntity {
  final String id;
  final String name;
  final String cuisine;
  final String floorText;
  final String imageUrl;
  final double rating;
  final String waitTimeText;
  final String walkTimeText;
  final bool isOpen;

  const DiscoverRestaurantEntity({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.floorText,
    required this.imageUrl,
    required this.rating,
    required this.waitTimeText,
    required this.walkTimeText,
    required this.isOpen,
  });
}

class DiscoverAmenityEntity {
  final String id;
  final String title;
  final String iconName;
  final String distanceText;

  const DiscoverAmenityEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.distanceText,
  });
}

class DiscoverTheatreEntity {
  final String id;
  final String title;
  final String cinemaName;
  final String imageUrl;

  const DiscoverTheatreEntity({
    required this.id,
    required this.title,
    required this.cinemaName,
    required this.imageUrl,
  });
}

class DiscoverDataEntity {
  final List<DiscoverCategoryEntity> categories;
  final List<DiscoverStoreEntity> popularStores;
  final List<DiscoverRestaurantEntity> trendingDining;
  final List<DiscoverAmenityEntity> amenities;
  final List<DiscoverTheatreEntity> popularTheatres;

  const DiscoverDataEntity({
    required this.categories,
    required this.popularStores,
    required this.trendingDining,
    required this.amenities,
    required this.popularTheatres,
  });
}

class ScheduleItemEntity {
  final String timeText;
  final String title;
  final bool isLiveNow;

  const ScheduleItemEntity({
    required this.timeText,
    required this.title,
    this.isLiveNow = false,
  });
}

class MallEventEntity {
  final String id;
  final String name;
  final String description;
  final String category;
  final String dateText;
  final String timeText;
  final String venueName;
  final String floorText;
  final String organizerName;
  final String organizerLogoUrl;
  final int remainingSeats;
  final String entryType;
  final double price;
  final int interestedCount;
  final bool isBookmarked;
  final bool isRegistered;
  final String imageUrl;
  final List<String> galleryUrls;
  final String statusText; // Live Now, Ongoing, Upcoming, etc.
  final List<ScheduleItemEntity> schedule;

  const MallEventEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.dateText,
    required this.timeText,
    required this.venueName,
    required this.floorText,
    required this.organizerName,
    required this.organizerLogoUrl,
    required this.remainingSeats,
    required this.entryType,
    required this.price,
    required this.interestedCount,
    this.isBookmarked = false,
    this.isRegistered = false,
    required this.imageUrl,
    required this.galleryUrls,
    required this.statusText,
    required this.schedule,
  });

  MallEventEntity copyWith({
    bool? isBookmarked,
    bool? isRegistered,
    int? interestedCount,
    int? remainingSeats,
  }) {
    return MallEventEntity(
      id: id,
      name: name,
      description: description,
      category: category,
      dateText: dateText,
      timeText: timeText,
      venueName: venueName,
      floorText: floorText,
      organizerName: organizerName,
      organizerLogoUrl: organizerLogoUrl,
      remainingSeats: remainingSeats ?? this.remainingSeats,
      entryType: entryType,
      price: price,
      interestedCount: interestedCount ?? this.interestedCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRegistered: isRegistered ?? this.isRegistered,
      imageUrl: imageUrl,
      galleryUrls: galleryUrls,
      statusText: statusText,
      schedule: schedule,
    );
  }
}
