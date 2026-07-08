import '../../domain/entities/category_entities.dart';
import '../../domain/repository/category_repository.dart';
import '../datasource/category_local_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await localDataSource.getCategories();
  }

  @override
  Future<CategoryDetailsEntity> getCategoryDetails(String categoryId) async {
    return await localDataSource.getCategoryDetails(categoryId);
  }

  @override
  Future<void> toggleFavoriteProduct(String categoryId, String productId) async {
    await localDataSource.toggleFavoriteProduct(categoryId, productId);
  }

  @override
  Future<void> toggleFavoriteCategory(String id) async {
    await localDataSource.toggleFavoriteCategory(id);
  }
}
