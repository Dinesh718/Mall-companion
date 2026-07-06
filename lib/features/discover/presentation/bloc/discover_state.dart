import '../../domain/entities/discover_entities.dart';

abstract class DiscoverState {
  const DiscoverState();
}

class DiscoverInitial extends DiscoverState {
  const DiscoverInitial();
}

class DiscoverLoading extends DiscoverState {
  const DiscoverLoading();
}

class DiscoverLoaded extends DiscoverState {
  final DiscoverDataEntity discoverData;
  final String selectedCategoryId;
  final String searchQuery;

  const DiscoverLoaded({
    required this.discoverData,
    this.selectedCategoryId = '',
    this.searchQuery = '',
  });

  DiscoverLoaded copyWith({
    DiscoverDataEntity? discoverData,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return DiscoverLoaded(
      discoverData: discoverData ?? this.discoverData,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DiscoverError extends DiscoverState {
  final String errorMessage;

  const DiscoverError({required this.errorMessage});
}
