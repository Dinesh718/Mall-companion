import '../entities/category_entities.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryDetailsEntity> getCategoryDetails(String categoryId);
  Future<void> toggleFavoriteProduct(String categoryId, String productId);
  Future<void> toggleFavoriteCategory(String id);
}
