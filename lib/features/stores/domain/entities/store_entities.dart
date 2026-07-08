class StoreOfferEntity {
  final String id;
  final String title;
  final String description;
  final String discountText;
  final String tag;

  const StoreOfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.tag,
  });
}

class BrandEntity {
  final String id;
  final String name;
  final String logoUrl;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
  });
}

class ProductEntity {
  final String id;
  final String name;
  final String category;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
  });
}

class StoreServiceEntity {
  final String id;
  final String name;
  final String iconName; // e.g. "checkroom"

  const StoreServiceEntity({
    required this.id,
    required this.name,
    required this.iconName,
  });
}

class StoreLocationEntity {
  final String mapImageUrl;
  final String distanceWalkText;
  final String floorText;

  const StoreLocationEntity({
    required this.mapImageUrl,
    required this.distanceWalkText,
    required this.floorText,
  });
}

class StoreReviewEntity {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String comment;
  final String date;

  const StoreReviewEntity({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class StoreEntity {
  final String id;
  final String name;
  final String category;
  final String logoUrl;
  final String bannerUrl;
  final String floorText;
  final String locationText; // e.g. "Level 2, South Wing"
  final String storeNumber; // e.g. "#242"
  final String distanceWalkText;
  final double rating;
  final bool isOpen;
  final String openingHours; // e.g. "10:00 AM - 10:00 PM"
  final String description;
  final String phone;
  final String website;
  final List<String> socialMedia;
  final bool isBookmarked;
  final List<StoreOfferEntity> offers;
  final List<BrandEntity> brands;
  final List<ProductEntity> products;
  final List<String> gallery;
  final List<StoreServiceEntity> services;
  final StoreLocationEntity location;
  final List<StoreReviewEntity> reviews;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.bannerUrl,
    required this.floorText,
    required this.locationText,
    required this.storeNumber,
    required this.distanceWalkText,
    required this.rating,
    required this.isOpen,
    required this.openingHours,
    required this.description,
    required this.phone,
    required this.website,
    required this.socialMedia,
    this.isBookmarked = false,
    required this.offers,
    required this.brands,
    required this.products,
    required this.gallery,
    required this.services,
    required this.location,
    required this.reviews,
  });

  StoreEntity copyWith({bool? isBookmarked}) {
    return StoreEntity(
      id: id,
      name: name,
      category: category,
      logoUrl: logoUrl,
      bannerUrl: bannerUrl,
      floorText: floorText,
      locationText: locationText,
      storeNumber: storeNumber,
      distanceWalkText: distanceWalkText,
      rating: rating,
      isOpen: isOpen,
      openingHours: openingHours,
      description: description,
      phone: phone,
      website: website,
      socialMedia: socialMedia,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      offers: offers,
      brands: brands,
      products: products,
      gallery: gallery,
      services: services,
      location: location,
      reviews: reviews,
    );
  }
}
