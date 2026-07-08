import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_more_data.dart';
import 'more_event.dart';
import 'more_state.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final GetQuickActionsUseCase getQuickActionsUseCase;
  final GetMallServicesUseCase getMallServicesUseCase;
  final GetPopularServicesUseCase getPopularServicesUseCase;
  final GetParkingFloorsUseCase getParkingFloorsUseCase;
  final GetAmenitiesUseCase getAmenitiesUseCase;
  final SubmitFeedbackUseCase submitFeedbackUseCase;

  MoreBloc({
    required this.getUserProfileUseCase,
    required this.getQuickActionsUseCase,
    required this.getMallServicesUseCase,
    required this.getPopularServicesUseCase,
    required this.getParkingFloorsUseCase,
    required this.getAmenitiesUseCase,
    required this.submitFeedbackUseCase,
  }) : super(const MoreInitial()) {
    on<LoadMoreData>(_onLoadMoreData);
    on<RefreshMoreData>(_onRefreshMoreData);
    on<LoadParkingData>(_onLoadParkingData);
    on<LoadAmenitiesData>(_onLoadAmenitiesData);
    on<ToggleNotificationSetting>(_onToggleNotificationSetting);
    on<ChangeAppLanguage>(_onAppLanguageChanged);
    on<ChangeAppTheme>(_onAppThemeChanged);
    on<SubmitUserFeedback>(_onFeedbackSubmitted);
  }

  Future<void> _onLoadMoreData(LoadMoreData event, Emitter<MoreState> emit) async {
    emit(const MoreLoading());
    try {
      final profile = await getUserProfileUseCase();
      final quickActions = await getQuickActionsUseCase();
      final mallServices = await getMallServicesUseCase();
      final popularServices = await getPopularServicesUseCase();

      emit(MoreDataLoaded(
        userProfile: profile,
        quickActions: quickActions,
        mallServices: mallServices,
        popularServices: popularServices,
        notificationsEnabled: true,
        selectedLanguage: 'English',
        selectedTheme: 'System',
        feedbackSubmitted: false,
      ));
    } catch (e) {
      emit(MoreError(message: e.toString()));
    }
  }

  Future<void> _onRefreshMoreData(RefreshMoreData event, Emitter<MoreState> emit) async {
    final currentState = state;
    if (currentState is MoreDataLoaded) {
      try {
        final profile = await getUserProfileUseCase();
        emit(currentState.copyWith(userProfile: profile));
      } catch (e) {
        emit(MoreError(message: e.toString()));
      }
    } else {
      add(const LoadMoreData());
    }
  }

  Future<void> _onLoadParkingData(LoadParkingData event, Emitter<MoreState> emit) async {
    emit(const MoreLoading());
    try {
      final floors = await getParkingFloorsUseCase();
      emit(ParkingDetailsLoaded(parkingFloors: floors));
    } catch (e) {
      emit(MoreError(message: e.toString()));
    }
  }

  Future<void> _onLoadAmenitiesData(LoadAmenitiesData event, Emitter<MoreState> emit) async {
    emit(const MoreLoading());
    try {
      final amenities = await getAmenitiesUseCase();
      emit(AmenitiesDetailsLoaded(amenities: amenities));
    } catch (e) {
      emit(MoreError(message: e.toString()));
    }
  }

  void _onToggleNotificationSetting(ToggleNotificationSetting event, Emitter<MoreState> emit) {
    final currentState = state;
    if (currentState is MoreDataLoaded) {
      emit(currentState.copyWith(notificationsEnabled: event.isEnabled));
    }
  }

  void _onAppLanguageChanged(ChangeAppLanguage event, Emitter<MoreState> emit) {
    final currentState = state;
    if (currentState is MoreDataLoaded) {
      emit(currentState.copyWith(selectedLanguage: event.language));
    }
  }

  void _onAppThemeChanged(ChangeAppTheme event, Emitter<MoreState> emit) {
    final currentState = state;
    if (currentState is MoreDataLoaded) {
      emit(currentState.copyWith(selectedTheme: event.themeMode));
    }
  }

  Future<void> _onFeedbackSubmitted(SubmitUserFeedback event, Emitter<MoreState> emit) async {
    final currentState = state;
    if (currentState is MoreDataLoaded) {
      emit(const MoreLoading());
      try {
        await submitFeedbackUseCase(event.rating, event.comments);
        final profile = await getUserProfileUseCase();
        final quickActions = await getQuickActionsUseCase();
        final mallServices = await getMallServicesUseCase();
        final popularServices = await getPopularServicesUseCase();

        emit(MoreDataLoaded(
          userProfile: profile,
          quickActions: quickActions,
          mallServices: mallServices,
          popularServices: popularServices,
          notificationsEnabled: currentState.notificationsEnabled,
          selectedLanguage: currentState.selectedLanguage,
          selectedTheme: currentState.selectedTheme,
          feedbackSubmitted: true,
        ));
      } catch (e) {
        emit(MoreError(message: e.toString()));
      }
    }
  }
}
