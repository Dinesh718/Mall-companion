import '../../domain/entities/product_entities.dart';

class ProductOfferModel extends ProductOfferEntity {
  const ProductOfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountText,
    required super.tag,
  });
}

class ProductReviewModel extends ProductReviewEntity {
  const ProductReviewModel({
    required super.id,
    required super.userName,
    required super.userAvatarUrl,
    required super.rating,
    required super.comment,
    required super.date,
  });
}

class StoreAvailabilityModel extends StoreAvailabilityEntity {
  const StoreAvailabilityModel({
    required super.storeId,
    required super.storeName,
    required super.logoUrl,
    required super.floorText,
    required super.locationText,
    required super.distanceText,
    required super.timeText,
    required super.openingHours,
    required super.inStock,
  });
}

class SpecificationModel extends SpecificationEntity {
  const SpecificationModel({
    required super.key,
    required super.value,
  });
}

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.brandName,
    required super.category,
    required super.imageUrl,
    required super.price,
    super.originalPrice,
    required super.rating,
    required super.floorText,
    required super.inStock,
    super.isFavorite,
    required super.tag,
    required super.description,
    required super.images,
    required super.specifications,
    required super.reviews,
    required super.storeAvailability,
    required super.availableColors,
    required super.availableSizes,
  });
}
