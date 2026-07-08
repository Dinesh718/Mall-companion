import '../../domain/entities/restaurant_entities.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.category,
    required super.name,
    required super.price,
    required super.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      category: json['category'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class RestaurantReviewModel extends RestaurantReviewEntity {
  const RestaurantReviewModel({
    required super.userName,
    required super.userAvatarUrl,
    required super.rating,
    required super.reviewText,
    required super.dateText,
  });

  factory RestaurantReviewModel.fromJson(Map<String, dynamic> json) {
    return RestaurantReviewModel(
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String,
      dateText: json['dateText'] as String,
    );
  }
}

class TableSlotModel extends TableSlotEntity {
  const TableSlotModel({
    required super.timeSlot,
    required super.tableSize,
    required super.status,
  });

  factory TableSlotModel.fromJson(Map<String, dynamic> json) {
    return TableSlotModel(
      timeSlot: json['timeSlot'] as String,
      tableSize: json['tableSize'] as int,
      status: json['status'] as String,
    );
  }
}

class RestaurantOfferModel extends RestaurantOfferEntity {
  const RestaurantOfferModel({
    required super.title,
    required super.discountPercentage,
    required super.promoCode,
  });

  factory RestaurantOfferModel.fromJson(Map<String, dynamic> json) {
    return RestaurantOfferModel(
      title: json['title'] as String,
      discountPercentage: json['discountPercentage'] as int,
      promoCode: json['promoCode'] as String,
    );
  }
}

class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.cuisine,
    required super.floorText,
    required super.rating,
    required super.priceRange,
    required super.imageUrl,
    required super.description,
    required super.phone,
    required super.website,
    required super.isOpen,
    required super.waitTimeText,
    required super.walkTimeText,
    required super.interestedCount,
    super.isFavorite,
    required super.galleryUrls,
    required List<RestaurantReviewModel> super.reviews,
    required List<MenuItemModel> super.menu,
    required List<TableSlotModel> super.slots,
    required List<RestaurantOfferModel> super.offers,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      floorText: json['floorText'] as String,
      rating: (json['rating'] as num).toDouble(),
      priceRange: json['priceRange'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      isOpen: json['isOpen'] as bool,
      waitTimeText: json['waitTimeText'] as String,
      walkTimeText: json['walkTimeText'] as String,
      interestedCount: json['interestedCount'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
      galleryUrls: List<String>.from(json['galleryUrls'] as List),
      reviews: (json['reviews'] as List)
          .map((e) => RestaurantReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      menu: (json['menu'] as List)
          .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      slots: (json['slots'] as List)
          .map((e) => TableSlotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      offers: (json['offers'] as List)
          .map((e) => RestaurantOfferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
