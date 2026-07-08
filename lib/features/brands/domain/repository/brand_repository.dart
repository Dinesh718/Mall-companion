import '../entities/brand_entities.dart';

abstract class BrandRepository {
  Future<List<BrandEntity>> getBrands();
  Future<BrandEntity> getBrandDetails(String id);
  Future<List<BrandProductEntity>> getBrandProducts(String brandId);
  Future<List<BrandStoreEntity>> getBrandStores(String brandId);
  Future<List<BrandCollectionEntity>> getBrandCollections(String brandId);
  Future<List<BrandReviewEntity>> getBrandReviews(String brandId);
  Future<List<BrandOfferEntity>> getBrandOffers(String brandId);
  Future<void> toggleBrandFavorite(String brandId);
  Future<void> toggleBrandFollow(String brandId);
}
