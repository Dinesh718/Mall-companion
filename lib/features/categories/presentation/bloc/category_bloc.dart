import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final GetCategoryDetails getCategoryDetails;
  final ToggleCategoryProductFavorite toggleCategoryProductFavorite;
  final ToggleFavoriteCategory toggleFavoriteCategory;

  CategoryBloc({
    required this.getCategories,
    required this.getCategoryDetails,
    required this.toggleCategoryProductFavorite,
    required this.toggleFavoriteCategory,
  }) : super(const CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<RefreshCategories>(_onRefreshCategories);
    on<LoadCategoryDetails>(_onLoadCategoryDetails);
    on<SearchCategoriesQuery>(_onSearchCategoriesQuery);
    on<FilterCategoryDetails>(_onFilterCategoryDetails);
    on<FavoriteCategory>(_onFavoriteCategory);
    on<FavoriteCategoryProduct>(_onFavoriteCategoryProduct);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final categories = await getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = await getCategories();
      if (state is CategoryLoaded) {
        final current = state as CategoryLoaded;
        emit(current.copyWith(categories: categories));
      } else {
        emit(CategoryLoaded(categories: categories));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadCategoryDetails(
    LoadCategoryDetails event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final details = await getCategoryDetails(event.categoryId);
      emit(CategoryDetailsLoaded(categoryDetails: details));
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  void _onSearchCategoriesQuery(
    SearchCategoriesQuery event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoryLoaded) {
      final current = state as CategoryLoaded;
      emit(current.copyWith(searchQuery: event.query));
    } else if (state is CategoryDetailsLoaded) {
      final current = state as CategoryDetailsLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }

  void _onFilterCategoryDetails(
    FilterCategoryDetails event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoryDetailsLoaded) {
      final current = state as CategoryDetailsLoaded;
      emit(current.copyWith(activeFilter: event.filter));
    } else if (state is CategoryLoaded) {
      final current = state as CategoryLoaded;
      emit(current.copyWith(selectedFilter: event.filter));
    }
  }

  Future<void> _onFavoriteCategory(
    FavoriteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await toggleFavoriteCategory(event.categoryId);
      if (state is CategoryDetailsLoaded) {
        final current = state as CategoryDetailsLoaded;
        final updatedDetails = await getCategoryDetails(event.categoryId);
        emit(current.copyWith(categoryDetails: updatedDetails));
      } else {
        final categories = await getCategories();
        if (state is CategoryLoaded) {
          final current = state as CategoryLoaded;
          emit(current.copyWith(categories: categories));
        }
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }

  Future<void> _onFavoriteCategoryProduct(
    FavoriteCategoryProduct event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      await toggleCategoryProductFavorite(event.categoryId, event.productId);
      if (state is CategoryDetailsLoaded) {
        final current = state as CategoryDetailsLoaded;
        final updatedDetails = await getCategoryDetails(event.categoryId);
        emit(current.copyWith(categoryDetails: updatedDetails));
      }
    } catch (e) {
      emit(CategoryError(errorMessage: e.toString()));
    }
  }
}
