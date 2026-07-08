import '../entities/product_entities.dart';
import '../repository/product_repository.dart';

class GetProductsData {
  final ProductRepository repository;

  GetProductsData(this.repository);

  Future<List<ProductEntity>> getProducts() async {
    return await repository.getProducts();
  }
}

class ToggleProductWishlistUseCase {
  final ProductRepository repository;

  ToggleProductWishlistUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.toggleProductWishlist(id);
  }
}
