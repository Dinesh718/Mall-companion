abstract class CategoryEvent {
  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class RefreshCategories extends CategoryEvent {
  const RefreshCategories();
}

class LoadCategoryDetails extends CategoryEvent {
  final String categoryId;
  const LoadCategoryDetails({required this.categoryId});
}

class SearchCategoriesQuery extends CategoryEvent {
  final String query;
  const SearchCategoriesQuery({required this.query});
}

class FilterCategoryDetails extends CategoryEvent {
  final String filter; // e.g. "all", "stores", "brands", "products", "offers"
  const FilterCategoryDetails({required this.filter});
}

class FavoriteCategory extends CategoryEvent {
  final String categoryId;
  const FavoriteCategory({required this.categoryId});
}

class FavoriteCategoryProduct extends CategoryEvent {
  final String categoryId;
  final String productId;
  const FavoriteCategoryProduct({required this.categoryId, required this.productId});
}
