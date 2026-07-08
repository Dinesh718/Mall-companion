import '../entities/brand_entities.dart';
import '../repository/brand_repository.dart';

class GetBrandsUseCase {
  final BrandRepository repository;

  const GetBrandsUseCase(this.repository);

  Future<List<BrandEntity>> execute() async {
    return await repository.getBrands();
  }
}

class GetBrandDetailsUseCase {
  final BrandRepository repository;

  const GetBrandDetailsUseCase(this.repository);

  Future<BrandEntity> execute(String id) async {
    return await repository.getBrandDetails(id);
  }
}

class GetBrandProductsUseCase {
  final BrandRepository repository;

  const GetBrandProductsUseCase(this.repository);

  Future<List<BrandProductEntity>> execute(String brandId) async {
    return await repository.getBrandProducts(brandId);
  }
}

class GetBrandStoresUseCase {
  final BrandRepository repository;

  const GetBrandStoresUseCase(this.repository);

  Future<List<BrandStoreEntity>> execute(String brandId) async {
    return await repository.getBrandStores(brandId);
  }
}

class GetBrandCollectionsUseCase {
  final BrandRepository repository;

  const GetBrandCollectionsUseCase(this.repository);

  Future<List<BrandCollectionEntity>> execute(String brandId) async {
    return await repository.getBrandCollections(brandId);
  }
}

class GetBrandReviewsUseCase {
  final BrandRepository repository;

  const GetBrandReviewsUseCase(this.repository);

  Future<List<BrandReviewEntity>> execute(String brandId) async {
    return await repository.getBrandReviews(brandId);
  }
}

class GetBrandOffersUseCase {
  final BrandRepository repository;

  const GetBrandOffersUseCase(this.repository);

  Future<List<BrandOfferEntity>> execute(String brandId) async {
    return await repository.getBrandOffers(brandId);
  }
}

class ToggleBrandFavoriteUseCase {
  final BrandRepository repository;

  const ToggleBrandFavoriteUseCase(this.repository);

  Future<void> execute(String brandId) async {
    await repository.toggleBrandFavorite(brandId);
  }
}

class ToggleBrandFollowUseCase {
  final BrandRepository repository;

  const ToggleBrandFollowUseCase(this.repository);

  Future<void> execute(String brandId) async {
    await repository.toggleBrandFollow(brandId);
  }
}
