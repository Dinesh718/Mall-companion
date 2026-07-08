abstract class EmergencyEvent {
  const EmergencyEvent();
}

class LoadEmergencyHub extends EmergencyEvent {
  const LoadEmergencyHub();
}

class LoadNearbyEmergencyFacilities extends EmergencyEvent {
  const LoadNearbyEmergencyFacilities();
}

class OpenEmergencyNavigation extends EmergencyEvent {
  const OpenEmergencyNavigation();
}

class StartEmergencyNavigation extends EmergencyEvent {
  final String destination;
  const StartEmergencyNavigation({required this.destination});
}

class OpenSOS extends EmergencyEvent {
  const OpenSOS();
}

class NotifySecurity extends EmergencyEvent {
  const NotifySecurity();
}

class CallSecurity extends EmergencyEvent {
  const CallSecurity();
}

class LoadEmergencyContacts extends EmergencyEvent {
  const LoadEmergencyContacts();
}

class OpenFirstAid extends EmergencyEvent {
  const OpenFirstAid();
}

class OpenFireExit extends EmergencyEvent {
  const OpenFireExit();
}

class OpenHelpDesk extends EmergencyEvent {
  const OpenHelpDesk();
}

class OpenLostChildAssistance extends EmergencyEvent {
  const OpenLostChildAssistance();
}

class OpenEmergencyExit extends EmergencyEvent {
  const OpenEmergencyExit();
}

class OpenEmergencyInstructions extends EmergencyEvent {
  const OpenEmergencyInstructions();
}

class RefreshEmergencyData extends EmergencyEvent {
  const RefreshEmergencyData();
}
