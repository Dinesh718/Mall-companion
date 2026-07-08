import 'package:flutter/foundation.dart';
import '../../domain/entities/brand_entities.dart';

@immutable
abstract class BrandState {
  const BrandState();
}

class BrandInitial extends BrandState {
  const BrandInitial();
}

class BrandLoading extends BrandState {
  const BrandLoading();
}

class BrandsLoaded extends BrandState {
  final List<BrandEntity> allBrands;
  final List<BrandEntity> filteredBrands;
  final String selectedFloor;
  final String selectedCategory;
  final String searchQuery;

  const BrandsLoaded({
    required this.allBrands,
    required this.filteredBrands,
    this.selectedFloor = 'All Floors',
    this.selectedCategory = 'All Categories',
    this.searchQuery = '',
  });

  BrandsLoaded copyWith({
    List<BrandEntity>? allBrands,
    List<BrandEntity>? filteredBrands,
    String? selectedFloor,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return BrandsLoaded(
      allBrands: allBrands ?? this.allBrands,
      filteredBrands: filteredBrands ?? this.filteredBrands,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class BrandDetailsLoaded extends BrandState {
  final BrandEntity brand;
  final List<BrandProductEntity> products;
  final List<BrandStoreEntity> stores;
  final List<BrandCollectionEntity> collections;
  final List<BrandReviewEntity> reviews;
  final List<BrandOfferEntity> offers;

  const BrandDetailsLoaded({
    required this.brand,
    required this.products,
    required this.stores,
    required this.collections,
    required this.reviews,
    required this.offers,
  });

  BrandDetailsLoaded copyWith({
    BrandEntity? brand,
    List<BrandProductEntity>? products,
    List<BrandStoreEntity>? stores,
    List<BrandCollectionEntity>? collections,
    List<BrandReviewEntity>? reviews,
    List<BrandOfferEntity>? offers,
  }) {
    return BrandDetailsLoaded(
      brand: brand ?? this.brand,
      products: products ?? this.products,
      stores: stores ?? this.stores,
      collections: collections ?? this.collections,
      reviews: reviews ?? this.reviews,
      offers: offers ?? this.offers,
    );
  }
}

class BrandError extends BrandState {
  final String message;

  const BrandError({required this.message});
}
