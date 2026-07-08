class SubCategoryEntity {
  final String id;
  final String name;

  const SubCategoryEntity({required this.id, required this.name});
}

class CategoryBannerEntity {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String tag;

  const CategoryBannerEntity({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}

class CategoryOfferEntity {
  final String id;
  final String title;
  final String description;
  final String discountText;
  final String tag;
  final String brandName;

  const CategoryOfferEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.tag,
    required this.brandName,
  });
}

class CategoryProductEntity {
  final String id;
  final String name;
  final String brandName;
  final double price;
  final String imageUrl;
  final bool isFavorite;

  const CategoryProductEntity({
    required this.id,
    required this.name,
    required this.brandName,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  CategoryProductEntity copyWith({bool? isFavorite}) {
    return CategoryProductEntity(
      id: id,
      name: name,
      brandName: brandName,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CategoryBrandEntity {
  final String id;
  final String name;
  final String logoUrl;

  const CategoryBrandEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
  });
}

class CategoryStoreEntity {
  final String id;
  final String name;
  final String floorText;
  final String locationText;
  final String logoUrl;
  final bool isOpen;

  const CategoryStoreEntity({
    required this.id,
    required this.name,
    required this.floorText,
    required this.locationText,
    required this.logoUrl,
    required this.isOpen,
  });
}

class CategoryEntity {
  final String id;
  final String title;
  final String iconName;
  final String bannerUrl;
  final int storeCount;
  final int brandCount;
  final int productCount;
  final bool isTrending;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.bannerUrl,
    required this.storeCount,
    required this.brandCount,
    required this.productCount,
    this.isTrending = false,
  });
}

class CategoryDetailsEntity {
  final CategoryEntity category;
  final List<SubCategoryEntity> subcategories;
  final List<CategoryBannerEntity> banners;
  final List<CategoryStoreEntity> stores;
  final List<CategoryBrandEntity> brands;
  final List<CategoryProductEntity> products;
  final List<CategoryOfferEntity> offers;

  const CategoryDetailsEntity({
    required this.category,
    required this.subcategories,
    required this.banners,
    required this.stores,
    required this.brands,
    required this.products,
    required this.offers,
  });
}
