import '../../domain/entities/product_entities.dart';
import '../models/product_models.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<void> toggleProductWishlist(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static final List<ProductEntity> _products = [
    // 1. Aurelia Signature Tote (Details Page Target)
    const ProductModel(
      id: 'aurelia_tote',
      name: 'Aurelia Signature Tote',
      brandName: 'Saint Laurent',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuANytd12XUjx3TxsgUVjP_C8TbxM6SgHfxx_tDEnOf-Y39YLEYlHcS2npcKEFg84lSv3IT3MLVX9ehTAm6p9Q1nLYYvJKn3NzLzQ2KXZSU50TPVngrrQJB6vBlVLSMEkIU2KDdFUv0tIxA_19lRO6zDnA1Oyej94NVfuCIzo9IALF-78xBtOTr2GfN-hT89atCQxdfUCa7iDK0wC0Dtsl-fBQ3mtM_AvyEzvF1_M_3ohPOxRnUXrltG_lIwwmnjkcVt0lkBc_Gw1g',
      price: 2450.00,
      originalPrice: 2900.00,
      rating: 4.9,
      floorText: 'Level 2',
      inStock: true,
      isFavorite: true,
      tag: 'Limited Edition',
      description: 'Crafted from sustainably sourced grain de poudre leather, the Aurelia Tote features iconic gold-tone hardware and a spacious interior lined with organic silk. A timeless masterpiece designed for the modern connoisseur.',
      images: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA10TkRmPMwdIlJgIL22a5N2woI2AZlmI2EEHjf4lLOIGg1z1wP5bmhUmeQtraUM3j5t3zrwxarmqu59Gz368EXO2zjd0DMP6wwusXZbp1QMXA6NaoKSHRHG3-6TaXCOpkZi0MbR62dnZecsvMGLtVTUZ0neT9fgRuAzcB9aPNZ1bdVDoK7RbhxjTiL1h7hXV-7SL0QqOHAXGfx0JHVeBmqJzwrmX3O6MYRyAAU5R38t6_7OnMHbPK4arJ-ZewbTTuTr_ZTkeWAqQ',
        'https://lh3.googleusercontent.com/aida-public/AB6AXu-arPlG8FcXp_wHOUfdrH3nK95McSAcECtXavJo6CMIL-22XDjLae330b3sKvMJhXiSO41L0kuZRT1Pe8xMEB7WmfxfMjeOSo4c0Caj90f5PwbaYCwal9-mrUPMmsROaFzRgcDWLFZ5uIJiK1mthCk_RdYkJKk2kJuR9xTo2WqAQFW-mfLMzUQbrP0-U7poQnDBcdoZZSUMEjIFMcEH1yKlc9xH0xN3uTXgnSAlUGKkV4nHBQlB_dzax0zOONBIXpXFS5lHwCAAg',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuB1HJGNMmev1vyjHTJ1a5SzSLI406VxrDuHo_dJ5iHexNPSbvBsLOISQigxsCTvtFDmHoeZCi0BvFRotz03WGwXyg3rU0tTCdxKgjO9rFSiO2xxlzdC481csuxJR7Zh3rQbBIS7TmZ1OpdUen0Iceog-rAbZuTPK1czitWlQFxet8f4biUKx78gcLvHCIi8iKY1fjUiDv-4W48azyI-gNgZbMCOvn4_SV6xoSoNaUeZwj7GTLGec98iDd_mGyZUMUoBvUL9zELguQ',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA-rJEKg4BV-fpUKeuafPyWrTTcgnSk_U1RZDXh_TpEmHxN-BHbe7UGPjJ02V3yz26rY5VgcMcCHESntsVX8jv1SYJkn4eHNlWEeRDsrW7PZKIfcmOGrIblA1IGHn8KAWPlvp9f7FpN71a57dvvH9YGBmTNNuk21w7HO6c38DvVdH11qfaQzayrcZQeyjNLNFRryMKob_mRi1cjujwFiGAvP3Cr6omUkMxOd8qKgmglnCMA5VLE6Jm2y1AoHoYNXAnC9irqIWcHdA',
      ],
      specifications: [
        SpecificationModel(key: 'Material', value: 'Grain de poudre leather'),
        SpecificationModel(key: 'Lining', value: 'Organic silk'),
        SpecificationModel(key: 'Hardware', value: 'Gold-tone finish'),
        SpecificationModel(key: 'Dimensions', value: '35 x 30 x 15 cm'),
      ],
      reviews: [
        ProductReviewModel(
          id: 'r_p_1',
          userName: 'Marcus Aurelius',
          userAvatarUrl: '',
          rating: 5.0,
          comment: 'Incredible craftsmanship and finish. A timeless addition to any collection.',
          date: '3 days ago',
        ),
      ],
      storeAvailability: [
        StoreAvailabilityModel(
          storeId: 'saint_laurent',
          storeName: 'Saint Laurent',
          logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCwuA4cyqLK4AfTsJKV0agKXaA0nTDJ1q4ZJAn33pwuTVh5GhsfS5SNQYwDuUQMe0tbn2vmKMaQEYipKLOgtHuweHI8qtsDtC0kZqr3VTy8xAq5Ze9Jio0fwhSM5dgdFJaI3KIKfnyf-3_p0ALmYC7H6AokbTnvojDWevvYZwJf-B7H13mVj6RQ0oz5iTkn1TXr2EP5mCXop8UmR5svm78mQtuqtNsE9furD3OaZk-KFWTZrQGMEvnWdmPVvhBTKMxxIf-wT9Erxw',
          floorText: 'Level 2',
          locationText: 'Level 2, North Wing',
          distanceText: '180m away',
          timeText: '3 min walk',
          openingHours: '10:00 - 22:00',
          inStock: true,
        ),
      ],
      availableColors: ['Charcoal Grey', 'Midnight Black', 'Desert Tan'],
      availableSizes: ['Standard', 'Large'],
    ),

    // 2. Master Ultra Thin watch (Featured)
    const ProductModel(
      id: 'master_watch',
      name: 'Master Ultra Thin',
      brandName: 'Jaeger-LeCoultre',
      category: 'Accessories',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBvM69bKCVyq8_NfztOI3H6tftHjtAvZNuCR37MCubOVKldUv8hT4PopJuxYag_kM4Dbtq11fMB_GGv3ZIHTk0QgQJH7NH8pcwfh7UlwiGiozm_4rcqRknOy4PiLPNr3wHSHeNrDQz_ljJUDtXCjQpn9v-IJ51P-gZFAeqnO5FMC4tJJWhbZHozy1pqtv6ctBdpBksb1QFjFGH-VFplvstsT2hrfnBGeAvfiQumcyPrTMzgZH5qQpbSwCVHwerV19h-aw-PJiloiQ',
      price: 8450.00,
      rating: 4.8,
      floorText: 'Level 1',
      inStock: true,
      isFavorite: false,
      tag: 'Limited Edition',
      description: 'A masterpiece of precision engineering and ultra-thin watch design. Housed in a polished stainless steel case and paired with a genuine alligator leather strap.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 3. Orbit Runner 2.0 (Featured)
    const ProductModel(
      id: 'orbit_runner',
      name: 'Orbit Runner 2.0',
      brandName: 'Balenciaga',
      category: 'Shoes',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC_NpxT82vZBe8e9r0cioqa7wlLx3ZKzalTM4QUJRshctMZd71loMc29QMshsgp3P64WAZlAJO1Em1ilJoKcGYTlSWKBfSjtkUQamfDZYJD_D-qqPomllH6zYrVwdEzUSg4fr0m3buiXfxawaVvitqpgd1p-Ow05G1EuiyY-aF0YREIHfRaqtlW3hOU3OkIxHlp62hmXyYzUwLp5HhXTlY_IhAz4OumkXPc7fTb045imxw_GE10h0JbBIYgJHodwHUbNfjbJYokHw',
      price: 1190.00,
      rating: 4.7,
      floorText: 'Ground Floor',
      inStock: true,
      isFavorite: false,
      tag: 'New Arrival',
      description: 'High-fashion modern designer sneakers constructed with premium leather panels, breathable mesh base, and architectural layered outsole structures.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 4. Flora Gorgeous perfume (Trending)
    const ProductModel(
      id: 'flora_perfume',
      name: 'Flora Gorgeous',
      brandName: 'Gucci Beauty',
      category: 'Accessories',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCXiGiRD7FO899jSXdFga4dTtllJyiJc2tb8rsX09563XcB5MWmjw0QCu8P-0V3gEGqGgic-mdL_Mtkd-GNjIilSdojPAuXi_uPcCG8vSecxOci_SpZ0kZMTYLbSyclEDaoNkJHZ2u_52soIEEyLB7gysdHlZYsrbHyymod4esW6fmhavvldsM72396YPEBsCeetXrPvVS2BA5FGq2hLqZdh1M6S5RGMtSug905yYIpkLt3-fcCXf8EP_mT8ryifCQPbD7ivyjX8A',
      price: 155.00,
      rating: 4.9,
      floorText: 'Level 1',
      inStock: true,
      isFavorite: false,
      tag: 'Trending Now',
      description: 'A premium fragrance housed in a beautifully decorated lacquered bottle. Dominated by sweet floral notes and fresh accents of pear blossom.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 5. AirPods Max (Trending)
    const ProductModel(
      id: 'airpods_max',
      name: 'AirPods Max',
      brandName: 'Apple',
      category: 'Electronics',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBdphsuASc8FXs5L-8ECUBvaVVmW0IElSmzv8zkceQB0HvCPOyCK4VPUwyhuAZqP8wtecpZ72zZCMgS8lxheScWx1wUhFVmoA9H-TYjB68QtX1Sg9S333vuVd7Yw-w3etGkgQA4ASQgq683Posk_HgyJzEG6MXrRgA-ZhOS3mOz67vnx1ZCjr9xpArUBb9X3EPD8QZLnyI7hMt_JeVhBZpmtCDhmQo8ZPyD_p6RYbu2yq3LE93eNCJVyMcMdLtZi9Tqwga4reAMYQ',
      price: 549.00,
      rating: 4.8,
      floorText: 'Ground Floor',
      inStock: true,
      isFavorite: false,
      tag: 'Trending Now',
      description: 'Premium over-ear headphones combining high-fidelity audio with industry-leading Active Noise Cancellation and spatial audio tracking.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 6. Galleria Saffiano (Trending)
    const ProductModel(
      id: 'galleria_bag',
      name: 'Galleria Saffiano',
      brandName: 'Prada',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABC7y2H1IXMFV9A0s7gTn7w6p82_PZA5YXfWnXg-PjdkiLuCHkqtt_bKqpLe9FpLeiMX8ou9OnRRWAlxJ9NMGRzFM4fiBqny6V5IaO1rlJL6KXvSRGDac-PYTymj4Fm1p4nrk4xBABkicqUDOdfUBhZunX5Jve4CoAQq5VxEOJT1gTJnj9IF51pISvvfXiGH2-Nuouw6M5NmVtd5P6hdPxtleqSlLu6zE_TI8ofsHaIM7X-k9j6Am8q50pbBOur54xXdCC0AfFkQ',
      price: 3200.00,
      rating: 5.0,
      floorText: 'Level 2',
      inStock: true,
      isFavorite: false,
      tag: 'Trending Now',
      description: 'Classically structured top-handle bag constructed with Prada\'s iconic scratch-resistant Saffiano cross-hatched calf leather.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 7. Sony WH-1000XM5 (All Products)
    const ProductModel(
      id: 'sony_headphones',
      name: 'Sony WH-1000XM5',
      brandName: 'Sony Center',
      category: 'Electronics',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCm-ooWXuh6GbuUxWBgphcWZEwKxwSuIdgsrIHcsPXefxN50wLMsP5Vp2L9AKdp3n1vkfh2puJbBeOcRKbFx4Yr0YDJ59VAc3Wrl12g-Hz8jZ9mhcH4_EAevbsBecDEDNrtWLCmwLfxQkRk97eb69xvk8kqviKyXX8gT-0M0YlVPZJjHaCpn8UHM1P2bZL8ObsyZpnXQjhvFhqNPPkhXOL5DYx_ZXRmfUR6BkBkwov9ooN4andcX82McJhEclxO5-O0G719Mgts0Q',
      price: 399.00,
      rating: 4.7,
      floorText: 'Level 2',
      inStock: true,
      isFavorite: false,
      tag: 'In Stock',
      description: 'Sony WH-1000XM5 noise-canceling headphones with dual processors controlling eight microphones, Auto NC Optimizer, and high-quality phone calls.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 8. Floral Silk Scarf (All Products)
    const ProductModel(
      id: 'silk_scarf',
      name: 'Floral Silk Scarf',
      brandName: 'Hermès',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuByywbviD82po09UFshh3-jY0SK1zzoTFQd4afRJQSptcGIpR71xxbzOSpz1dzpg5kx70zuNjbLm3METZj7MseKCMKkVAqjSFylK97bkuD_nbuBzVSilgywQJ5XNPsoN6EFB3Xg5KHDtQng2g6MWSwjxgI9jl2iBSTxpu2SiOa3htOoqnJObmh0P-kk7zLjE7CxSRitWm2RTMJLN90z5MXxaSYlYr3LN96tMMXyij5pF9a4CPu3MKzViiT1ZQvgC-as7En1g2vyNg',
      price: 485.00,
      rating: 4.6,
      floorText: 'Level 1',
      inStock: true,
      isFavorite: false,
      tag: 'In Stock',
      description: 'An elegant Hermès accessory made of pure silk showcasing detailed botanical motifs and hand-rolled edge linings.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 9. Lutetia Shoulder Bag (Recommended in details)
    const ProductModel(
      id: 'lutetia_bag',
      name: 'Lutetia Shoulder Bag',
      brandName: 'Hermès',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCdK-o48-sKQlxN_4xt4xmL3FJzG10U0AaksyOtbDk69giIfdHNZLd4xCnqne-i_DEFcbBaqfk4_5pb3-G2rIFvUVH4IfYnec0YcNjZuTfCzZ8TsYlDP3567Vh1X4r21yCLkFoa0du8M6ABNtI8j3aIUlB-p4pNhiPONnV_XK9VB-CjLeqmuvY4J2X9Ofekhw08IiZX8dTKsfKtFhXxYEYTSXxmQbyDOcchtC1D5VRDUZUd-2VOstg7dcPCx9u9WV6hi0Eg33glLw',
      price: 1890.00,
      rating: 4.8,
      floorText: 'Level 1',
      inStock: true,
      isFavorite: false,
      tag: 'In Stock',
      description: 'Hermès luxury beige leather shoulder bag with sleek metallic lock accent.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 10. Midnight Evening Clutch (Recommended in details)
    const ProductModel(
      id: 'midnight_clutch',
      name: 'Midnight Evening Clutch',
      brandName: 'Saint Laurent',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB1o0Acou-eiqylStJTsvWqgmkWUwcZJK-CeE7tgoKgIbiaADkUAF6mVhLqAUkcq8_EPe_5UOPUtn3kB7XM5DKs1x9eIHu54DZ_xT-EHbpyWCd2Vv3IS18cYJ-WmSnD_jKJ1qkWTH0MhQThcfqsLqde_gk34cSZ1qcdbW1BGoC4F-dbuKQDtoZbuvvEnkUYhBKCrj0qOxL_kQIFAnjnkK1YwvpSWNB--7mLycECg5MiVm9v3d1KvSQ7q9TEjXDt3pxyt-Xo4nVs2w',
      price: 1250.00,
      rating: 4.9,
      floorText: 'Level 2',
      inStock: true,
      isFavorite: false,
      tag: 'In Stock',
      description: 'Sophisticated black quilted leather clutch featuring classic Saint Laurent design features.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),

    // 11. Modernist Arch Tote (Recommended in details)
    const ProductModel(
      id: 'modernist_tote',
      name: 'Modernist Arch Tote',
      brandName: 'Saint Laurent',
      category: 'Fashion',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBKHS8gE8CXlXz6iodm47i2GXmqc9Liiqxa9UoeL4n9uGgXa-z8oq79u3mpp7UL23dzGyljIWUTmEgft9KyEuAkTJnHWQaMR9PwD_ubrejJ9LjmL-GIgMwn99a2GtRk7mSB7QkS3uvOqUdbEtRgiHn68z_FozZOMD00__jukYxlXMyvrHVZQg_7sH1NBL_AVH_3wMhnh0Vl0QWik9wJzW1O-r6eyG9ZaPXjkBoLqKc-Gb5p8UAyo45kUyIcnxtW3SulTBqBT58n5w',
      price: 2100.00,
      rating: 4.8,
      floorText: 'Level 2',
      inStock: true,
      isFavorite: false,
      tag: 'In Stock',
      description: 'Elegant white top-handle tote featuring architectural silhouettes and gold fittings.',
      images: [],
      specifications: [],
      reviews: [],
      storeAvailability: [],
      availableColors: [],
      availableSizes: [],
    ),
  ];

  @override
  Future<List<ProductEntity>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products;
  }

  @override
  Future<void> toggleProductWishlist(String id) async {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final current = _products[idx];
      _products[idx] = current.copyWith(isFavorite: !current.isFavorite);
    }
  }
}
