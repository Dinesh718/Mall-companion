import '../../domain/entities/brand_entities.dart';
import '../../domain/repository/brand_repository.dart';
import '../datasource/brand_local_datasource.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandLocalDataSource localDataSource;

  const BrandRepositoryImpl({required this.localDataSource});

  @override
  Future<List<BrandEntity>> getBrands() async {
    return await localDataSource.getBrands();
  }

  @override
  Future<BrandEntity> getBrandDetails(String id) async {
    return await localDataSource.getBrandDetails(id);
  }

  @override
  Future<List<BrandProductEntity>> getBrandProducts(String brandId) async {
    return await localDataSource.getBrandProducts(brandId);
  }

  @override
  Future<List<BrandStoreEntity>> getBrandStores(String brandId) async {
    return await localDataSource.getBrandStores(brandId);
  }

  @override
  Future<List<BrandCollectionEntity>> getBrandCollections(
    String brandId,
  ) async {
    return await localDataSource.getBrandCollections(brandId);
  }

  @override
  Future<List<BrandReviewEntity>> getBrandReviews(String brandId) async {
    return await localDataSource.getBrandReviews(brandId);
  }

  @override
  Future<List<BrandOfferEntity>> getBrandOffers(String brandId) async {
    return await localDataSource.getBrandOffers(brandId);
  }

  @override
  Future<void> toggleBrandFavorite(String brandId) async {
    await localDataSource.toggleBrandFavorite(brandId);
  }

  @override
  Future<void> toggleBrandFollow(String brandId) async {
    await localDataSource.toggleBrandFollow(brandId);
  }
}
