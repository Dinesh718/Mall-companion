import '../../domain/entities/category_entities.dart';
import '../models/category_models.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryDetailsEntity> getCategoryDetails(String categoryId);
  Future<void> toggleFavoriteProduct(String categoryId, String productId);
  Future<void> toggleFavoriteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  // Static state to persist product favorites across views
  static final Map<String, bool> _productFavoritesState = {
    'sneakers_1': true,
    'bag_1': false,
  };

  // Static state to persist category favorites
  static final Map<String, bool> _categoryFavoritesState = {
    'fashion': false,
    'electronics': false,
  };

  static const List<CategoryEntity> _categories = [
    CategoryModel(
      id: 'fashion',
      title: 'Fashion',
      iconName: 'apparel',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD5DeUdG7REjIhbpaycdefKrk_4ZtZEbqRFByokdeQnIKUBQZ9aLCzer6AUw8ECPEth8S5h2vaGlr8JTS_bUD_R4wSu_Gah0loTJ2nSq_dHZtI_10XXrD2jZdgMnuusqG5NeYAoh4HURcLU-ySKc2SZabNM_uelz6vQ_8YQeeSVLXXFl072sJGXUrPZwr5bvn_aWYTv6AgjCfDvqRWAhyEYxcxmy10ETJQ39X03e8z4gg1URPH1dBYtdZrm6rCycglDZOtjrURxbA',
      storeCount: 25,
      brandCount: 15,
      productCount: 120,
      isTrending: true,
    ),
    CategoryModel(
      id: 'electronics',
      title: 'Electronics',
      iconName: 'devices',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBcsSzWSEXn3ilmH3kzfUN0_5zNGzvStUev9BbYWlgb4BzZ7PxW9XNoTp4N0n_fqKFKFsy59kWTGdJGW2b8F12nEj7-KX15R_M4OJR4qPjN4aGFSurhsrHsrLsiLNobiyJ5vjElktNzNiJ4URVXrVEnaaamTfWDRZ2b1cFf0XNXXTrOEYyPj5tmMnC-xLjrFI9nxNv7UMfPTsSQGEifjGlyCeF314_v3nsOlceEsN1udMpOoDntRecHiJHMiFtn9mbE854-9rbO-g',
      storeCount: 18,
      brandCount: 8,
      productCount: 95,
    ),
    CategoryModel(
      id: 'footwear',
      title: 'Footwear',
      iconName: 'steps',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDitIi7FQPm_TNS52uZLPAhx7idfX3rQDnRmZ5Bw6JHBVyALdfX7q73SjUaIb1bmxWtiviq2YUtj4rtT_SdidDi9YhgKUIfo8QlwBDib1NbJo-UgAfAW6joDsx_rFd1ZGyrneb2Md07ODGfliHoshlnL752ZpbaY0HysoPo5YY8qKse5UOv3wfkP4RT7mIjVHXR2DUO8rbPMleWyXoLu2Mn-UqQDLHE4pLQNKAZjrOsDwu3_-TGh4o3VSn5XIBI-yk9lhTMqh4bUA',
      storeCount: 12,
      brandCount: 10,
      productCount: 84,
    ),
    CategoryModel(
      id: 'beauty',
      title: 'Beauty',
      iconName: 'face_retouching_natural',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAaUjBw5VPftJFAUmTcmIYVRBxlqvIK7a2LfVPWDPNtToWNBA5W1ix1GucpC_Du3StCbXcqKK1AbFM0NCzjROnOeV9AkR_8DjOpAczFyxIbiQJctDvNzcAWV2DpE7A9BXHbYg4cvnttO-DYdlaSl8yckXlggH7fgaIKVs-sdj4jMfYauGosjJ_t87z7XIH0gliNoU30R26XuslgR0v0AW45fTcrbwh8ibKKbMBc4m_eXC-d-fZyTJspkHeVWM7H5hreS56AtBO7WA',
      storeCount: 15,
      brandCount: 12,
      productCount: 110,
    ),
    CategoryModel(
      id: 'sports',
      title: 'Sports',
      iconName: 'fitness_center',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB-VxmK3BbmXT-n4Iqf4_ii6jXoaYdBF_a56hR5IMY5c7DbWfti6aM_fmpUZmScBNyZ_ZKdXPSc3EonQgOJAY-Bvndm0nlOUc9MjO03OzmRItIUdg-BrtZzBBdXyNjBECinESrm3KbVwd_jIXc6brzlkQvGmWzJ4WatoHavaBlSBsUrIBJzf_ETeE-xq3S5899DsBjzu8TWUc3C2EM1fkJn9H8BdkJyQqllYrcRnRRkz-_GHOAOBIHl6AMBmuubuehVzXjW8HLuxQ',
      storeCount: 10,
      brandCount: 6,
      productCount: 50,
    ),
    CategoryModel(
      id: 'jewellery',
      title: 'Jewellery',
      iconName: 'diamond',
      bannerUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDaKWzVgmC_PwR2Ux6lY9rmklz_yyYRxR8DZyWhydokjaC7jTRn8dwCf2ogRLsiNd7ako2vVXz75LRn136Bn2FKT71Fkoq4jJH2lR3AAz8LGzI2MRzAq5IZV9KgV0C2aa1zDbXpmuBIVfZ2UqfFyiipr4_JHO37kzjRvUypWlnPLpRcrf8oavaGswD-6tSKpDR7Ashbj-pU8LJiDOg8yftmRKMz3dV0o9RoTJ4-yLf0sEbiiX2oct91tFD_jF29baNI4o41Ll5QGw',
      storeCount: 8,
      brandCount: 5,
      productCount: 40,
    ),
  ];

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }

  @override
  Future<CategoryDetailsEntity> getCategoryDetails(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final cat = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel(
        id: categoryId,
        title: categoryId[0].toUpperCase() + categoryId.substring(1),
        iconName: 'category',
        bannerUrl: '',
        storeCount: 5,
        brandCount: 3,
        productCount: 12,
      ),
    );

    return CategoryDetailsModel(
      category: cat,
      subcategories: const [
        SubCategoryModel(id: 'all', name: 'All'),
        SubCategoryModel(id: 'stores', name: 'Stores'),
        SubCategoryModel(id: 'brands', name: 'Brands'),
        SubCategoryModel(id: 'products', name: 'Products'),
        SubCategoryModel(id: 'offers', name: 'Offers'),
      ],
      banners: const [
        CategoryBannerModel(
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCl1W5ei6MtSe7AcB9Wvzv7pU3NfR1Elx8m7kvEuR0vg-pGJuQ8RQrDOGqzV5eerzI_-vjsmDO3VWQoRsnTJOpN6NgWpMmOWV97AMv0KOjudlnSqmFETSnj1vgf0chkR5Uqm69w5y9XH-KqvZd7hh_bnuCzWlv6aZdodEJs-su2G1XArOtTwPdcLVve8OaEuVYdjWklK8dKO0wkYuhjo396JfYO7ymhUZKCMk5tD_pBS2X9XubcxMZTFMBmdKlHqegAB-ASai4pMQ',
          title: 'Luxe Fashion Week',
          subtitle: 'Discover new arrivals from premium labels',
          tag: 'Limited Edition',
        ),
      ],
      stores: const [
        CategoryStoreModel(
          id: 'saint_laurent',
          name: 'Saint Laurent',
          floorText: 'Floor 1, Wing A',
          locationText: 'Level 1, Shop 102',
          logoUrl: 'SAINT LAURENT',
          isOpen: true,
        ),
        CategoryStoreModel(
          id: 'zara',
          name: 'Zara',
          floorText: 'Ground Floor',
          locationText: 'Ground Level, Shop 12',
          logoUrl: 'ZARA',
          isOpen: true,
        ),
        CategoryStoreModel(
          id: 'nike',
          name: 'Nike',
          floorText: 'Floor 2, Central',
          locationText: 'Level 2, Shop 205',
          logoUrl: 'NIKE',
          isOpen: true,
        ),
      ],
      brands: const [
        CategoryBrandModel(id: 'adidas', name: 'Adidas', logoUrl: 'shield'),
        CategoryBrandModel(id: 'levis', name: 'Levi\'s', logoUrl: 'LVC'),
        CategoryBrandModel(id: 'dior', name: 'Dior', logoUrl: 'diamond'),
        CategoryBrandModel(id: 'prada', name: 'Prada', logoUrl: 'apparel'),
        CategoryBrandModel(
          id: 'nike_brand',
          name: 'Nike',
          logoUrl: 'check_circle',
        ),
      ],
      products: [
        CategoryProductModel(
          id: 'sneakers_1',
          name: 'White Leather Sneakers',
          brandName: 'Saint Laurent',
          price: 850.0,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCzXEUiRhs6rX2YxDb1ZY-7vVK9QHqjIm-WH6VQd8M6boI7KZ1uErQOk-JMrXeYucvgHdeDSSm0tBjFo5ab11LRGspL0EYsn_1p1xheLrFYKjYB69CO2wqQmayix-bdfdNZ4JCysbEEIxKC3jn6aR-I2_S9tG2l_eo1hPU7HZQ8Z7RwAqmcq4kGCotA9VBmbkI7KUhj368YeXKrcDnkFAqxxVmFmTrgOihNaweHFTLLt36DcVVezhjYCUnITtaVytrPJh8cgJ-xMA',
          isFavorite: _productFavoritesState['sneakers_1'] ?? false,
        ),
        CategoryProductModel(
          id: 'bag_1',
          name: 'Quilted Gold Chain Bag',
          brandName: 'Zara Premium',
          price: 129.0,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuARKKPxu4FtJMOBH0HgLlwp7Q3XUI0yVnu3vXfgy-5-7oEd1RH1ako0uxpou_FV2GMGgv8T7N_u8MglwDdbzQElQXNCRQAJ650WrdWQ7BTB7qZldc0DIJIMMQ5pI14-I1oyn2RZk5DEYrz8ICLInAi1mGSX4wujUpD9c01PquN9c-kyvkk2a2bTvsceCLPL9s7e9kA79rteYiNzMHhF-aDYIozyKCdIl96pf8dXf1Q_RCi2UvFxKWZ64bk9MIKl--cw1cS10AQjPw',
          isFavorite: _productFavoritesState['bag_1'] ?? false,
        ),
      ],
      offers: const [
        CategoryOfferModel(
          id: 'offer_1',
          title: 'Flat 50% OFF',
          description: 'Summer Collection',
          discountText: 'Flat 50%',
          tag: 'H&M Special',
          brandName: 'H&M',
        ),
        CategoryOfferModel(
          id: 'offer_2',
          title: 'Buy 2 Get 1',
          description: 'Basic Tees & Denim',
          discountText: '3 for 2',
          tag: 'Uniqlo',
          brandName: 'Uniqlo',
        ),
      ],
    );
  }

  @override
  Future<void> toggleFavoriteProduct(
    String categoryId,
    String productId,
  ) async {
    final current = _productFavoritesState[productId] ?? false;
    _productFavoritesState[productId] = !current;
  }

  @override
  Future<void> toggleFavoriteCategory(String id) async {
    final current = _categoryFavoritesState[id] ?? false;
    _categoryFavoritesState[id] = !current;
  }
}
