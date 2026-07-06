class AuthUser {
  final String uid;
  final String? phoneNumber;
  final String? fullName;
  final String? email;
  final bool isGuest;
  final bool isProfileComplete;

  const AuthUser({
    required this.uid,
    this.phoneNumber,
    this.fullName,
    this.email,
    required this.isGuest,
    required this.isProfileComplete,
  });
}
