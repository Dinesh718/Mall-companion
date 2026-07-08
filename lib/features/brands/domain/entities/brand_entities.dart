class BrandEntity {
  final String id;
  final String name;
  final String category;
  final String tagline;
  final String description;
  final String floor;
  final int totalStores;
  final String logoUrl;
  final String bannerUrl;
  final double rating;
  final bool isFavorite;
  final bool isFollowed;
  final String websiteUrl;
  final String foundedYear;
  final String originCountry;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.floor,
    required this.totalStores,
    required this.logoUrl,
    required this.bannerUrl,
    required this.rating,
    required this.isFavorite,
    required this.isFollowed,
    required this.websiteUrl,
    required this.foundedYear,
    required this.originCountry,
  });

  BrandEntity copyWith({
    String? id,
    String? name,
    String? category,
    String? tagline,
    String? description,
    String? floor,
    int? totalStores,
    String? logoUrl,
    String? bannerUrl,
    double? rating,
    bool? isFavorite,
    bool? isFollowed,
    String? websiteUrl,
    String? foundedYear,
    String? originCountry,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      floor: floor ?? this.floor,
      totalStores: totalStores ?? this.totalStores,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      isFollowed: isFollowed ?? this.isFollowed,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      foundedYear: foundedYear ?? this.foundedYear,
      originCountry: originCountry ?? this.originCountry,
    );
  }
}

class BrandStoryEntity {
  final String description;
  final String foundedYear;
  final String country;

  const BrandStoryEntity({
    required this.description,
    required this.foundedYear,
    required this.country,
  });
}

class BrandOfferEntity {
  final String promoTag;
  final String details;
  final double discountPercent;

  const BrandOfferEntity({
    required this.promoTag,
    required this.details,
    required this.discountPercent,
  });
}

class BrandCollectionEntity {
  final String name;
  final String categoryTag;
  final String imageUrl;

  const BrandCollectionEntity({
    required this.name,
    required this.categoryTag,
    required this.imageUrl,
  });
}

class BrandProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String levelText;

  const BrandProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.levelText,
  });
}

class BrandStoreEntity {
  final String name;
  final String levelText;
  final String openHours;
  final String statusText;
  final String descriptionText;

  const BrandStoreEntity({
    required this.name,
    required this.levelText,
    required this.openHours,
    required this.statusText,
    required this.descriptionText,
  });
}

class BrandReviewEntity {
  final String name;
  final double rating;
  final String reviewText;

  const BrandReviewEntity({
    required this.name,
    required this.rating,
    required this.reviewText,
  });
}
