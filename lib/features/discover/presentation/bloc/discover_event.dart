abstract class DiscoverEvent {
  const DiscoverEvent();
}

class LoadDiscover extends DiscoverEvent {
  const LoadDiscover();
}

class RefreshDiscover extends DiscoverEvent {
  const RefreshDiscover();
}

class SelectCategory extends DiscoverEvent {
  final String categoryId;

  const SelectCategory({required this.categoryId});
}

class SearchChanged extends DiscoverEvent {
  final String searchQuery;

  const SearchChanged({required this.searchQuery});
}
