import '../models/brand_models.dart';

abstract class BrandLocalDataSource {
  Future<List<BrandModel>> getBrands();
  Future<BrandModel> getBrandDetails(String id);
  Future<List<BrandProductModel>> getBrandProducts(String brandId);
  Future<List<BrandStoreModel>> getBrandStores(String brandId);
  Future<List<BrandCollectionModel>> getBrandCollections(String brandId);
  Future<List<BrandReviewModel>> getBrandReviews(String brandId);
  Future<List<BrandOfferModel>> getBrandOffers(String brandId);
  Future<void> toggleBrandFavorite(String brandId);
  Future<void> toggleBrandFollow(String brandId);
}

class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  static final List<BrandModel> _brands = [
    const BrandModel(
      id: 'saint_laurent',
      name: 'Saint Laurent',
      category: 'Luxury',
      tagline: 'Haute Couture Parisian Luxury',
      description: 'Founded in 1961, Yves Saint Laurent was the first couture house to introduce the concept of luxury prêt-à-porter. Today, Saint Laurent collections include women’s and men’s ready-to-wear, shoes, handbags, small leather goods, jewelry, scarves, and eyewear.',
      floor: 'First Floor',
      totalStores: 2,
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQlaUjQ6dDn007nI2Auo5XZ8Zmz1FZFWf3jePxwlCo8Sq80MWL4H-I4Igz_Jyrqeyzt00L8j4n4x3oJoeNTcSMBvW1N36GwPcWdwi7Ivg408FsBtMvTr54DjVlCBloZqNA8t7bf69F97P0LPvAg_z4WX4ARkJNCUWagAz6yomKm3tdbMyIOdkcRVigncpsVngDc7zxXzv3Q-1G5n3k96vTEIR9dQGZ63_r0vHjsNDu0J-njYj_qjOcFWiaYoTarq3MlbyAIwlp9g',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAH3PW9qgbH6KI3YaV7tbY13A3Do8Ot4f3oSZpQ1n-luPbaYq8G-qT21I0F6KLem1n6LenpPtLhlJBcB3JLVCDAu7Q5hlbTxJGRtAtjVQfzbZg4eqeVYpz1ht1bXeeUAnC_Jxzd0kmHvNthLy9VVgkca8VRbgEb-_wR2uDuURgqNC7cSm1b_hpJgnPElxQXdKWLshzD_0zMhQK2tfy6mpHN5UxOD0RES8SeAefxC-kczdGKjEs8n6xXhYmYbrRi5P3kOBm6UhaMQw',
      rating: 4.9,
      isFavorite: false,
      isFollowed: false,
      websiteUrl: 'www.ysl.com',
      foundedYear: '1961',
      originCountry: 'Paris, France',
    ),
    const BrandModel(
      id: 'gucci',
      name: 'Gucci Boutique',
      category: 'Luxury',
      tagline: 'Influential, innovative, and progressive Italian luxury.',
      description: 'Gucci is a premium luxury fashion label known for defining eclectic, contemporary and romantic designs reflecting fine Italian craftsmanship.',
      floor: 'Ground Floor',
      totalStores: 2,
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA0mMhIAzPNu3rH46als_KZJ28_X0zG0pxb0WjgPd3CdRtLwo_Yk6lFjcnYP3fIY35C7UybZeonaoAAqPRjaAzyespIeqyk_iAHhLTjWKKBfCZuOcDcF2c1NTOJDuxBWRYn6XyJn2QSpM9RWszj4x_2KreRMrSzzKZObgY9e21TiVJABgqlQIv6pPG3y3Okwx-grOQBVo2uIgEWXNu2M3eR5cOsBBD2X3wc1vlWotc93od5dm7TlkHYP2lq-rxR3RO0X-h2wMzRrQ',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQNH9jXFLPXIpykuZvnN9v2BIgdkF7dS2Y4fbkQ3felzfR_xcgGXvBRJOf_Fw_m2K8XDKAPyExSi9MbPjN48r4noHohzUODdkINGrRIofkTw0hoJdKB51wQPQr-yYb1SxNXby3o8yPi56tVKTVd3wvsbowWjAzPe6j44MmKpz-PvoHtJnJPOxOFjbcKqz77FGG2_Vq1HSZLEz0R_HA0gJp2lQ1p8hM9sMRSfYMCfqypbPT2m9WJ637sLxUn9hrOgLD5mi3CTxEPA',
      rating: 4.8,
      isFavorite: false,
      isFollowed: false,
      websiteUrl: 'www.gucci.com',
      foundedYear: '1921',
      originCountry: 'Florence, Italy',
    ),
    const BrandModel(
      id: 'bose',
      name: 'Bose Sound Experience',
      category: 'Electronics',
      tagline: 'Better sound through research.',
      description: 'Explore state-of-the-art noise-canceling headphones, home theatre soundbars, and wireless earbuds.',
      floor: 'Second Floor',
      totalStores: 1,
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDoiGh9LbryadCKqnuzlPziX9_GAlCl7erdzeY4apIEWqIsUZoUnZe-alDWrORNn3UCBrA4tDb83LOnwoy0ZHnG_X8pZItMMQwxmZi5sV_PPdY_menpLjtOz_svJcndWIixWLaTmnTaiZjL-Qp8uj7NQuTdOQNr7BnPCJQsThfRVq2mAYz0XmUdYQFRHXgPSbJNk7LtEcFpBwHb-E33m2Xo-zrHV85QKVFs37qZ6yAZSzl88tm-6OkSvTVqgjrIGv0FIE9zmDM7lw',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCs9T0Okot87nWpOKeBQdFRo02rZd41GeTKUXIUhkaHtQqfM7YsCE3uRsbup7ZwaRKs7oc6NeoYQiepKiaaT4FMALOlTZCPumLp-Vpeu54BDtESdZleHLj5uvsQzMv2gnvDP3waw4UQ-SHazJD6n7nBy4kWWrG1cEWo4dQ6mddavBtI_-62Kp8nKYUIkVOKLHyJ3mwPSWP3WFOnUa3u16zcY3uNdHQLS3Oqw4BG7MaHLrJSF2BfXKcKlWmYR-gY2FxWR3YqjAJ6ug',
      rating: 4.7,
      isFavorite: false,
      isFollowed: false,
      websiteUrl: 'www.bose.com',
      foundedYear: '1964',
      originCountry: 'Massachusetts, USA',
    ),
    const BrandModel(
      id: 'sephora',
      name: 'Sephora Beauty',
      category: 'Beauty',
      tagline: 'Let\'s beauty together.',
      description: 'Discover the best in cosmetics, skincare, body care, and fragrance brands from global icons.',
      floor: 'First Floor',
      totalStores: 3,
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBha33A2zGwgeqlEHSGrcPKuGl_53iy0jTOMz0hRsMYwkfj9TPCMAQUmy2vawKsB9PfmGr9zN_s-GYh8ngKB_dB4vbGKTO-QORZsjv6IxVv4ZX9lDPIAseCkLC-dqTBR0M7nnT7ebnZYiqEFdQLpt2mgv-T2-cobOwlVHDKr_8kDZAn-JgS0rRLBv65w0vjZGhdOIEEq-AH25s5SPs6mbGAEe9ehMg0a7JfRGV68qsCzFUa_p1v7F20Jzeu89MR2cn8UjzCKmUOzw',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBavxVFJ1EPKN4icdm_HaRsb6Kxp7Y3OCRxajddZJTe3yRav_dQldeky-ccKb-IhWaWk8uFNpRQIPePGJXevWMhYn2pJD8N17poiMr61v-L1Vzb6zRIIHuhjJAU0x0vDopf5jniIVcwmWP6KJIgjh-Jcd66lfnhSNlJZHUW7gggCZt_AOYBrfKECvbCBCyrw91MPjUA7hNpFRMGRooYwr-Xc1Q2SovrdkZrZhNxdF2PL_Pp7kLaPUsHlceKG-xpCERpD73q2TVNDA',
      rating: 4.6,
      isFavorite: false,
      isFollowed: false,
      websiteUrl: 'www.sephora.com',
      foundedYear: '1970',
      originCountry: 'Limoges, France',
    ),
    const BrandModel(
      id: 'nike',
      name: 'Nike Performance',
      category: 'Sports',
      tagline: 'Just Do It.',
      description: 'Bring inspiration and innovation to every athlete in the world. Discover the premium Alphafly sports collections.',
      floor: 'First Floor',
      totalStores: 2,
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCVsSt9YL3BjXGUcLtbF5S8OGCXEOLAi57ozve1JC0Ku56VGfAVW5WBCTIGne-HCG-ezF6fKJS4RBkQhzlbLygSfeTLuW89Nf7GFMkZs9JXZpDO_xG-pORcvlZbA79YtSkxLgNGLqWdjsyMFT8OUPNrCtux7nXWjTqtYyrGjBv9Vyyc2gq75pPwHikve1_J6nu0aYP6ZIjWEhX6_d3959i4UpBVPBokAEi0l_ESqzmQJM1MSXuNg1UApwA_IF8EGsTMC2FinzNtUA',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC7Fa0JNNe1BAm7w-JRBqgVe8cTlknVDxCNAo6CbaZsk_JbZCYhOq4dl5uEzTOely2RJTGNyyqafbqViMJXrnvdjEixNl9b8sEjL6ngkX6LOTo0Ekz_Jstkjo86TMd4RtzS3xn_Rf6_f8tfo-zGWK04jCDSaOcAkzYV8lx4pboPC0pRF-MSRvI-Ua8sL8YGAA8I4cUuOcGJVmHVzK529attJTN6f1NQ7fOQaBNK5cHpHGy_SgqWeN5NNFbxG_TRx1MYZXp4eLYWfw',
      rating: 4.8,
      isFavorite: false,
      isFollowed: false,
      websiteUrl: 'www.nike.com',
      foundedYear: '1964',
      originCountry: 'Oregon, USA',
    ),
  ];

  static final Map<String, List<BrandProductModel>> _products = {
    'saint_laurent': [
      const BrandProductModel(
        id: 'ysl_p1',
        name: 'Aurelia Tote',
        description: 'Calfskin Leather • Black',
        price: 2450.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAF2cwLDqQJuk34bLPwyaT3R2s_w-fd6gTwrw1kWZqGI7JYFq738KvPwBteL8PDxPDBPihb8hhYHruK-oZkN6LDm7fBWkLPXETARglQ8DcLgrOA25inIsOWZAduWowzC6fgW2qebHSZIfpUHvelvR4MC0MX_pqgKdLJnI6TN31tWd8Y3TqQ4szHzgndy9uXP3E-e_4gqeIl4DX70ZiSclHvPddpAoEoypMsoiXmImoITdRVmdK9HM7nQcQQcpSJMJE1OimU2QjnWA',
        levelText: 'Level 1',
      ),
      const BrandProductModel(
        id: 'ysl_p2',
        name: 'Monogram Silk Scarf',
        description: '100% Silk • Burgundy',
        price: 495.0,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAAPtaZRD8EfBeSOtEiTu-4ZOT4EIpQd7hsaIzP54k8p4hiRB-nnBckrX2IPcArSArRxzbMnIibQOAjFMPpbWsIIQHS9DHn2b5S0UmNv8_ngCKHAQkYFp5Baiy4jdL36zxjlRFHvmOmE8EL47NxqUw0o-hQpWueBzQMhE3CdQYQVqnKnpxv043aOnDeePCXli05VdPQi9LBxKzKLRrsM1GQ3GJPfqQUIcIR-rx0ABF5h0VtLCiENzwwCAh_L-i5C83CUYCGRh4x0g',
        levelText: 'Level 1',
      ),
    ],
  };

  static final Map<String, List<BrandStoreModel>> _stores = {
    'saint_laurent': [
      const BrandStoreModel(
        name: 'Luxury Atrium',
        levelText: 'Level 1',
        openHours: '10:00 AM - 10:00 PM',
        statusText: 'Open',
        descriptionText: 'Shortest queue currently',
      ),
      const BrandStoreModel(
        name: 'North Wing',
        levelText: 'Level 2',
        openHours: '11:00 AM - 11:00 PM',
        statusText: 'Open',
        descriptionText: 'Near Premium Parking',
      ),
    ],
  };

  static final Map<String, List<BrandCollectionModel>> _collections = {
    'saint_laurent': [
      const BrandCollectionModel(
        name: 'Spring/Summer \'24',
        categoryTag: 'Collection',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCvI_Q9BqdbTUt18omH1gzJmZKkvfwLPsG9775rXiDiyoVnHdmhlpmJfI2Tog7zmuwPI6Rz9OYISPujcE3h_Aagd_VYsflzcBT8JokaYapA4ZvWSlwb9nAlLmjIjrtCzUyYTNoZFhBo-ekHL1zVjoTFfxCNNClYr6sXHGSHfLpDEpo1aUIqo1-m4OkRUJAuIiqE-cXrf-O0zindVJUCoircJL_ZxZY8xwRFIDtoFITk8i9JubW6lRKxfpSxnpxwVySQGCEB_sCM6A',
      ),
      const BrandCollectionModel(
        name: 'Leather Goods',
        categoryTag: 'Accessories',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD7vOFS4Wa8X11-OuqtHFo1c0pYGJfoj4pqAFZgtDepzIe-3S4XL55YBDXrXKHxL_wHjUNeKx2L_1XHU4-BDpYj2kk_QDGq91hp8Lclgd9DxumVVPeZoVKQbeUGxk5jFhnMZ0RLnaj46uyGaLX3eE-3DFwYcpHxSyQxPDGFj9R9oxCSeIxp99rsD1Fv3RKbrT9PPEgwfJHj1kPlB_zO4ojzPIkeVpSr0dniZkmBRW-IrepEdTo0bq7buKDIG2mUVYi_STjq2yr_Sw',
      ),
    ],
  };

  static final Map<String, List<BrandReviewModel>> _reviews = {
    'saint_laurent': [
      const BrandReviewModel(
        name: 'Clarissa M.',
        rating: 5.0,
        reviewText: 'Incredible customer service. The associates are extremely helpful and the store design is stunning.',
      ),
    ],
  };

  static final Map<String, List<BrandOfferModel>> _offers = {
    'gucci': [
      const BrandOfferModel(
        promoTag: 'Flat 30% OFF',
        details: 'Exclusive seasonal discount on handbags and apparel items.',
        discountPercent: 30.0,
      ),
    ],
  };

  @override
  Future<List<BrandModel>> getBrands() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _brands;
  }

  @override
  Future<BrandModel> getBrandDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _brands.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<BrandProductModel>> getBrandProducts(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _products[brandId] ?? [];
  }

  @override
  Future<List<BrandStoreModel>> getBrandStores(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _stores[brandId] ?? [];
  }

  @override
  Future<List<BrandCollectionModel>> getBrandCollections(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _collections[brandId] ?? [];
  }

  @override
  Future<List<BrandReviewModel>> getBrandReviews(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _reviews[brandId] ?? [];
  }

  @override
  Future<List<BrandOfferModel>> getBrandOffers(String brandId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _offers[brandId] ?? [];
  }

  @override
  Future<void> toggleBrandFavorite(String brandId) async {
    final index = _brands.indexWhere((element) => element.id == brandId);
    if (index != -1) {
      final updated = _brands[index].copyWith(
        isFavorite: !_brands[index].isFavorite,
      );
      _brands[index] = updated as BrandModel;
    }
  }

  @override
  Future<void> toggleBrandFollow(String brandId) async {
    final index = _brands.indexWhere((element) => element.id == brandId);
    if (index != -1) {
      final updated = _brands[index].copyWith(
        isFollowed: !_brands[index].isFollowed,
      );
      _brands[index] = updated as BrandModel;
    }
  }
}
