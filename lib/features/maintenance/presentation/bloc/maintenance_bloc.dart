import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/data/datasource/profile_local_datasource.dart';
import '../../domain/entities/maintenance_entities.dart';
import '../../domain/usecases/maintenance_usecases.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final LoadReportsUseCase loadReportsUseCase;
  final SubmitIssueUseCase submitIssueUseCase;
  final GetTicketUseCase getTicketUseCase;

  MaintenanceBloc({
    required this.loadReportsUseCase,
    required this.submitIssueUseCase,
    required this.getTicketUseCase,
  }) : super(const MaintenanceInitial()) {
    on<LoadMaintenance>(_onLoadMaintenance);
    on<LoadReports>(_onLoadReports);
    on<SelectCategory>(_onSelectCategory);
    on<UpdateIssueTitle>(_onUpdateIssueTitle);
    on<UpdateDescription>(_onUpdateDescription);
    on<UpdatePriority>(_onUpdatePriority);
    on<AttachPhoto>(_onAttachPhoto);
    on<RemovePhoto>(_onRemovePhoto);
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<SubmitIssue>(_onSubmitIssue);
    on<LoadTicket>(_onLoadTicket);
    on<RefreshTicket>(_onRefreshTicket);
  }

  void _onLoadMaintenance(
    LoadMaintenance event,
    Emitter<MaintenanceState> emit,
  ) {
    emit(const MaintenanceLoaded());
  }

  Future<void> _onLoadReports(
    LoadReports event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(const MaintenanceLoading());
    try {
      // Check auth status from the Profile datasource
      final authDataSource = ProfileLocalDataSourceImpl();
      final isLoggedIn = await authDataSource.checkAuthStatus();

      if (!isLoggedIn) {
        emit(const GuestMaintenanceState());
      } else {
        final reportsList = await loadReportsUseCase();
        emit(LoggedInMaintenanceState(reports: reportsList));
      }
    } catch (e) {
      emit(MaintenanceError(errorMessage: e.toString()));
    }
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(category: event.category));
    }
  }

  void _onUpdateIssueTitle(
    UpdateIssueTitle event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(title: event.title));
    }
  }

  void _onUpdateDescription(
    UpdateDescription event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(description: event.description));
    }
  }

  void _onUpdatePriority(
    UpdatePriority event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(priority: event.priority));
    }
  }

  void _onAttachPhoto(
    AttachPhoto event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(photoPath: event.photoPath));
    }
  }

  void _onRemovePhoto(
    RemovePhoto event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(photoPath: null));
    }
  }

  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocation event,
    Emitter<MaintenanceState> emit,
  ) async {
    if (state is MaintenanceLoaded) {
      final s = state as MaintenanceLoaded;
      emit(s.copyWith(locationStatus: 'Locating...'));
      await Future.delayed(const Duration(milliseconds: 600));
      emit(s.copyWith(
        locationStatus: 'Auto Detected',
        location: 'LuxeMall • 2nd Floor • North Wing',
        floor: '2nd Floor',
        nearestLandmark: 'Prada Flagship Store',
      ));
    }
  }

  Future<void> _onSubmitIssue(
    SubmitIssue event,
    Emitter<MaintenanceState> emit,
  ) async {
    if (state is MaintenanceLoaded) {
      final form = state as MaintenanceLoaded;
      if (form.category.isEmpty || form.title.isEmpty || form.description.isEmpty) {
        emit(const MaintenanceError(errorMessage: 'Please fill in all required fields.'));
        emit(form); // restore form state
        return;
      }

      emit(const SubmittingIssue());
      try {
        final randDigits = Random().nextInt(900000) + 100000;
        final ticketId = 'MT-2026-$randDigits';

        final newIssue = MaintenanceReportEntity(
          ticketId: ticketId,
          category: form.category,
          title: form.title,
          description: form.description,
          location: form.location,
          floor: form.floor,
          nearestLandmark: form.nearestLandmark,
          priority: form.priority,
          status: 'Submitted',
          assignedTeam: _getAssignedTeam(form.category),
          estimatedFixTime: _getEstimatedFixTime(form.priority),
          createdTime: DateTime.now(),
          photoUrl: form.photoPath,
        );

        final submittedTicket = await submitIssueUseCase(newIssue);
        emit(IssueSubmitted(ticket: submittedTicket));
      } catch (e) {
        emit(MaintenanceError(errorMessage: e.toString()));
        emit(form); // restore form state
      }
    }
  }

  Future<void> _onLoadTicket(
    LoadTicket event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(const MaintenanceLoading());
    try {
      final ticket = await getTicketUseCase(event.ticketId);
      emit(TicketLoaded(ticket: ticket));
    } catch (e) {
      emit(MaintenanceError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshTicket(
    RefreshTicket event,
    Emitter<MaintenanceState> emit,
  ) async {
    try {
      final ticket = await getTicketUseCase(event.ticketId);
      emit(TicketLoaded(ticket: ticket));
    } catch (e) {
      emit(MaintenanceError(errorMessage: e.toString()));
    }
  }

  String _getAssignedTeam(String category) {
    switch (category) {
      case 'Cleaning':
        return 'Janitorial Team B';
      case 'Lighting':
      case 'Electrical':
        return 'Electrical Services';
      case 'Escalator':
      case 'Elevator':
        return 'Mechanical Elevator Team';
      case 'Water Leakage':
      case 'Restroom':
        return 'Plumbing Department';
      case 'Air Conditioning':
        return 'HVAC Team C';
      default:
        return 'Facility Operations';
    }
  }

  String _getEstimatedFixTime(String priority) {
    switch (priority) {
      case 'Urgent':
        return '30 Mins';
      case 'High':
        return '2 Hours';
      case 'Medium':
        return '12 Hours';
      default:
        return '24 Hours';
    }
  }
}
