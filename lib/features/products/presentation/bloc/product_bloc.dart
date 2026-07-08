import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsData getProductsData;
  final ToggleProductWishlistUseCase toggleProductWishlistUseCase;

  ProductBloc({
    required this.getProductsData,
    required this.toggleProductWishlistUseCase,
  }) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<LoadProductDetails>(_onLoadProductDetails);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsCategory>(_onFilterProductsCategory);
    on<FilterProductsFloor>(_onFilterProductsFloor);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsData.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final products = await getProductsData.getProducts();
      if (state is ProductLoaded) {
        final current = state as ProductLoaded;
        emit(current.copyWith(products: products));
      } else {
        emit(ProductLoaded(products: products));
      }
    } catch (e) {
      emit(ProductError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await getProductsData.getProducts();
      final product = products.firstWhere((p) => p.id == event.productId);

      // Filter recommended products in the same category
      final recommended = products
          .where(
            (p) => p.id != event.productId && p.category == product.category,
          )
          .toList();
      emit(
        ProductDetailsLoaded(
          product: product,
          recommendedProducts: recommended.isNotEmpty
              ? recommended
              : products.where((p) => p.id != event.productId).toList(),
        ),
      );
    } catch (e) {
      emit(ProductError(errorMessage: e.toString()));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }

  void _onFilterProductsCategory(
    FilterProductsCategory event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(current.copyWith(selectedCategory: event.category));
    }
  }

  void _onFilterProductsFloor(
    FilterProductsFloor event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(current.copyWith(selectedFloor: event.floor));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlist event,
    Emitter<ProductState> emit,
  ) async {
    try {
      await toggleProductWishlistUseCase(event.productId);
      final products = await getProductsData.getProducts();

      if (state is ProductLoaded) {
        final current = state as ProductLoaded;
        emit(current.copyWith(products: products));
      } else if (state is ProductDetailsLoaded) {
        final current = state as ProductDetailsLoaded;
        final updatedProduct = products.firstWhere(
          (p) => p.id == current.product.id,
        );
        emit(
          current.copyWith(
            product: updatedProduct,
            recommendedProducts: current.recommendedProducts,
          ),
        );
      }
    } catch (e) {
      emit(ProductError(errorMessage: e.toString()));
    }
  }
}
