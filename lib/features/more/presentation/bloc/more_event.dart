import 'package:flutter/foundation.dart';

@immutable
abstract class MoreEvent {
  const MoreEvent();
}

class LoadMoreData extends MoreEvent {
  const LoadMoreData();
}

class RefreshMoreData extends MoreEvent {
  const RefreshMoreData();
}

class LoadParkingData extends MoreEvent {
  const LoadParkingData();
}

class LoadAmenitiesData extends MoreEvent {
  const LoadAmenitiesData();
}

class ToggleNotificationSetting extends MoreEvent {
  final bool isEnabled;
  const ToggleNotificationSetting({required this.isEnabled});
}

class ChangeAppLanguage extends MoreEvent {
  final String language;
  const ChangeAppLanguage({required this.language});
}

class ChangeAppTheme extends MoreEvent {
  final String themeMode; // 'Light', 'Dark', 'System'
  const ChangeAppTheme({required this.themeMode});
}

class SubmitUserFeedback extends MoreEvent {
  final String rating;
  final String comments;
  const SubmitUserFeedback({required this.rating, required this.comments});
}
