import '../../domain/entities/category_entities.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  final String searchQuery;
  final String selectedFilter; // e.g. "Trending Now", "Fashion", etc.

  const CategoryLoaded({
    required this.categories,
    this.searchQuery = '',
    this.selectedFilter = 'Trending Now',
  });

  CategoryLoaded copyWith({
    List<CategoryEntity>? categories,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class CategoryDetailsLoaded extends CategoryState {
  final CategoryDetailsEntity categoryDetails;
  final String activeFilter; // "all", "stores", "brands", "products", "offers"
  final String searchQuery;

  const CategoryDetailsLoaded({
    required this.categoryDetails,
    this.activeFilter = 'all',
    this.searchQuery = '',
  });

  CategoryDetailsLoaded copyWith({
    CategoryDetailsEntity? categoryDetails,
    String? activeFilter,
    String? searchQuery,
  }) {
    return CategoryDetailsLoaded(
      categoryDetails: categoryDetails ?? this.categoryDetails,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CategoryError extends CategoryState {
  final String errorMessage;

  const CategoryError({required this.errorMessage});
}
