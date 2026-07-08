abstract class StoreEvent {
  const StoreEvent();
}

class LoadStores extends StoreEvent {
  const LoadStores();
}

class RefreshStores extends StoreEvent {
  const RefreshStores();
}

class LoadStoreDetails extends StoreEvent {
  final String storeId;
  const LoadStoreDetails({required this.storeId});
}

class SearchStores extends StoreEvent {
  final String query;
  const SearchStores({required this.query});
}

class FilterStoresCategory extends StoreEvent {
  final String category;
  const FilterStoresCategory({required this.category});
}

class FilterStoresFloor extends StoreEvent {
  final String floor;
  const FilterStoresFloor({required this.floor});
}

class FavoriteStore extends StoreEvent {
  final String storeId;
  const FavoriteStore({required this.storeId});
}
