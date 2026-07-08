import 'package:flutter/foundation.dart';

@immutable
abstract class BrandEvent {
  const BrandEvent();
}

class LoadBrands extends BrandEvent {
  const LoadBrands();
}

class RefreshBrands extends BrandEvent {
  const RefreshBrands();
}

class LoadBrandDetails extends BrandEvent {
  final String brandId;

  const LoadBrandDetails({required this.brandId});
}

class SearchBrands extends BrandEvent {
  final String query;

  const SearchBrands({required this.query});
}

class FilterBrandsByFloor extends BrandEvent {
  final String floor;

  const FilterBrandsByFloor({required this.floor});
}

class FilterBrandsByCategory extends BrandEvent {
  final String category;

  const FilterBrandsByCategory({required this.category});
}

class ToggleFavorite extends BrandEvent {
  final String brandId;
  final bool isDetailsPage;

  const ToggleFavorite({required this.brandId, this.isDetailsPage = false});
}

class ToggleFollow extends BrandEvent {
  final String brandId;

  const ToggleFollow({required this.brandId});
}
