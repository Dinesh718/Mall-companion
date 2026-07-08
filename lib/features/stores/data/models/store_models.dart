import '../../domain/entities/store_entities.dart';

class StoreOfferModel extends StoreOfferEntity {
  const StoreOfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountText,
    required super.tag,
  });
}

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.name,
    required super.logoUrl,
  });
}

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.imageUrl,
  });
}

class StoreServiceModel extends StoreServiceEntity {
  const StoreServiceModel({
    required super.id,
    required super.name,
    required super.iconName,
  });
}

class StoreLocationModel extends StoreLocationEntity {
  const StoreLocationModel({
    required super.mapImageUrl,
    required super.distanceWalkText,
    required super.floorText,
  });
}

class StoreReviewModel extends StoreReviewEntity {
  const StoreReviewModel({
    required super.id,
    required super.userName,
    required super.userAvatarUrl,
    required super.rating,
    required super.comment,
    required super.date,
  });
}

class StoreModel extends StoreEntity {
  const StoreModel({
    required super.id,
    required super.name,
    required super.category,
    required super.logoUrl,
    required super.bannerUrl,
    required super.floorText,
    required super.locationText,
    required super.storeNumber,
    required super.distanceWalkText,
    required super.rating,
    required super.isOpen,
    required super.openingHours,
    required super.description,
    required super.phone,
    required super.website,
    required super.socialMedia,
    super.isBookmarked,
    required List<StoreOfferEntity> super.offers,
    required List<BrandEntity> super.brands,
    required List<ProductEntity> super.products,
    required super.gallery,
    required List<StoreServiceEntity> super.services,
    required super.location,
    required List<StoreReviewEntity> super.reviews,
  });
}
