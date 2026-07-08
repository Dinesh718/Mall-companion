import '../../domain/entities/product_entities.dart';

abstract class ProductState {
  const ProductState();
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final String searchQuery;
  final String selectedCategory; // e.g. "All Products", "Fashion", "Electronics", etc.
  final String selectedFloor; // e.g. "All Floors", "Ground", "L1", "L2"

  const ProductLoaded({
    required this.products,
    this.searchQuery = '',
    this.selectedCategory = 'All Products',
    this.selectedFloor = 'All Floors',
  });

  ProductLoaded copyWith({
    List<ProductEntity>? products,
    String? searchQuery,
    String? selectedCategory,
    String? selectedFloor,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFloor: selectedFloor ?? this.selectedFloor,
    );
  }
}

class ProductDetailsLoaded extends ProductState {
  final ProductEntity product;
  final List<ProductEntity> recommendedProducts;

  const ProductDetailsLoaded({
    required this.product,
    required this.recommendedProducts,
  });

  ProductDetailsLoaded copyWith({
    ProductEntity? product,
    List<ProductEntity>? recommendedProducts,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      recommendedProducts: recommendedProducts ?? this.recommendedProducts,
    );
  }
}

class ProductError extends ProductState {
  final String errorMessage;
  const ProductError({required this.errorMessage});
}
