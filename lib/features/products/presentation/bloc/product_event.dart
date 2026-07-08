abstract class ProductEvent {
  const ProductEvent();
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class LoadProductDetails extends ProductEvent {
  final String productId;
  const LoadProductDetails({required this.productId});
}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts({required this.query});
}

class FilterProductsCategory extends ProductEvent {
  final String category;
  const FilterProductsCategory({required this.category});
}

class FilterProductsFloor extends ProductEvent {
  final String floor;
  const FilterProductsFloor({required this.floor});
}

class ToggleWishlist extends ProductEvent {
  final String productId;
  const ToggleWishlist({required this.productId});
}

class ShareProduct extends ProductEvent {
  final String productId;
  const ShareProduct({required this.productId});
}
