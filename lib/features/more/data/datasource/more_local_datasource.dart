import '../../domain/entities/more_entities.dart';
import '../models/more_models.dart';

abstract class MoreLocalDataSource {
  Future<UserProfileEntity> getUserProfile();
  Future<List<QuickActionEntity>> getQuickActions();
  Future<List<MallServiceEntity>> getMallServices();
  Future<List<PopularServiceEntity>> getPopularServices();
  Future<List<ParkingFloorEntity>> getParkingFloors();
  Future<List<AmenityItemEntity>> getAmenities();
  Future<void> submitFeedback(String rating, String comments);
}

class MoreLocalDataSourceImpl implements MoreLocalDataSource {
  static UserProfileEntity _profile = const UserProfileModel(
    name: 'Charlotte Bennett',
    phone: '+1 (555) 019-2834',
    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCMP8Fhio9bpJhWr4in9tUOg-qV7MzIpjA4XnIywVe_nRYQLIuxPy0Q51m6xzIFoa5sxtZzcOoVL_ehBfJwM76PQa7H160NoQxDqCRTNvI8XzoV0jZJDSJmfSYS-OwZfHTKIfTlO-YrsFo5NmJ0mvquyQQGPcLnSh7G53HwHcx8ZU3lmYR72D2sjNJxpAQ34iRWXMELtc7NsDLjs5VVNeJxP7vmpkOziZVEW2l35R7diiDMO-njG-WYK3td1nYiEGSg_SIzjlwzag',
    membershipStatus: 'Premium Member',
    points: 2450,
  );

  static final List<QuickActionEntity> _quickActions = [
    const QuickActionModel(
      id: 'navigate_parking',
      title: 'Navigate to Parking',
      description: 'Find your spot in Level B2',
      iconName: 'local_parking',
      type: 'parking',
    ),
    const QuickActionModel(
      id: 'find_atm',
      title: 'Find ATM',
      description: '4 locations nearby',
      iconName: 'atm',
      type: 'atm',
    ),
    const QuickActionModel(
      id: 'emergency',
      title: 'Emergency Assistance',
      description: 'Connect with security immediately',
      iconName: 'emergency_share',
      type: 'emergency',
    ),
  ];

  static final List<MallServiceEntity> _mallServices = [
    const MallServiceModel(
      id: 'directory',
      title: 'Mall Directory',
      description: 'Explore 500+ premium brands',
      iconName: 'map',
    ),
    const MallServiceModel(
      id: 'parking_availability',
      title: 'Parking',
      description: 'Real-time availability',
      iconName: 'local_parking',
    ),
    const MallServiceModel(
      id: 'amenities_dir',
      title: 'Amenities',
      description: 'Lounge & restrooms',
      iconName: 'wash',
    ),
    const MallServiceModel(
      id: 'offers_hub',
      title: 'Offers',
      description: 'Exclusive discounts',
      iconName: 'sell',
    ),
    const MallServiceModel(
      id: 'gift_cards',
      title: 'Gift Cards',
      description: 'Give the gift of choice',
      iconName: 'card_giftcard',
    ),
  ];

  static final List<PopularServiceEntity> _popularServices = [
    const PopularServiceModel(
      id: 'wifi',
      title: 'Free Wi-Fi',
      description: 'Connect Now',
      iconName: 'wifi',
    ),
    const PopularServiceModel(
      id: 'stroller',
      title: 'Stroller Hire',
      description: 'Level 1, Desk A',
      iconName: 'child_care',
    ),
    const PopularServiceModel(
      id: 'ev_charge',
      title: 'EV Charging',
      description: 'B1 Parking Area',
      iconName: 'electric_car',
    ),
    const PopularServiceModel(
      id: 'cloakroom',
      title: 'Cloakroom',
      description: 'Main Entrance',
      iconName: 'luggage',
    ),
  ];

  static final List<ParkingFloorEntity> _parkingFloors = [
    const ParkingFloorModel(
      level: 'Level 1',
      totalSlots: 100,
      occupiedSlots: 65,
      status: 'Available',
    ),
    const ParkingFloorModel(
      level: 'Level 2',
      totalSlots: 100,
      occupiedSlots: 90,
      status: 'Filling Fast',
    ),
    const ParkingFloorModel(
      level: 'Level 3',
      totalSlots: 100,
      occupiedSlots: 100,
      status: 'Full',
    ),
  ];

  static final List<AmenityItemEntity> _amenities = [
    const AmenityItemModel(
      id: 'washrooms_l1',
      title: 'Washrooms',
      description: 'Clean and accessible facilities located throughout the mall.',
      locationText: 'Level 1, Near Entrance A',
      status: 'Open',
      iconName: 'wc',
    ),
    const AmenityItemModel(
      id: 'atms_l1',
      title: 'ATMs',
      description: 'Major bank ATMs for all your transactional needs.',
      locationText: 'Ground Floor, Central Wing',
      status: '24/7 Access',
      iconName: 'atm',
    ),
    const AmenityItemModel(
      id: 'lounge_l2',
      title: 'Rest Lounges',
      description: 'Sophisticated quiet spaces to rest during shopping sessions.',
      locationText: 'Level 2, North Wing',
      status: 'Open',
      iconName: 'chair',
    ),
    const AmenityItemModel(
      id: 'info_desk',
      title: 'Information Desk',
      description: 'Get directions, mall guides, stroller hires, or physical assistance.',
      locationText: 'Ground Floor, Main Atrium',
      status: 'Open',
      iconName: 'info',
    ),
  ];

  @override
  Future<UserProfileEntity> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _profile;
  }

  @override
  Future<List<QuickActionEntity>> getQuickActions() async {
    return _quickActions;
  }

  @override
  Future<List<MallServiceEntity>> getMallServices() async {
    return _mallServices;
  }

  @override
  Future<List<PopularServiceEntity>> getPopularServices() async {
    return _popularServices;
  }

  @override
  Future<List<ParkingFloorEntity>> getParkingFloors() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _parkingFloors;
  }

  @override
  Future<List<AmenityItemEntity>> getAmenities() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _amenities;
  }

  @override
  Future<void> submitFeedback(String rating, String comments) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Simulated print save
  }
}
