import '../../domain/entities/auth_user.dart';

class UserModel extends AuthUser {
  const UserModel({
    required super.uid,
    super.phoneNumber,
    super.fullName,
    super.email,
    required super.isGuest,
    required super.isProfileComplete,
  });

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? fullName,
    String? email,
    bool? isGuest,
    bool? isProfileComplete,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
