abstract class ProfileEvent {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}

class SignInPressed extends ProfileEvent {
  const SignInPressed();
}

class LogoutPressed extends ProfileEvent {
  const LogoutPressed();
}

class ToggleNotification extends ProfileEvent {
  final bool pushNotificationsEnabled;
  const ToggleNotification({required this.pushNotificationsEnabled});
}

class ChangeLanguage extends ProfileEvent {
  final String language;
  const ChangeLanguage({required this.language});
}

class ChangeTheme extends ProfileEvent {
  final String theme;
  const ChangeTheme({required this.theme});
}

class ChangeAccessibility extends ProfileEvent {
  final String accessibility;
  const ChangeAccessibility({required this.accessibility});
}
