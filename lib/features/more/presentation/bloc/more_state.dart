import 'package:flutter/foundation.dart';
import '../../domain/entities/more_entities.dart';

@immutable
abstract class MoreState {
  const MoreState();
}

class MoreInitial extends MoreState {
  const MoreInitial();
}

class MoreLoading extends MoreState {
  const MoreLoading();
}

class MoreDataLoaded extends MoreState {
  final UserProfileEntity userProfile;
  final List<QuickActionEntity> quickActions;
  final List<MallServiceEntity> mallServices;
  final List<PopularServiceEntity> popularServices;
  final bool notificationsEnabled;
  final String selectedLanguage;
  final String selectedTheme;
  final bool feedbackSubmitted;

  const MoreDataLoaded({
    required this.userProfile,
    required this.quickActions,
    required this.mallServices,
    required this.popularServices,
    required this.notificationsEnabled,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.feedbackSubmitted,
  });

  MoreDataLoaded copyWith({
    UserProfileEntity? userProfile,
    List<QuickActionEntity>? quickActions,
    List<MallServiceEntity>? mallServices,
    List<PopularServiceEntity>? popularServices,
    bool? notificationsEnabled,
    String? selectedLanguage,
    String? selectedTheme,
    bool? feedbackSubmitted,
  }) {
    return MoreDataLoaded(
      userProfile: userProfile ?? this.userProfile,
      quickActions: quickActions ?? this.quickActions,
      mallServices: mallServices ?? this.mallServices,
      popularServices: popularServices ?? this.popularServices,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      feedbackSubmitted: feedbackSubmitted ?? this.feedbackSubmitted,
    );
  }
}

class ParkingDetailsLoaded extends MoreState {
  final List<ParkingFloorEntity> parkingFloors;
  const ParkingDetailsLoaded({required this.parkingFloors});
}

class AmenitiesDetailsLoaded extends MoreState {
  final List<AmenityItemEntity> amenities;
  const AmenitiesDetailsLoaded({required this.amenities});
}

class MoreError extends MoreState {
  final String message;
  const MoreError({required this.message});
}
