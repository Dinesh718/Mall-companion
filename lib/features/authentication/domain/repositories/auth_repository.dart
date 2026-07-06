import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> continueAsGuest();
  Future<void> sendOtp(String phoneNumber);
  Future<AuthUser> verifyOtp(String phoneNumber, String otp);
  Future<AuthUser> completeProfile(String uid, String fullName, String email);
  Future<AuthUser?> getCurrentUser();
}
