import '../../domain/entities/profile_entities.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class GuestProfileLoaded extends ProfileState {
  final GuestProfileEntity guestProfile;
  const GuestProfileLoaded({required this.guestProfile});
}

class UserProfileLoaded extends ProfileState {
  final UserProfileEntity userProfile;
  const UserProfileLoaded({required this.userProfile});
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}

class ProfileError extends ProfileState {
  final String errorMessage;
  const ProfileError({required this.errorMessage});
}

class ProfileLoggedOut extends ProfileState {
  const ProfileLoggedOut();
}

class ProfileSessionExpired extends ProfileState {
  const ProfileSessionExpired();
}
