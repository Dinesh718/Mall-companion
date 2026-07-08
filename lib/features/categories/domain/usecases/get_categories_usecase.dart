import '../entities/category_entities.dart';
import '../repository/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}

class GetCategoryDetails {
  final CategoryRepository repository;

  const GetCategoryDetails(this.repository);

  Future<CategoryDetailsEntity> call(String categoryId) async {
    return await repository.getCategoryDetails(categoryId);
  }
}

class ToggleCategoryProductFavorite {
  final CategoryRepository repository;

  const ToggleCategoryProductFavorite(this.repository);

  Future<void> call(String categoryId, String productId) async {
    await repository.toggleFavoriteProduct(categoryId, productId);
  }
}

class ToggleFavoriteCategory {
  final CategoryRepository repository;

  const ToggleFavoriteCategory(this.repository);

  Future<void> call(String categoryId) async {
    await repository.toggleFavoriteCategory(categoryId);
  }
}
