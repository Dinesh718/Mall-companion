import '../../domain/entities/discover_entities.dart';
import '../models/discover_models.dart';

abstract class DiscoverLocalDataSource {
  Future<DiscoverDataModel> getDiscoverData();
  Future<List<MallEventEntity>> getEvents();
  Future<void> toggleBookmarkEvent(String id);
  Future<void> registerForEvent(String id);
}

class DiscoverLocalDataSourceImpl implements DiscoverLocalDataSource {
  // Stateful simulation of events in memory so bookmarking & registration persist during application run
  static final List<MallEventEntity> _events = [
    const MallEventModel(
      id: 'summer_jazz_night',
      name: 'Summer Jazz Night',
      description:
          'Experience an unforgettable evening of smooth jazz under the stars at our Central Atrium. This summer edition features world-renowned saxophonist Julian Vance and his quartet. The evening is designed to offer a multisensory journey through classical jazz standards and contemporary fusion. Immerse yourself in the ambient lighting and premium acoustics of the mall\'s heart while enjoying signature drinks and light bites from our gourmet partners.',
      category: 'Music',
      dateText: 'Saturday, 22 June',
      timeText: '19:00 - 22:00',
      venueName: 'The Atrium',
      floorText: 'Ground Floor',
      organizerName: 'Lumina Cultural Foundation',
      organizerLogoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCqSBhqef5Wg_-t6nAcXLaxaxNs8DNHbFuAW8yjuwXyrqwBxCp8ohIod26_eI9OWyCTVvQzoZrG9CrraCOR1NDSW9rocZpfLwHWpRaKcFI-NGh4MzJGv9bjUvlN8ObJRWNecG9o-7E28tiIN3zNQkQXB7q1NGBBxfSqG1Vjq-d82yQuQUGH5MFfHsE6CiFbTKgupwiiIH46_66JtJ5j29b3y3wU5-M8tVSCNg3zifi1U8zLfdLy9UZDR-AcQ2z0GadIu10S589yng',
      remainingSeats: 45,
      entryType: 'Free',
      price: 0.0,
      interestedCount: 384,
      isBookmarked: false,
      isRegistered: false,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDcIGpnDOy62F30VfFIpFLDWoeJLEifkXoj5nLOJcyIqMWwbepw_H1Rzawv5E2oB9NbbmNOl9slIEantJzCAH7bq_ZCtNwtu70a5IFrDKdLMXepecerFiGkSmL6SbDW90_8sqe9XkhBpX_vqzeJ3rzGQr2BXPWdNMeVw-jtizuxn4wRv6SkcdyUXXsTVGrxEuwR8U_ft5Z0fuWrChm9jggfUFpEFxYQF_TI_gslVcmmtMmyYn2ylE1F4BTbp6785jJaIOjvemtr9g',
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA', // Starbucks
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBw_UQLaQKUpsFUNpiGcD7Rmr2jSlgviSKf6H2RDqlEHQOvUw3lZkAHs_LL5Sw9aYHfqQ-d_jLwYkHGJJZ_vsmXUiTrpunXskkYmFbl0VrUZaTZQpEJKZEovQp7SSC_XgPeWw0NCqapHWEZupXbN4PLV9o0qlTAcMdPKa6HugheKaWdvL42Jz6PbPj5AQvvhTdMCuGlu_6KFvVbfxv6I6pPvArjdAeuyFlvAX1RFLpdeKaozYTWgMFZ4RldBs5v0OMBrLHsSNUl3g', // Bose
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAZl9UCnFgSI-holQw96aPFNZdZbszPkgom7YBfnlccYcnX1iLbNnCB7pb_dJWF_Id1UGj8siClmms1fFE28HUfJxb19T7aDaoEpZFBu-MnpsQkZZnkodYpUNBct13UZ7dYtiNJ9HDnI1bunwWyIifnA7mQm_LjeZdFA9cBF6pLR8HY_JZfYLH6dsoQ-3XSmtSaw27096dj8vEwNW9dMq-Nxh4TJxxLqH8018sPeH0iUz2IjUmhuy2SL6s1_I0GxI4Ntg-HNSNWog', // Nespresso
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDtO2OvmMw5c42auvrO7vtMJwYk0sZOsvvKaAbOR6KSgIssoyxB0uoruC1cvsHRn6NYEP6A_hGspizvWQ5fKyHDHQOT6rmejUgUM6zinej7kpdrJCZIsBtXRaWrmyxhnr_masQf7WzaS8UlIdaysyuVFddFOVtYwr0pw57BTy4ltWt1G-5-qOvc8h4gqV43PXARq69DBjNWoqmWyJgXnJwAGmptEX907TB3WzQ_VQ6MP3X8rOVTCI7tc3pHzet7eFKrRa1oZDgy2A', // Apple
      ],
      statusText: 'Featured',
      schedule: [
        ScheduleItemModel(
          timeText: '6:30 PM',
          title: 'Artist Setup & Soundcheck',
        ),
        ScheduleItemModel(
          timeText: '7:00 PM',
          title: 'Opening Act: The Velvet Trio',
          isLiveNow: true,
        ),
        ScheduleItemModel(
          timeText: '8:30 PM',
          title: 'Main Performance: Julian Vance Quartet',
        ),
        ScheduleItemModel(timeText: '9:45 PM', title: 'Closing Jam Session'),
      ],
    ),
    const MallEventModel(
      id: 'live_piano_session',
      name: 'Live Piano Session',
      description:
          'A close-up live grand piano performance in the North Wing lobby. Sit back, relax and enjoy modern compositions.',
      category: 'Music',
      dateText: 'Today',
      timeText: '10:00 - 12:00',
      venueName: 'North Wing',
      floorText: 'First Floor',
      organizerName: 'Yamaha Music Center',
      organizerLogoUrl: '',
      remainingSeats: 12,
      entryType: 'Free',
      price: 0.0,
      interestedCount: 95,
      isBookmarked: false,
      isRegistered: false,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDDUwRMEBVrOXLHsAEm1tiqm2V5Lkmt8NpFUoq2nLKFgeC09wWw1GMRfgpdS83X9OILNZhAKuYg2J0r5djAnTO1AXi5BMyVO2GOtQWm1acjuDQxzoET64Nut-PhPQFRf6nPRFAxF1GTtdZlarlDI8cBuhkM8vu8n6drMyMOgqhEVQLJ7_ZakG4_-M-hNLJkEKXg1udRwaF7frRJcXr2okJzfIWpgOiUqHld5N_ORkc8hGh-jjhI0OI3G9aFjs7LaLpGEOeZZMBCYw',
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA', // Starbucks
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBw_UQLaQKUpsFUNpiGcD7Rmr2jSlgviSKf6H2RDqlEHQOvUw3lZkAHs_LL5Sw9aYHfqQ-d_jLwYkHGJJZ_vsmXUiTrpunXskkYmFbl0VrUZaTZQpEJKZEovQp7SSC_XgPeWw0NCqapHWEZupXbN4PLV9o0qlTAcMdPKa6HugheKaWdvL42Jz6PbPj5AQvvhTdMCuGlu_6KFvVbfxv6I6pPvArjdAeuyFlvAX1RFLpdeKaozYTWgMFZ4RldBs5v0OMBrLHsSNUl3g', // Bose
      ],
      statusText: 'Live',
      schedule: [
        ScheduleItemModel(
          timeText: '10:00 AM',
          title: 'Introductory Sonata',
          isLiveNow: true,
        ),
        ScheduleItemModel(
          timeText: '11:00 AM',
          title: 'Contemporary Piano Covers',
        ),
      ],
    ),
    const MallEventModel(
      id: 'digital_art_expo',
      name: 'Digital Art Expo',
      description:
          'Immersive abstract canvases and digital projection displays showcased at the L3 Art Hub.',
      category: 'Art',
      dateText: 'Daily',
      timeText: '10:00 - 21:00',
      venueName: 'Art Hub',
      floorText: 'Level 3',
      organizerName: 'Lumina Art Space',
      organizerLogoUrl: '',
      remainingSeats: 100,
      entryType: 'Free',
      price: 0.0,
      interestedCount: 210,
      isBookmarked: false,
      isRegistered: false,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDsz2RL-wLVJRhOt48JgRFV1Ei48YQbD4v2gDk7SUlf6Nnw4Ezv93Xk60gXJrIV-aJz-sJ5u_kjUh68WHZxkEnGYNOd5B4iDc5pO8td3muCZ7ZpwmHPWd1py8Vw3-oJMFuxByH_OQ575hBGha8VVUsMn7paHLx_TBumq81L7xxKaSNjxRLRr64o8Y-ifoYuhNPHWu6mt4iQ1Pjt61ze3vA-VBa0u_1svvSX0TMnRS-EWHJgsRgs3soHj8IL2_58nHOe-8zmYpdN8A',
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA', // Starbucks
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDtO2OvmMw5c42auvrO7vtMJwYk0sZOsvvKaAbOR6KSgIssoyxB0uoruC1cvsHRn6NYEP6A_hGspizvWQ5fKyHDHQOT6rmejUgUM6zinej7kpdrJCZIsBtXRaWrmyxhnr_masQf7WzaS8UlIdaysyuVFddFOVtYwr0pw57BTy4ltWt1G-5-qOvc8h4gqV43PXARq69DBjNWoqmWyJgXnJwAGmptEX907TB3WzQ_VQ6MP3X8rOVTCI7tc3pHzet7eFKrRa1oZDgy2A', // Apple
      ],
      statusText: 'Ongoing',
      schedule: [
        ScheduleItemModel(
          timeText: '10:00 AM',
          title: 'Morning Projection Run',
        ),
        ScheduleItemModel(
          timeText: '2:00 PM',
          title: 'Interactive VR Art Workshop',
          isLiveNow: true,
        ),
        ScheduleItemModel(
          timeText: '7:00 PM',
          title: 'Evening Digital Visuals Show',
        ),
      ],
    ),
    const MallEventModel(
      id: 'tech_expo',
      name: 'Tech Expo 2024',
      description:
          'Futuristic tech expo presenting innovative gadgets, electronics workshops and live 3D printing showcases.',
      category: 'Workshops',
      dateText: 'Jun 25',
      timeText: '09:00 - 18:00',
      venueName: 'Grand Ballroom',
      floorText: 'Level 4',
      organizerName: 'Lumina Tech Labs',
      organizerLogoUrl: '',
      remainingSeats: 30,
      entryType: 'Paid',
      price: 299.0,
      interestedCount: 520,
      isBookmarked: false,
      isRegistered: false,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCWv8BVAgqZGY1dXRkx9cTQfEl3kel2vhT28hMDGg-WpbPwFP4HMAywdswV5il-5s2Dh4FRyNc2egZ_V9ju0GgVmRiPCOIEHDwhbNpbJLSeFs3L4DxcQr3D1hpsBuoyospZyomxdAebvntTJamYoeVs2UoZDwNgSgwSUbQ5g3fmaOfhWzH7wUH-WVTclkKdIQWqdtPp7akp9GWWSeEF4-9WrJz5ZWsHeWKYESs_u6T2UjzD3uNX8MlHFfonj48i-zvR58ruQMZ3Jw',
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA', // Starbucks
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDtO2OvmMw5c42auvrO7vtMJwYk0sZOsvvKaAbOR6KSgIssoyxB0uoruC1cvsHRn6NYEP6A_hGspizvWQ5fKyHDHQOT6rmejUgUM6zinej7kpdrJCZIsBtXRaWrmyxhnr_masQf7WzaS8UlIdaysyuVFddFOVtYwr0pw57BTy4ltWt1G-5-qOvc8h4gqV43PXARq69DBjNWoqmWyJgXnJwAGmptEX907TB3WzQ_VQ6MP3X8rOVTCI7tc3pHzet7eFKrRa1oZDgy2A', // Apple
      ],
      statusText: 'Upcoming',
      schedule: [
        ScheduleItemModel(
          timeText: '9:00 AM',
          title: 'Holographic Display Launch',
        ),
        ScheduleItemModel(timeText: '11:00 AM', title: 'Smart Cities Seminar'),
        ScheduleItemModel(
          timeText: '3:00 PM',
          title: 'Interactive Coding Panel',
          isLiveNow: true,
        ),
      ],
    ),
    const MallEventModel(
      id: 'fashion_week',
      name: 'Luxury Fashion Week',
      description:
          'Supermodels on stage displaying luxury fashion couture from premier international brands.',
      category: 'Fashion',
      dateText: 'Jun 28-30',
      timeText: '18:00 - 21:00',
      venueName: 'Central Plaza',
      floorText: 'Ground Floor',
      organizerName: 'Vogue Group',
      organizerLogoUrl: '',
      remainingSeats: 80,
      entryType: 'Free',
      price: 0.0,
      interestedCount: 890,
      isBookmarked: false,
      isRegistered: false,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCdfNqImxWM0urV2hODD04S0fWDzPgxxiN-Vp0yAHDLeESiWDmItFa3zzmETfBz43mp4dFGVQABva1Ab2hTHb1vXwsX5gFDo0YNPB1to3CvtL4_jUoL8S7wAZoo7GXQP--eHvPBlEcilX6FeFwdf7J-ma8BDgBQ1xwXlfA3DBscYQJGpELwiwMYrrQre6VeClZETFVZHEA6C3SQ7mkJ9dJq2Uz12ju7xsbkCwLS2RGH58XuZH7NSzFB1ZjJvHmozl-xw1xRXgP0aQ',
      galleryUrls: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBCYIM1ppxCS4vwadNNtP8fwK4mq4ih5zETwKxg-bDb-slNKpJN8ob0Mu4FbOLcLwB34o83GCaZ4cSFdtsl-BYyrDBRs-X_NsRb6VjAN7E6fLTgJml65815XqUS9KYvkeoLGzQ2vedXUJQbjV-JvDKAIJIRAOVuK9CF45CzVxs5Uks4OEm95GTkqWMAPHT0qYiWL0y5iqQIPC0Z208W0i2t2GZxreUQiVG5jill18NbD6T2ZDzVJsLwu7BR6OKjXLnfwY7vqCLYiA', // Starbucks
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBw_UQLaQKUpsFUNpiGcD7Rmr2jSlgviSKf6H2RDqlEHQOvUw3lZkAHs_LL5Sw9aYHfqQ-d_jLwYkHGJJZ_vsmXUiTrpunXskkYmFbl0VrUZaTZQpEJKZEovQp7SSC_XgPeWw0NCqapHWEZupXbN4PLV9o0qlTAcMdPKa6HugheKaWdvL42Jz6PbPj5AQvvhTdMCuGlu_6KFvVbfxv6I6pPvArjdAeuyFlvAX1RFLpdeKaozYTWgMFZ4RldBs5v0OMBrLHsSNUl3g', // Bose
      ],
      statusText: 'Upcoming',
      schedule: [
        ScheduleItemModel(
          timeText: '6:00 PM',
          title: 'Designer Red Carpet Intro',
        ),
        ScheduleItemModel(
          timeText: '7:30 PM',
          title: 'Spring Collection Showcase',
          isLiveNow: true,
        ),
        ScheduleItemModel(
          timeText: '9:00 PM',
          title: 'Afterparty Networking & VIP Meetup',
        ),
      ],
    ),
  ];

  @override
  Future<DiscoverDataModel> getDiscoverData() async {
    // Simulated short delay for loaded transitions
    await Future.delayed(const Duration(milliseconds: 300));

    return const DiscoverDataModel(
      categories: [
        DiscoverCategoryModel(
          id: 'stores',
          title: 'Stores',
          iconName: 'shopping_bag',
          colorHex: '0xFF6100D6',
          bgHex: '0x1A6100D6',
        ),
        DiscoverCategoryModel(
          id: 'brands',
          title: 'Brands',
          iconName: 'sell',
          colorHex: '0xFF0058BE',
          bgHex: '0x1A0058BE',
        ),
        DiscoverCategoryModel(
          id: 'products',
          title: 'Products',
          iconName: 'inventory_2',
          colorHex: '0xFF813800',
          bgHex: '0x1A813800',
        ),
        DiscoverCategoryModel(
          id: 'categories',
          title: 'Categories',
          iconName: 'category',
          colorHex: '0xFF7B2FF7',
          bgHex: '0x337B2FF7',
        ),
        DiscoverCategoryModel(
          id: 'dining',
          title: 'Dining',
          iconName: 'restaurant',
          colorHex: '0xFFBA1A1A',
          bgHex: '0x40FFDAD6',
        ),
        DiscoverCategoryModel(
          id: 'theatres',
          title: 'Theatres',
          iconName: 'movie',
          colorHex: '0xFF2170E4',
          bgHex: '0x332170E4',
        ),
        DiscoverCategoryModel(
          id: 'events',
          title: 'Events',
          iconName: 'event',
          colorHex: '0xFF813800',
          bgHex: '0x33FFB68E',
        ),
        DiscoverCategoryModel(
          id: 'more',
          title: 'More',
          iconName: 'grid_view',
          colorHex: '0xFF7B7488',
          bgHex: '0xFFEDE5F5',
        ),
      ],
      popularStores: [
        DiscoverStoreModel(
          id: 'zudio',
          name: 'Zudio',
          category: 'Fashion & Apparel',
          floorText: 'Ground Floor',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC95VysISiF9kFAC1V2Fj4pc4DlQqIQ_TWNAtCHPfczBV2Vy5EetcltVzqabEg14BAJ2CiTA8oamYxIuzmAPONiHxtrNccdLWzUpKOeHvE4o2CyEKU6LAK4r5y6VaZDvg-PjckmkWQcyKV2JCZS9omOpqiOxe6vNJq-N8EMGoOtgVPgBqvYHJU3i-k7Z9CzPyytkQfPL3pyl2gmUbmElcAu1T_AkdLMOs-NkFooyK8kOF7JXbDL0yw2aC9CrSb8rJLYRY8VnT094Q',
          rating: 4.5,
        ),
        DiscoverStoreModel(
          id: 'reliance_digital',
          name: 'Reliance Digital',
          category: 'Electronics',
          floorText: 'First Floor',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBW3BRWLFuIbphtissVB_xTnrKaED493nByn7vk90xaEr_9teOe4aGoWlv0i8PKTvqwcerrDgYVOhUjjdEcdotr8BgJ9_OKMTxMqkjiRIK7SOfNI3mjnAoITUfrchxNOeoeAyVNe9GsCo-vVpE9PXrFbx3ODWGUo8dxRbXzdpeOHOhxoII64hZkKdkdSqBr_4x8j38mafpwxqQ2B-8btwCPqqWnF8QAh_FAn0t3RV6YZMZczIJNKKIhIr2F66KtvjLtUUB6_BAkmg',
          rating: 4.8,
        ),
      ],
      trendingDining: [
        DiscoverRestaurantModel(
          id: 'starbucks',
          name: 'Starbucks',
          cuisine: 'Cafe',
          floorText: '1st Floor',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuB4hxkz6PR4EADIVev0ohhgL2rxyir5R-KlgXwg8ZKQIHKZ9zlqBxyxfV2rzRvjoOQrM_BHX5hphCvKZ1He2590SzOnt0woqBWO4nbRHXbZOpq9zjbrJc61SUcVzeOR69EYc9JE3SSn2iNY0YZE-w19EMwQiYl9MFYrfE0dNrjIdzhD67FS1efL52KyzZcdoX1DjqsOLXWrule0ztQXs_IgOPyt4OMZnh16MKILGOXa0XDVyAd6sAyh39m1a15SbGAlAjLzqQENpw',
          rating: 4.7,
          waitTimeText: '',
          walkTimeText: 'Walk: 3 mins from here',
          isOpen: true,
        ),
        DiscoverRestaurantModel(
          id: 'sushiro',
          name: 'Sushiro',
          cuisine: 'Japanese',
          floorText: '3rd Floor',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAtPn-3MKTJWh7jVx13_W79SvM6Nri1rJ_0gDf-vbdqo5ixwL3dgYXgMmeVNyA2SOXuacuan5p5AQ3UPyslnSzHeGFCl9V9C8jXNF5cwFrW4lttcG61cMoEDAz575UBP6jKIgLPi16cIyiXd8_W9s-8iZvIbhJ6s46OiHxJP6Wu_7-ZUmgTNHk6OSyehMg5kncKl5BHBKonO6CLJmZUTVzTn71t-9oC3PWv_S8qTZ2xUwNSoc0f3PyKxPfi0M-lH6vboUWlcFDfxg',
          rating: 4.9,
          waitTimeText: 'Wait: 15 mins',
          walkTimeText: '',
          isOpen: true,
        ),
      ],
      amenities: [
        DiscoverAmenityModel(
          id: 'restroom',
          title: 'Restroom',
          iconName: 'wc',
          distanceText: '1 min away',
        ),
        DiscoverAmenityModel(
          id: 'atm',
          title: 'ATM',
          iconName: 'atm',
          distanceText: '2 min away',
        ),
        DiscoverAmenityModel(
          id: 'lift',
          title: 'Lift',
          iconName: 'elevator',
          distanceText: '1 min away',
        ),
        DiscoverAmenityModel(
          id: 'escalator',
          title: 'Escalator',
          iconName: 'stairs',
          distanceText: '2 min away',
        ),
      ],
      popularTheatres: [
        DiscoverTheatreModel(
          id: 'movie_spiderman',
          title: 'Spider-Man: Beyond the Spider-Verse',
          cinemaName: 'PVR INOX, Floor 4',
          imageUrl:
              'https://images.unsplash.com/photo-1635805737707-575885ab0820?auto=format&fit=crop&w=400&q=80',
        ),
        DiscoverTheatreModel(
          id: 'movie_avatar',
          title: 'Avatar: Fire and Ash',
          cinemaName: 'PVR INOX, Floor 4',
          imageUrl:
              'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&w=400&q=80',
        ),
      ],
    );
  }

  @override
  Future<List<MallEventEntity>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _events;
  }

  @override
  Future<void> toggleBookmarkEvent(String id) async {
    final idx = _events.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _events[idx];
      _events[idx] = current.copyWith(isBookmarked: !current.isBookmarked);
    }
  }

  @override
  Future<void> registerForEvent(String id) async {
    final idx = _events.indexWhere((e) => e.id == id);
    if (idx != -1) {
      final current = _events[idx];
      _events[idx] = current.copyWith(
        isRegistered: true,
        interestedCount: current.interestedCount + 1,
        remainingSeats: current.remainingSeats > 0
            ? current.remainingSeats - 1
            : 0,
      );
    }
  }
}
