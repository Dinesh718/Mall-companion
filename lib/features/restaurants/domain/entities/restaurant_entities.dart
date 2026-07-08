class MenuItemEntity {
  final String category;
  final String name;
  final double price;
  final String imageUrl;

  const MenuItemEntity({
    required this.category,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class RestaurantReviewEntity {
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String reviewText;
  final String dateText;

  const RestaurantReviewEntity({
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.reviewText,
    required this.dateText,
  });
}

class TableSlotEntity {
  final String timeSlot;
  final int tableSize;
  final String status; // Available, Reserved

  const TableSlotEntity({
    required this.timeSlot,
    required this.tableSize,
    required this.status,
  });

  TableSlotEntity copyWith({String? status}) {
    return TableSlotEntity(
      timeSlot: timeSlot,
      tableSize: tableSize,
      status: status ?? this.status,
    );
  }
}

class RestaurantOfferEntity {
  final String title;
  final int discountPercentage;
  final String promoCode;

  const RestaurantOfferEntity({
    required this.title,
    required this.discountPercentage,
    required this.promoCode,
  });
}

class RestaurantEntity {
  final String id;
  final String name;
  final String cuisine;
  final String floorText;
  final double rating;
  final String priceRange;
  final String imageUrl;
  final String description;
  final String phone;
  final String website;
  final bool isOpen;
  final String waitTimeText;
  final String walkTimeText;
  final int interestedCount;
  final bool isFavorite;
  final List<String> galleryUrls;
  final List<RestaurantReviewEntity> reviews;
  final List<MenuItemEntity> menu;
  final List<TableSlotEntity> slots;
  final List<RestaurantOfferEntity> offers;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.floorText,
    required this.rating,
    required this.priceRange,
    required this.imageUrl,
    required this.description,
    required this.phone,
    required this.website,
    required this.isOpen,
    required this.waitTimeText,
    required this.walkTimeText,
    required this.interestedCount,
    this.isFavorite = false,
    required this.galleryUrls,
    required this.reviews,
    required this.menu,
    required this.slots,
    required this.offers,
  });

  RestaurantEntity copyWith({
    bool? isFavorite,
    List<TableSlotEntity>? slots,
    int? interestedCount,
  }) {
    return RestaurantEntity(
      id: id,
      name: name,
      cuisine: cuisine,
      floorText: floorText,
      rating: rating,
      priceRange: priceRange,
      imageUrl: imageUrl,
      description: description,
      phone: phone,
      website: website,
      isOpen: isOpen,
      waitTimeText: waitTimeText,
      walkTimeText: walkTimeText,
      interestedCount: interestedCount ?? this.interestedCount,
      isFavorite: isFavorite ?? this.isFavorite,
      galleryUrls: galleryUrls,
      reviews: reviews,
      menu: menu,
      slots: slots ?? this.slots,
      offers: offers,
    );
  }
}
