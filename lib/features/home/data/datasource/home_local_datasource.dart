import '../models/home_models.dart';

abstract class HomeLocalDataSource {
  Future<HomeDataModel> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    // Simulate minor delay for realistic load screen testing
    await Future.delayed(const Duration(milliseconds: 500));

    return const HomeDataModel(
      visitor: VisitorModel(
        name: 'Diravia',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC4wUtJ_rIEKjLBrk_1kCSaLYLKn0sq3HXYVsAXF5g3DEtXHvQZTscemhdTopEylFdtV_oXtC_eZxsC6IfG5um-9_KnopJ-AB_tzZMHrKVKYJpWOOcEVT5LsFEChfuR7xpl4QOwqe-gdc6KCYcmtWX6c50eFlWI_E5bttifHxvTDsi5I_3uXivfJATU29fVf66NEoBP8aGm_WYgPOoAPfKafZkhB79zQHCttsVSbDqLSFymYcfnMryEsXukJDi_xjK6_3j7Bjcu7g',
      ),
      mall: MallModel(
        name: 'Phoenix Grand Mall',
        floor: 'Floor 2',
        isOpen: true,
        openTimeText: 'Open Now • 10 PM',
        mapImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBj0sD9PNp0NDbJecsdDIquWk1JmCld-dgdTubQeQfqzKsJVd3b6x6tW87FE-OT4-nXMsvFocOmocatzJWhQOX_MnwCZt1ipZU_A0zj9gFd8h812qYnjA30Qmz3vwXyoBLkmkM_v7iNS2dRKaU0dnQSr86oLOnxsQLKTv5s6bOstPO0QzJjfLQhc24EdMTj4K6bKnNPW7OBW6PXwxL_iEHuFycWLYAgadvdJ_UzEOKfUD08gleJFWvrdmOC5Sb2e7fY3HgEQ1u7ew',
      ),
      quickActions: [
        QuickActionModel(
          id: 'navigate',
          title: 'Navigate',
          iconName: 'near_me',
          colorHex: '0xFF3B82F6',
        ),
        QuickActionModel(
          id: 'stores',
          title: 'Stores',
          iconName: 'shopping_bag',
          colorHex: '0xFFEF4444',
        ),
        QuickActionModel(
          id: 'dining',
          title: 'Dining',
          iconName: 'restaurant',
          colorHex: '0xFF374151',
        ),
        QuickActionModel(
          id: 'parking',
          title: 'Parking',
          iconName: 'local_parking',
          colorHex: '0xFF6100D6',
        ),
        QuickActionModel(
          id: 'washroom',
          title: 'Washroom',
          iconName: 'wc',
          colorHex: '0xFF9333EA',
        ),
        QuickActionModel(
          id: 'offers',
          title: 'Offers',
          iconName: 'sell',
          colorHex: '0xFFBA1A1A',
        ),
        QuickActionModel(
          id: 'points',
          title: 'Points',
          iconName: 'qr_code_2',
          colorHex: '0xFFF59E0B',
        ),
        QuickActionModel(
          id: 'sos',
          title: 'SOS',
          iconName: 'medical_services',
          colorHex: '0xFFDC2626',
        ),
      ],
      amenities: [
        AmenityModel(
          id: 'atm',
          title: 'ATM',
          iconName: 'atm',
          distanceText: '2 min away',
        ),
        AmenityModel(
          id: 'washroom',
          title: 'Washroom',
          iconName: 'wc',
          distanceText: '1 min away',
        ),
        AmenityModel(
          id: 'helpdesk',
          title: 'Help Desk',
          iconName: 'support_agent',
          distanceText: '1 min away',
        ),
        AmenityModel(
          id: 'lift',
          title: 'Lift',
          iconName: 'elevator',
          distanceText: '1 min away',
        ),
      ],
      offers: [
        OfferModel(
          id: 'zara_40',
          storeName: 'Zara',
          storeLogoUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCCtKo5suc1YQAkduRCkDpywrMF-To7bOm-BRkf0RLocBD7GguEb6pygKTVwDdQ8PCxaxbiUxOV4AeCZQd1romSbs6rnyuqji0-axPzA8xBvws6B_joHOmkCCo7y2qCpVeCUzHlXR0dXoIVdwVR2bprE085MfUbgGGVmTLvvXnC8GyrddXBHCFKTunvlDTE3S643eH5vKNANgCK8AASc9UO-59sMB2hRLYdu51unnK1ceOk67bWH0FOfYtw8ajdDvk8R91yWTa7qw',
          title: 'Flat 40% Off',
          subtitle: 'On Selected Items',
          distanceText: '2.1 km',
        ),
        OfferModel(
          id: 'max_buy2',
          storeName: 'Max',
          storeLogoUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuALU8fsPcQXB5je5FkGyJ7ZtWTHx_EABZEUOPlyy4kawjFHZTH5wV71Bs0ayH3UZeZZpr2UZHzNRUqGHjiZ6qCNia16t3lr1LO4BqUAKuOgCdSEOmOXmKVXJwDo0XNr8w1Cc2vFRS8jSsFwhbttOw-OvHdRkl53XLD4NZV5TyDlj_6TRI667uWBGZSWs-LxEOGjbDBRPAe50yt8xx069yVpwweZbXfARrk-RzQ43P527NvN4nRWvPssEphFQNIwFPEuhArumN3FFg',
          title: 'Buy 2 Get 1 Free',
          subtitle: 'On Fashion',
          distanceText: '1.8 km',
        ),
      ],
      events: [
        EventModel(
          id: 'summer_carnival',
          title: 'Summer Carnival',
          subtitle: 'Kids Activities, Games & More',
          dateText: '25 May - 2 June',
          locationText: 'Atrium Area',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAC5hfz562kxj2KNaSGNw3kQgklkvwwZz8lFpYXN9AmDp7U-a83o1TY15BTgcT58P1JGNoOruaGoouULDCLN5rPFCWX5vwv-ym4mc-UfKa4fOu2PVZoonADjQddqtmNGwZgwlV5-O1SOr8_FWmGYkh4vqt1GdonqqdTkkK9kvQIvIYKpYWQAmR1MmbZfkgSuPG58W5aBCi-Tz7lPFgob8sw52CH1P01tlSrR-HNZT7IAf7QPD5a02ZQPDOAsICqy5bLNxKtCbBL2Q',
        ),
      ],
      restaurants: [
        RestaurantModel(
          id: 'barbeque_nation',
          name: 'Barbeque Nation',
          cuisine: 'North Indian',
          waitTimeMinutes: 15,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAmOthNkdbfGs7IJr0I9-EYHqviuFVaGh0PIVndv7gup9EG-3eTNwXVJ6QLKMXcvrJNccUFv17jWHpd7zyOFcp6NcdsQEZEuqRKdPLPAhwxK4MmTjTAooq6e_cx1-hwvz_JfrHiukKSF-i87UYsjkx9UOILP9B_MNT08E4p_Y5J3DJPZniiUNukLOWsMRRX4Vn8k7aoPNwiaE6DK0U09vUTZS3AekfJQSZYsSkBpfhuqffpO9aMwdZuJ3CVeosPOK4Gn0D8yCGOfw',
        ),
        RestaurantModel(
          id: 'mainland_china',
          name: 'Mainland China',
          cuisine: 'Chinese',
          waitTimeMinutes: 10,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD_HS-TW0amyED6zFeAOqcauBCbRclulpwBtXs0RQzjrYJa-6N6opqETcGWwSBwkhpUDrjv6BOGKUQZ5Xq8ywi-Cm4d5aQjfcfuVst_c6UUdNai-jO-vBkgu6i18J5zxgTA3TzOo6-rpv_gcCr6ZP_qbrsuxUT2h-FSx32UkIHeJOclWeZZ3DnNJ5zWrLLg85qTTKB2fq8_q7HSj1M0di6MNjzommEPHCNLtyzvSaBV2987FljQvXipL1O9HtHQnL2C1Ioyu6D9ug',
        ),
      ],
      parkingLevels: [
        ParkingLevelModel(
          id: 'p1',
          levelName: 'P1',
          availableSpots: 120,
          isFull: false,
        ),
        ParkingLevelModel(
          id: 'p2',
          levelName: 'P2',
          availableSpots: 45,
          isFull: false,
        ),
        ParkingLevelModel(
          id: 'p3',
          levelName: 'P3',
          availableSpots: 8,
          isFull: false,
        ),
        ParkingLevelModel(
          id: 'p4',
          levelName: 'P4',
          availableSpots: 0,
          isFull: true,
        ),
      ],
      emergency: EmergencyShortcutModel(
        title: 'Emergency?',
        subtitle: 'We\'re here to help',
      ),
    );
  }
}
