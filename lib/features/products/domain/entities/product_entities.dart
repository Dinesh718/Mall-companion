class ProductOfferEntity {
  final String id;
  final String title;
  final String description;
  final String discountText;
  final String tag;

  const ProductOfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.tag,
  });
}

class ProductReviewEntity {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String comment;
  final String date;

  const ProductReviewEntity({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class StoreAvailabilityEntity {
  final String storeId;
  final String storeName;
  final String logoUrl;
  final String floorText;
  final String locationText; // e.g. "Level 2, North Wing"
  final String distanceText; // e.g. "180m away"
  final String timeText; // e.g. "3 min walk"
  final String openingHours;
  final bool inStock;

  const StoreAvailabilityEntity({
    required this.storeId,
    required this.storeName,
    required this.logoUrl,
    required this.floorText,
    required this.locationText,
    required this.distanceText,
    required this.timeText,
    required this.openingHours,
    required this.inStock,
  });
}

class SpecificationEntity {
  final String key;
  final String value;

  const SpecificationEntity({required this.key, required this.value});
}

class ProductEntity {
  final String id;
  final String name;
  final String brandName;
  final String category;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double rating;
  final String floorText;
  final bool inStock;
  final bool isFavorite;
  final String tag; // e.g. "Limited Edition", "New Arrival"
  final String description;
  final List<String> images;
  final List<SpecificationEntity> specifications;
  final List<ProductReviewEntity> reviews;
  final List<StoreAvailabilityEntity> storeAvailability;
  final List<String> availableColors;
  final List<String> availableSizes;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.brandName,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.floorText,
    required this.inStock,
    this.isFavorite = false,
    required this.tag,
    required this.description,
    required this.images,
    required this.specifications,
    required this.reviews,
    required this.storeAvailability,
    required this.availableColors,
    required this.availableSizes,
  });

  ProductEntity copyWith({bool? isFavorite}) {
    return ProductEntity(
      id: id,
      name: name,
      brandName: brandName,
      category: category,
      imageUrl: imageUrl,
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      floorText: floorText,
      inStock: inStock,
      isFavorite: isFavorite ?? this.isFavorite,
      tag: tag,
      description: description,
      images: images,
      specifications: specifications,
      reviews: reviews,
      storeAvailability: storeAvailability,
      availableColors: availableColors,
      availableSizes: availableSizes,
    );
  }
}
