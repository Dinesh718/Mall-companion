import '../../domain/entities/category_entities.dart';

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    required super.id,
    required super.name,
  });
}

class CategoryBannerModel extends CategoryBannerEntity {
  const CategoryBannerModel({
    required super.imageUrl,
    required super.title,
    required super.subtitle,
    required super.tag,
  });
}

class CategoryOfferModel extends CategoryOfferEntity {
  const CategoryOfferModel({
    required super.id,
    required super.title,
    required super.description,
    required super.discountText,
    required super.tag,
    required super.brandName,
  });
}

class CategoryProductModel extends CategoryProductEntity {
  const CategoryProductModel({
    required super.id,
    required super.name,
    required super.brandName,
    required super.price,
    required super.imageUrl,
    super.isFavorite,
  });
}

class CategoryBrandModel extends CategoryBrandEntity {
  const CategoryBrandModel({
    required super.id,
    required super.name,
    required super.logoUrl,
  });
}

class CategoryStoreModel extends CategoryStoreEntity {
  const CategoryStoreModel({
    required super.id,
    required super.name,
    required super.floorText,
    required super.locationText,
    required super.logoUrl,
    required super.isOpen,
  });
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.title,
    required super.iconName,
    required super.bannerUrl,
    required super.storeCount,
    required super.brandCount,
    required super.productCount,
    super.isTrending,
  });
}

class CategoryDetailsModel extends CategoryDetailsEntity {
  const CategoryDetailsModel({
    required super.category,
    required List<SubCategoryEntity> super.subcategories,
    required List<CategoryBannerEntity> super.banners,
    required List<CategoryStoreEntity> super.stores,
    required List<CategoryBrandEntity> super.brands,
    required List<CategoryProductEntity> super.products,
    required List<CategoryOfferEntity> super.offers,
  });
}
