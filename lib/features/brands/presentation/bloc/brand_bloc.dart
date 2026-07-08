import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/brand_entities.dart';
import '../../domain/usecases/get_brands.dart';
import 'brand_event.dart';
import 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final GetBrandsUseCase getBrandsUseCase;
  final GetBrandDetailsUseCase getBrandDetailsUseCase;
  final GetBrandProductsUseCase getBrandProductsUseCase;
  final GetBrandStoresUseCase getBrandStoresUseCase;
  final GetBrandCollectionsUseCase getBrandCollectionsUseCase;
  final GetBrandReviewsUseCase getBrandReviewsUseCase;
  final GetBrandOffersUseCase getBrandOffersUseCase;
  final ToggleBrandFavoriteUseCase toggleBrandFavoriteUseCase;
  final ToggleBrandFollowUseCase toggleBrandFollowUseCase;

  BrandBloc({
    required this.getBrandsUseCase,
    required this.getBrandDetailsUseCase,
    required this.getBrandProductsUseCase,
    required this.getBrandStoresUseCase,
    required this.getBrandCollectionsUseCase,
    required this.getBrandReviewsUseCase,
    required this.getBrandOffersUseCase,
    required this.toggleBrandFavoriteUseCase,
    required this.toggleBrandFollowUseCase,
  }) : super(const BrandInitial()) {
    on<LoadBrands>(_onLoadBrands);
    on<RefreshBrands>(_onRefreshBrands);
    on<LoadBrandDetails>(_onLoadBrandDetails);
    on<SearchBrands>(_onSearchBrands);
    on<FilterBrandsByFloor>(_onFilterBrandsByFloor);
    on<FilterBrandsByCategory>(_onFilterBrandsByCategory);
    on<ToggleFavorite>(_onToggleFavorite);
    on<ToggleFollow>(_onToggleFollow);
  }

  Future<void> _onLoadBrands(LoadBrands event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());
    try {
      final brands = await getBrandsUseCase.execute();
      emit(BrandsLoaded(
        allBrands: brands,
        filteredBrands: brands,
      ));
    } catch (e) {
      emit(BrandError(message: e.toString()));
    }
  }

  Future<void> _onRefreshBrands(RefreshBrands event, Emitter<BrandState> emit) async {
    try {
      final brands = await getBrandsUseCase.execute();
      if (state is BrandsLoaded) {
        final current = state as BrandsLoaded;
        emit(current.copyWith(allBrands: brands, filteredBrands: _applyFilters(
          brands,
          current.selectedFloor,
          current.selectedCategory,
          current.searchQuery,
        )));
      } else {
        emit(BrandsLoaded(allBrands: brands, filteredBrands: brands));
      }
    } catch (e) {
      emit(BrandError(message: e.toString()));
    }
  }

  Future<void> _onLoadBrandDetails(LoadBrandDetails event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());
    try {
      final brand = await getBrandDetailsUseCase.execute(event.brandId);
      final products = await getBrandProductsUseCase.execute(event.brandId);
      final stores = await getBrandStoresUseCase.execute(event.brandId);
      final collections = await getBrandCollectionsUseCase.execute(event.brandId);
      final reviews = await getBrandReviewsUseCase.execute(event.brandId);
      final offers = await getBrandOffersUseCase.execute(event.brandId);

      emit(BrandDetailsLoaded(
        brand: brand,
        products: products,
        stores: stores,
        collections: collections,
        reviews: reviews,
        offers: offers,
      ));
    } catch (e) {
      emit(BrandError(message: e.toString()));
    }
  }

  void _onSearchBrands(SearchBrands event, Emitter<BrandState> emit) {
    if (state is BrandsLoaded) {
      final current = state as BrandsLoaded;
      final filtered = _applyFilters(
        current.allBrands,
        current.selectedFloor,
        current.selectedCategory,
        event.query,
      );
      emit(current.copyWith(
        searchQuery: event.query,
        filteredBrands: filtered,
      ));
    }
  }

  void _onFilterBrandsByFloor(FilterBrandsByFloor event, Emitter<BrandState> emit) {
    if (state is BrandsLoaded) {
      final current = state as BrandsLoaded;
      final filtered = _applyFilters(
        current.allBrands,
        event.floor,
        current.selectedCategory,
        current.searchQuery,
      );
      emit(current.copyWith(
        selectedFloor: event.floor,
        filteredBrands: filtered,
      ));
    }
  }

  void _onFilterBrandsByCategory(FilterBrandsByCategory event, Emitter<BrandState> emit) {
    if (state is BrandsLoaded) {
      final current = state as BrandsLoaded;
      final filtered = _applyFilters(
        current.allBrands,
        current.selectedFloor,
        event.category,
        current.searchQuery,
      );
      emit(current.copyWith(
        selectedCategory: event.category,
        filteredBrands: filtered,
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<BrandState> emit) async {
    try {
      await toggleBrandFavoriteUseCase.execute(event.brandId);
      if (event.isDetailsPage && state is BrandDetailsLoaded) {
        final current = state as BrandDetailsLoaded;
        emit(current.copyWith(
          brand: current.brand.copyWith(isFavorite: !current.brand.isFavorite),
        ));
      } else if (state is BrandsLoaded) {
        final current = state as BrandsLoaded;
        final updatedAll = current.allBrands.map((b) {
          if (b.id == event.brandId) {
            return b.copyWith(isFavorite: !b.isFavorite);
          }
          return b;
        }).toList();
        final updatedFiltered = current.filteredBrands.map((b) {
          if (b.id == event.brandId) {
            return b.copyWith(isFavorite: !b.isFavorite);
          }
          return b;
        }).toList();
        emit(current.copyWith(
          allBrands: updatedAll,
          filteredBrands: updatedFiltered,
        ));
      }
    } catch (_) {}
  }

  Future<void> _onToggleFollow(ToggleFollow event, Emitter<BrandState> emit) async {
    try {
      await toggleBrandFollowUseCase.execute(event.brandId);
      if (state is BrandDetailsLoaded) {
        final current = state as BrandDetailsLoaded;
        emit(current.copyWith(
          brand: current.brand.copyWith(isFollowed: !current.brand.isFollowed),
        ));
      }
    } catch (_) {}
  }

  List<BrandEntity> _applyFilters(
    List<BrandEntity> brands,
    String floor,
    String category,
    String query,
  ) {
    return brands.where((brand) {
      final matchesFloor = floor == 'All Floors' || brand.floor.toLowerCase().contains(floor.toLowerCase());
      final matchesCategory = category == 'All Categories' || brand.category.toLowerCase() == category.toLowerCase();
      final matchesSearch = query.isEmpty ||
          brand.name.toLowerCase().contains(query.toLowerCase()) ||
          brand.tagline.toLowerCase().contains(query.toLowerCase()) ||
          brand.category.toLowerCase().contains(query.toLowerCase());
      return matchesFloor && matchesCategory && matchesSearch;
    }).toList();
  }
}
