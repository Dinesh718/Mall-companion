import '../../domain/entities/store_entities.dart';
import '../models/store_models.dart';

abstract class StoreLocalDataSource {
  Future<List<StoreEntity>> getStores();
  Future<void> toggleFavoriteStore(String id);
}

class StoreLocalDataSourceImpl implements StoreLocalDataSource {
  static final List<StoreEntity> _stores = [
    // 1. ZARA (Featured / Fashion)
    const StoreModel(
      id: 'zara',
      name: 'ZARA',
      category: 'Fashion',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuANuM3soeuNt-49PGexYDJaj7paQDhIskA_KaaEC4-DJ_J6VldhPpimQeZBnzjxcVOhj3jLJ3dLXkC9GcozKPoNFh5yk8JpieihxhkEs0jzEwOhDbkCjT9M9eUOKJIxD3-QvIK9uKw1fT66ERK3n6jSWS4gq1f_BNgUEpj3XeqdOIQ1eq0KSMTUmUJy_qf_bEhDJFQnNfsxjLPtybXCCa74ufCWELpDkEhdTeU8LUxQ3KQGQJzrwEbw7-HWZZkuXvH6dbBria4fpw',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAXPqtFaumRI0T3AaHmd2fTnker_FSm6CrScDkEoxSF-CsbpWHetI_RRiijHEivdSb9D48p0KF_5zV86gaSZMjjaYgbqRjQB5zPQX9rN-ItHDSmS-pPzdBFwLYBVkNu63KGpq3uimb75sukzjEbXpZbPbyW96YQZxJdywBolBdmW6Od3j6S0r7I6s5VcJRFD7en4CcocEIXyqPIiVqIpGen5BN3WEU6FDZwh4yebkwR6Z4xrmGOA-sak6j7DD_895qPK4CtAt5VVA',
      floorText: 'Level 2',
      locationText: 'Level 2, South Wing',
      storeNumber: 'Store #242',
      distanceWalkText: '3 mins walk',
      rating: 4.7,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'ZARA is one of the largest international fashion companies. It belongs to Inditex, one of the world\'s largest distribution groups. The customer is at the heart of our unique business model, which includes design, production, distribution, and sales through our extensive retail network.',
      phone: '+1 (555) 019-2834',
      website: 'www.zara.com',
      socialMedia: ['@zara', '@zarahome'],
      isBookmarked: false,
      offers: [
        StoreOfferModel(
          id: 'zara_offer_1',
          title: 'Flat 50% OFF',
          description: 'Valid on selected Spring/Summer collection items.',
          discountText: '50% OFF',
          tag: 'Season Sale',
        ),
      ],
      brands: [
        BrandModel(id: 'z_zara', name: 'ZARA', logoUrl: ''),
        BrandModel(id: 'z_zarahome', name: 'ZARA HOME', logoUrl: ''),
        BrandModel(id: 'z_trf', name: 'TRF', logoUrl: ''),
      ],
      products: [
        ProductModel(
          id: 'p_blazer',
          name: 'Tailored Blazer',
          category: 'Women\'s Collection',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCE1rIjs8sLLlFkLsmXQ8kFVRbSzrMQUm1VWqxg_rMun4R2e8ByxhiwBemDxqc4Gbr8waAmbFLxniPzuRsSGQPLZZxGhpzsfsc7_Hg_ZCqnxh4AdsHPthjDixw41FERGffiQr0p6TQul5CkAf9xEIos3O4eZs20sq0Lr1x3dmX1yhFHFoVDlxDbWu8kiG1__YpnI3mQON8xoX_D7hoqW2UZ8ucHZqXtV9PJ0XZDyPDsd0gMFwS-4AMmIm39EVEQf2GTLaGLoEuk6w',
        ),
        ProductModel(
          id: 'p_dress',
          name: 'Satin Midi Dress',
          category: 'New Arrivals',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBbfOLo9WeyDVPx5CNKIg66KeJQn6wkvEMSSS77GoL_lvV-5CrjJfC0vMC3FDh9ueKYnLaj8g90rTDd7IPRhqeWgX1wgrdmygsyiow6wTAcNTOAJp86cpKlX4PMJVVLw3PRv4sRQZVEJMPcF9gi_NE6Cdx_s9xCIT9c84Gt7bfoZiC-iDP_VBf8pE9ErGOB5z5-rLpSTjYiFXOI5Rchd7CDRFNNwPCGo82WgRInR4U3otuk9SYx0Rzu0wW73iZYK1BGNMTBrHahBA',
        ),
        ProductModel(
          id: 'p_loafers',
          name: 'Leather Loafers',
          category: 'Accessories',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBbbYSwEQXRRu550Glef7W1ovxeyUtf8l3E2afs4NmbBSeYUORpulEHyW8rpqXljKXg3dLs3n23tLOZkGEDAtCMXdW4h8CBqpcau09sh2Eij6_zcTfAOEEUcVnbLdBkD6KM4aaI-_lnKKpOFC4bA2t5vO54R8_K2wTVeUoPbIuzJW8naaxa1POPiY6rTGtZMy37XhgQbBYR5jRr5TVjXeBSiWoGwmGXO4oY5-LFRWkgY7r1j_muAQFPIugmFeOGn3zRwSUBf2CN1g',
        ),
      ],
      gallery: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBrVvOaD14mJAPyP_7b1eFxuaHK5K2CkWosUfLntxjA0sQ5FmqNyIss4I71oLQdUwkX3wsMfMttCCADSRn3-3bPSqGMFCcqq5akmBkXL72iTbb2Q6qxBTnf60sVSwEZQ40OBLPHBHMD7VR8wRFJlBZVAOGOd5fBsGeeKsh7vEKUbKIco_cIUdXkIfA_wtRz-mfyZhrDVm_rsAYdZCYdgpDSOqeWrfuLsgAwKAhSRdcwy-FxD_9mJfJmd7D2NYqLYvy5-6XYjrh-5g',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA0owkBF_EoQ-mcYbYlZ04NgRvu9duWedvj1icZvUFYT-r0q6oLlg56w1Mr3-s1fVPdhh35KYEYtjyDE835yWfnqLnCDFSVtsJb9J-Oicl-LhrzUNh9B-ZfERRSIX4XrLpy0a9DMKUEj7d_yrCd_SX8OGww5GP3kk_RKYosHG52sXckq8fArDu7whKfOVX4BhpR7niUYoNmIGfEK7kYzKgfGN4cJYGG9oyPrwYDjw74kJ9Q06HebJBT-Pt4kTXETkmUprmTp5fY1w',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC1G36FHruet9WQglzx1RErXHujpdZctcMa_ujjjQcEbEkhoY5tzL5FrK8QZtLueWDEXxI5wbVbYegZi5_KnG9ZkkaBdWOXd8--L8wco_09j4P9AkT8Dt6O04weszEiaE_iMn4U5J888Xp6ExTUonaT0MsHD9atVUq-88lS-pVxT7o8tpGoKM1Tpjg09ioWUqD979HT9zFOKwXhe9uvHT42clDzDDt5R_Rml-T2JJY5soOB6ZY9rPKt7-8GW-30Htei2v0Aqr6ESw',
      ],
      services: [
        StoreServiceModel(id: 's_room', name: 'Trial Room', iconName: 'checkroom'),
        StoreServiceModel(id: 's_deliv', name: 'Home Delivery', iconName: 'local_shipping'),
        StoreServiceModel(id: 's_wrap', name: 'Gift Wrapping', iconName: 'featured_search'),
        StoreServiceModel(id: 's_collect', name: 'Click & Collect', iconName: 'shopping_bag'),
      ],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '3 mins walk',
        floorText: 'Level 2, South Wing',
      ),
      reviews: [
        StoreReviewModel(
          id: 'r_z_1',
          userName: 'Marcus Aurelius',
          userAvatarUrl: '',
          rating: 4.8,
          comment: 'Perfect flagship store layout. Very clean and spacious.',
          date: 'Yesterday',
        ),
      ],
    ),

    // 2. H&M (Featured / Fashion)
    const StoreModel(
      id: 'hm',
      name: 'H&M',
      category: 'Fashion',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCH79LAoQGrdN9Dk1gNL-nxilTp0D_zsQ7X6JRpq2iO4GyCBMDQjf7Ln4xix1DH5I76R-NTJskkTueQ88fk7balnc7YaArEkZV0sJYyLfGiBH5PcbjyMV94ezGvGczaGZqIROUBRqHRE3NE6aDOVHLEA4lTI9QRJwsJyJ7SuZgOpH4ZojCn_uZl_vA4gDOdhGcVp9S_QOwSRyYZOLUtwsAAmBpWuNF8F6aRQ9-WUc-W_jLe32KyznNbRfVb_SeRv9jJX-ePbpmS3A',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBRbjDv4U6q3bXuEw3Zz_yRu4zsf1tGJE8GK5ghuR5N7DkQnX98TiwzvDOxHfupUOoA2H8PTCIN9hefqmcXaYOu-HtBpwf1cWbg_7_YqKYx3b1GAhfKC385-5Vtc0b9zjjxfy6He2t5mBRE2DMhRSp3thQG51Tvqy18OicgUiaw3N-G4eleAHV0VNyq4zbYXXSaX-tQ9Z-tHAIFewki4ahMpnJ_O6jQLUv8fqiYvAIlNt2YwACP7VhH-H09W5ZplYvxMpTnkTWLCg',
      floorText: 'Level 1',
      locationText: 'Level 1, North Wing',
      storeNumber: 'Store #115',
      distanceWalkText: '6 mins walk',
      rating: 4.6,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'H&M is a Swedish multinational clothing-retail company known for its fast-fashion clothing for men, women, teenagers, and children.',
      phone: '+1 (555) 019-8877',
      website: 'www.hm.com',
      socialMedia: ['@hm'],
      isBookmarked: false,
      offers: [
        StoreOfferModel(
          id: 'hm_offer_1',
          title: 'Up to 30% OFF',
          description: 'Special discount valid on selected items.',
          discountText: '30% OFF',
          tag: 'Mid-Season',
        ),
      ],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '6 mins walk',
        floorText: 'Level 1, North Wing',
      ),
      reviews: [],
    ),

    // 3. Apple Store (Trending / Electronics)
    const StoreModel(
      id: 'apple_store',
      name: 'Apple Store',
      category: 'Electronics',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCGYx6bXKtvt783z7wMJSUlNizcdVY9gnOVQq2Z-VoqLOoiw1nWRXHU9c9OtApl6kCQC49tWVM6zha0nuwD1u8irFbtWAAuHygVQWNvfn0g_gB_soCSYcatL0UAY94wj5bzPTu9BV-3IXunfVCcbT5oBND5mG7Iw4E-ysmaqrlzn4L_iI_wI2MEQevtQD0UGrGn__HWmFSZmtCTfUPg0p2UPkPqO0GMZXKmO2VelUb64w7DRKoXD-BtVAh76dUNpd5bLze4pBVGNg',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjbsv5QZkPCoZRfcUN-k-bsZyARWmCqHOzZMMknpNg733j7-6isGpj1F4PiQKxnvXFsUoJnmGWumE-kzgljhK38ZGnEUe-QYwgP6sGPHLHDWXl8Z1NyahbF-eYb3ayYAXt8VugXo5PYKqRu2_hMAtes3y4SCvdwsovPeqeA8218g1xB83j6DeIMVkkoL_NMCYNQc0feqOaq26NRcoekWEhGSX4Qc4wgl2gMPyJqQSePjohDadCf0VPjBSi-0rsLX8pAJEJkoTKUQ',
      floorText: 'Ground Floor',
      locationText: 'Ground Floor, Center Court',
      storeNumber: 'Store #012',
      distanceWalkText: '4 mins walk',
      rating: 4.9,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'The Apple Store is the best place to try all of Apple\'s products and find great accessories. Our Specialists can answer your questions and get you set up today.',
      phone: '+1 (555) 019-9900',
      website: 'www.apple.com',
      socialMedia: ['@apple'],
      isBookmarked: false,
      offers: [],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '4 mins walk',
        floorText: 'Ground Floor, Center Court',
      ),
      reviews: [],
    ),

    // 4. Sephora (Trending / Beauty)
    const StoreModel(
      id: 'sephora',
      name: 'Sephora',
      category: 'Beauty',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBBYYoi5VqQ8G99ZgKTZYf4eszD4bBWMmQYlPd1sSedWHv-VFWO6Ur2SjbhMMnF9sb-9fCFTgJVvv11Fi2lrAHKPBKdXolb81__8jhTzJMq52JjnyCeF88O8F5f7SsqO1_LVR5Dpedhsfn70QSzUTOFw1rUdDWC3KJnUWRBXsmXxXeZwnvy-bZOsjZQkEQEhDSZ5Lih_gizw7SJHm8HlgQu0YwZ5h3PDKrD_c4GgK7N4rYvnLUkN5KS199xS7Krcdkg5ToareECeA',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjbsv5QZkPCoZRfcUN-k-bsZyARWmCqHOzZMMknpNg733j7-6isGpj1F4PiQKxnvXFsUoJnmGWumE-kzgljhK38ZGnEUe-QYwgP6sGPHLHDWXl8Z1NyahbF-eYb3ayYAXt8VugXo5PYKqRu2_hMAtes3y4SCvdwsovPeqeA8218g1xB83j6DeIMVkkoL_NMCYNQc0feqOaq26NRcoekWEhGSX4Qc4wgl2gMPyJqQSePjohDadCf0VPjBSi-0rsLX8pAJEJkoTKUQ',
      floorText: 'Level 1',
      locationText: 'Level 1, West Wing',
      storeNumber: 'Store #145',
      distanceWalkText: '2 mins walk',
      rating: 4.8,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'Discover the best in makeup, skincare, haircare, and fragrance. Sephora features premium cosmetics from top designer beauty brands.',
      phone: '+1 (555) 019-3344',
      website: 'www.sephora.com',
      socialMedia: ['@sephora'],
      isBookmarked: false,
      offers: [],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '2 mins walk',
        floorText: 'Level 1, West Wing',
      ),
      reviews: [],
    ),

    // 5. Lush (Trending / Beauty/Skincare)
    const StoreModel(
      id: 'lush',
      name: 'Lush',
      category: 'Beauty',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCvjkbZ3MEhxfxRUDwIFldLzly_jFfyoyncByZtjVQdJjMoDodvQXrAawu1kKzV8qDLDgxpPMcObyezs-T_o-GhLj6TTqBDJvGQMEY9kyLX4z52sKnRPhrQ4c2tOhNpIowzYGhCQwpXhgzfuoeSdyL-5USk0Es__wFdxAUuT2FCHsynjB5mFP3fLYiY5deYKNcGXg5PNN1hrfR4a88tFJdnFjl4MBgxdaR9Vl13mRn-INaM5skagAgumnOxt4bRisbtP0xMw7eFsw',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjbsv5QZkPCoZRfcUN-k-bsZyARWmCqHOzZMMknpNg733j7-6isGpj1F4PiQKxnvXFsUoJnmGWumE-kzgljhK38ZGnEUe-QYwgP6sGPHLHDWXl8Z1NyahbF-eYb3ayYAXt8VugXo5PYKqRu2_hMAtes3y4SCvdwsovPeqeA8218g1xB83j6DeIMVkkoL_NMCYNQc0feqOaq26NRcoekWEhGSX4Qc4wgl2gMPyJqQSePjohDadCf0VPjBSi-0rsLX8pAJEJkoTKUQ',
      floorText: 'Ground Floor',
      locationText: 'Ground Floor, North Court',
      storeNumber: 'Store #024',
      distanceWalkText: '5 mins walk',
      rating: 4.7,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'Lush Fresh Handmade Cosmetics is a cosmetics retailer headquartered in Poole, Dorset, United Kingdom.',
      phone: '+1 (555) 019-5566',
      website: 'www.lush.com',
      socialMedia: ['@lushcosmetics'],
      isBookmarked: false,
      offers: [],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '5 mins walk',
        floorText: 'Ground Floor, North Court',
      ),
      reviews: [],
    ),

    // 6. Adidas (Browse All / Footwear)
    const StoreModel(
      id: 'adidas',
      name: 'Adidas',
      category: 'Footwear',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDyUDQbJXw-KFfmM5fR-Pkm27c-JvWfdIja0E0HIFa0HEZ3Dxl4qakn1tvvMlytyaX8eRjZEkdSbkoaP_Tr8TnWGbTl9dXTkDf8UIrxHHwiXSpjW-VNzEb_a1k1fcF0SP0oa3_duwEkx7oIrjBOgckQ0QGrQazlz8leEnM7VyLLEFPUf4IYKlxPOZfndHM0aAW-8g3gNcK2EFgi9U3ZaLeC9lAc0sYtWiZP8UccwaSojIdJ45zfRSNlWC_SIg9mxXimGdOfeo5bHw',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAx4Ifd1XTEVY4WdaDvK76ahh39-6KCMEyda5uN3-4kJ8K4_EWshQfBpeAaKQEG-o7rWx9yqsOtGz_jAJcQ6uxEivlIhmvEeNnFQ5UOUVmEsx4lSjz5AyLmHMM9PfoKFLA0yzgEux-nzKHZ1Q9xhyU-OKHl6d6pHsDZB1O7aNFrEKkwoShfZTbwcJt8_fTKu7rytOzq3wo3cofhf7rpet7jca6QqgU8s84vQmEOSAfGxdps5LbnCm-jP-qepTKE4FfPXXfmVZ2rIQ',
      floorText: 'Ground Floor',
      locationText: 'Ground Floor, East Wing',
      storeNumber: 'Store #048',
      distanceWalkText: '5 mins walk',
      rating: 4.8,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'Adidas AG is a German multinational corporation, founded and headquartered in Herzogenaurach, Bavaria, that designs and manufactures shoes, clothing and accessories.',
      phone: '+1 (555) 019-1122',
      website: 'www.adidas.com',
      socialMedia: ['@adidas'],
      isBookmarked: false,
      offers: [],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '5 mins walk',
        floorText: 'Ground Floor, East Wing',
      ),
      reviews: [],
    ),

    // 7. Nike (Browse All / Footwear)
    const StoreModel(
      id: 'nike',
      name: 'Nike',
      category: 'Footwear',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4h7lwHweb2qa8n0_qX7AjeEIhwGTn6mwzCZb1y26Lm93Y6xCH1kvgg_dvuKImlRcvUqpefmqIbnQbYcnFw2oYmF70WHKn57NzuR1mLXe4LNWuvmqSydv0w_sAFKpYr521-IotpYMUuoFJ0eeZcFs66aoZ2rYyORILbcRuvxx4L6fWVF_acW1I9L2KkloPhAAShRaHXvTWYubBhSe8qtOhscZncYsOpsCuQUyt0WUkX6ObHQmYHWe3K_oJoj1Hxu2g7Wv97OPQ0w',
      bannerUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCawu2PMK8Y3Q9pp1xN_0t8zrGAJ6Jmo6TlEMOdtHxHJR73PpAi_ISJmkYifFqigSqn2EGPE6NTPDD6LhpRE3ISk3sY-gvwtO06BA0pAn4B_Jfh3fJbT-6uyALlWcp4x_tRh6H72V1KOec1ey-_I3iKSEVGvlV8pPJvnOFLTW9cTusDEGdZesx8r1JLzN7_gsTS3lPN0x54Vpuod-hOPKlXOC5XG5PEh36VahZjrZqtoQx4kpfbLsBktKjT4CrkWcsKyW6TSAGE9Q',
      floorText: 'Level 2',
      locationText: 'Level 2, North Wing',
      storeNumber: 'Store #215',
      distanceWalkText: '8 mins walk',
      rating: 4.9,
      isOpen: true,
      openingHours: '10:00 AM - 10:00 PM',
      description: 'Nike, Inc. is an American multinational corporation that is engaged in the design, development, manufacturing, and worldwide marketing and sales of footwear, apparel, equipment, accessories, and services.',
      phone: '+1 (555) 019-4455',
      website: 'www.nike.com',
      socialMedia: ['@nike'],
      isBookmarked: false,
      offers: [],
      brands: [],
      products: [],
      gallery: [],
      services: [],
      location: StoreLocationModel(
        mapImageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA1v7kOlTEhDoUuohx2MMfn23eSlFNmT9l6xGwufgYfJfrQKlWbCpsDMh1UXW5H-Bw2fV2ZOT5Y3Df2LvbNyUYQLJgyhNyY3W51o7XX-JnkIFWF-eZBae1kmr97S_SVlZHxW2duu0yWE-sXnbBf1w3YqZ3TLeR2MjpdrV8WsL72DdFke4lORS1Mr_zRIIdrkrlgntnJGm9EVq79DooSxv2noABRtO9la4HVzjVTjinLqQjjs_7yzo0rEZwyw4T0ATwYYSY9Fu_Erw',
        distanceWalkText: '8 mins walk',
        floorText: 'Level 2, North Wing',
      ),
      reviews: [],
    ),
  ];

  @override
  Future<List<StoreEntity>> getStores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _stores;
  }

  @override
  Future<void> toggleFavoriteStore(String id) async {
    final idx = _stores.indexWhere((s) => s.id == id);
    if (idx != -1) {
      final current = _stores[idx];
      _stores[idx] = current.copyWith(isBookmarked: !current.isBookmarked);
    }
  }
}
