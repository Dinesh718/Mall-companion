import '../../domain/entities/product_entities.dart';
import '../../domain/repository/product_repository.dart';
import '../datasource/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ProductEntity>> getProducts() async {
    return await localDataSource.getProducts();
  }

  @override
  Future<void> toggleProductWishlist(String id) async {
    await localDataSource.toggleProductWishlist(id);
  }
}
