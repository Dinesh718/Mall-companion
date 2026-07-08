import '../../domain/entities/brand_entities.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.name,
    required super.category,
    required super.tagline,
    required super.description,
    required super.floor,
    required super.totalStores,
    required super.logoUrl,
    required super.bannerUrl,
    required super.rating,
    required super.isFavorite,
    required super.isFollowed,
    required super.websiteUrl,
    required super.foundedYear,
    required super.originCountry,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      tagline: json['tagline'] as String,
      description: json['description'] as String,
      floor: json['floor'] as String,
      totalStores: json['totalStores'] as int,
      logoUrl: json['logoUrl'] as String,
      bannerUrl: json['bannerUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isFollowed: json['isFollowed'] as bool? ?? false,
      websiteUrl: json['websiteUrl'] as String? ?? '',
      foundedYear: json['foundedYear'] as String? ?? '',
      originCountry: json['originCountry'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tagline': tagline,
      'description': description,
      'floor': floor,
      'totalStores': totalStores,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'rating': rating,
      'isFavorite': isFavorite,
      'isFollowed': isFollowed,
      'websiteUrl': websiteUrl,
      'foundedYear': foundedYear,
      'originCountry': originCountry,
    };
  }
}

class BrandStoryModel extends BrandStoryEntity {
  const BrandStoryModel({
    required super.description,
    required super.foundedYear,
    required super.country,
  });

  factory BrandStoryModel.fromJson(Map<String, dynamic> json) {
    return BrandStoryModel(
      description: json['description'] as String,
      foundedYear: json['foundedYear'] as String,
      country: json['country'] as String,
    );
  }
}

class BrandOfferModel extends BrandOfferEntity {
  const BrandOfferModel({
    required super.promoTag,
    required super.details,
    required super.discountPercent,
  });

  factory BrandOfferModel.fromJson(Map<String, dynamic> json) {
    return BrandOfferModel(
      promoTag: json['promoTag'] as String,
      details: json['details'] as String,
      discountPercent: (json['discountPercent'] as num).toDouble(),
    );
  }
}

class BrandCollectionModel extends BrandCollectionEntity {
  const BrandCollectionModel({
    required super.name,
    required super.categoryTag,
    required super.imageUrl,
  });

  factory BrandCollectionModel.fromJson(Map<String, dynamic> json) {
    return BrandCollectionModel(
      name: json['name'] as String,
      categoryTag: json['categoryTag'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class BrandProductModel extends BrandProductEntity {
  const BrandProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.levelText,
  });

  factory BrandProductModel.fromJson(Map<String, dynamic> json) {
    return BrandProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      levelText: json['levelText'] as String,
    );
  }
}

class BrandStoreModel extends BrandStoreEntity {
  const BrandStoreModel({
    required super.name,
    required super.levelText,
    required super.openHours,
    required super.statusText,
    required super.descriptionText,
  });

  factory BrandStoreModel.fromJson(Map<String, dynamic> json) {
    return BrandStoreModel(
      name: json['name'] as String,
      levelText: json['levelText'] as String,
      openHours: json['openHours'] as String,
      statusText: json['statusText'] as String,
      descriptionText: json['descriptionText'] as String,
    );
  }
}

class BrandReviewModel extends BrandReviewEntity {
  const BrandReviewModel({
    required super.name,
    required super.rating,
    required super.reviewText,
  });

  factory BrandReviewModel.fromJson(Map<String, dynamic> json) {
    return BrandReviewModel(
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewText: json['reviewText'] as String,
    );
  }
}
