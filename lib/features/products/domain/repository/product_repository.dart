import '../entities/product_entities.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<void> toggleProductWishlist(String id);
}
