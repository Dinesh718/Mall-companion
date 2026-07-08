import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/emergency_usecases.dart';
import 'emergency_event.dart';
import 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final LoadEmergencyFacilitiesUseCase loadEmergencyFacilitiesUseCase;
  final LoadEmergencyContactsUseCase loadEmergencyContactsUseCase;
  final StartEmergencyNavigationUseCase startEmergencyNavigationUseCase;
  final SendSOSUseCase sendSOSUseCase;
  final NotifySecurityUseCase notifySecurityUseCase;
  final LoadInstructionsUseCase loadInstructionsUseCase;

  EmergencyBloc({
    required this.loadEmergencyFacilitiesUseCase,
    required this.loadEmergencyContactsUseCase,
    required this.startEmergencyNavigationUseCase,
    required this.sendSOSUseCase,
    required this.notifySecurityUseCase,
    required this.loadInstructionsUseCase,
  }) : super(const EmergencyInitial()) {
    on<LoadEmergencyHub>(_onLoadEmergencyHub);
    on<LoadNearbyEmergencyFacilities>(_onLoadNearbyEmergencyFacilities);
    on<OpenEmergencyNavigation>(_onOpenEmergencyNavigation);
    on<StartEmergencyNavigation>(_onStartEmergencyNavigation);
    on<OpenSOS>(_onOpenSOS);
    on<NotifySecurity>(_onNotifySecurity);
    on<CallSecurity>(_onCallSecurity);
    on<LoadEmergencyContacts>(_onLoadEmergencyContacts);
    on<OpenFirstAid>(_onOpenFirstAid);
    on<OpenFireExit>(_onOpenFireExit);
    on<OpenHelpDesk>(_onOpenHelpDesk);
    on<OpenLostChildAssistance>(_onOpenLostChildAssistance);
    on<OpenEmergencyExit>(_onOpenEmergencyExit);
    on<OpenEmergencyInstructions>(_onOpenEmergencyInstructions);
    on<RefreshEmergencyData>(_onRefreshEmergencyData);
  }

  Future<void> _onLoadEmergencyHub(
    LoadEmergencyHub event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const EmergencyLoading());
    try {
      final facilities = await loadEmergencyFacilitiesUseCase();
      final contacts = await loadEmergencyContactsUseCase();
      final instructions = await loadInstructionsUseCase();
      emit(EmergencyLoaded(
        facilities: facilities,
        contacts: contacts,
        instructions: instructions,
      ));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadNearbyEmergencyFacilities(
    LoadNearbyEmergencyFacilities event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const EmergencyLoading());
    try {
      final facilities = await loadEmergencyFacilitiesUseCase();
      emit(EmergencyFacilitiesLoaded(facilities: facilities));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenEmergencyNavigation(
    OpenEmergencyNavigation event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('Emergency Exit North');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onStartEmergencyNavigation(
    StartEmergencyNavigation event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase(event.destination);
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenSOS(
    OpenSOS event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const SOSSending());
    try {
      await sendSOSUseCase();
      emit(const SOSSent(alertMessage: 'SOS Alert dispatched! Security is tracking your location.'));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onNotifySecurity(
    NotifySecurity event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const SOSSending());
    try {
      await notifySecurityUseCase();
      emit(const SOSSent(alertMessage: 'Silent alert sent. Security dispatch has been notified.'));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onCallSecurity(
    CallSecurity event,
    Emitter<EmergencyState> emit,
  ) async {
    // Simulated voice call action (in a real app, this launches the dialer)
    emit(const SOSSending());
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const SOSSent(alertMessage: 'Dialing Security Command Desk...'));
  }

  Future<void> _onLoadEmergencyContacts(
    LoadEmergencyContacts event,
    Emitter<EmergencyState> emit,
  ) async {
    emit(const EmergencyLoading());
    try {
      final contacts = await loadEmergencyContactsUseCase();
      emit(EmergencyContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenFirstAid(OpenFirstAid event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('First Aid Room');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenFireExit(OpenFireExit event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('Fire Exit North');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenHelpDesk(OpenHelpDesk event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('Help Desk South');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenLostChildAssistance(OpenLostChildAssistance event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('Lost Child Center');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenEmergencyExit(OpenEmergencyExit event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final route = await startEmergencyNavigationUseCase('Emergency Exit B');
      emit(EmergencyNavigationLoaded(route: route));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onOpenEmergencyInstructions(OpenEmergencyInstructions event, Emitter<EmergencyState> emit) async {
    emit(const EmergencyLoading());
    try {
      final instructions = await loadInstructionsUseCase();
      emit(EmergencyLoaded(facilities: const [], contacts: const [], instructions: instructions));
    } catch (e) {
      emit(EmergencyError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshEmergencyData(
    RefreshEmergencyData event,
    Emitter<EmergencyState> emit,
  ) async {
    final facilities = await loadEmergencyFacilitiesUseCase();
    final contacts = await loadEmergencyContactsUseCase();
    final instructions = await loadInstructionsUseCase();
    emit(EmergencyLoaded(
      facilities: facilities,
      contacts: contacts,
      instructions: instructions,
    ));
  }
}
