import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(const HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final homeData = await getHomeData();
      emit(HomeLoaded(homeData: homeData));
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final homeData = await getHomeData();
      emit(HomeLoaded(homeData: homeData));
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }
}
