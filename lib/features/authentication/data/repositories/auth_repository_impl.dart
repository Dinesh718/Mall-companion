import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  static UserModel? _currentUser;

  @override
  Future<AuthUser> continueAsGuest() async {
    // Dummy delay to simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = const UserModel(
      uid: 'guest_user',
      isGuest: true,
      isProfileComplete: true,
    );
    return _currentUser!;
  }

  @override
  Future<void> sendOtp(String phoneNumber) async {
    // Dummy delay to simulate network call
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<AuthUser> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (otp != '123456') {
      throw Exception('Invalid OTP. Please enter 123456.');
    }

    if (phoneNumber == '9876543210') {
      // Existing user
      _currentUser = UserModel(
        uid: 'user_9876543210',
        phoneNumber: phoneNumber,
        fullName: 'John Doe',
        email: 'johndoe@example.com',
        isGuest: false,
        isProfileComplete: true,
      );
    } else {
      // New user
      _currentUser = UserModel(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: phoneNumber,
        isGuest: false,
        isProfileComplete: false,
      );
    }
    return _currentUser!;
  }

  @override
  Future<AuthUser> completeProfile(
    String uid,
    String fullName,
    String email,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_currentUser == null || _currentUser!.uid != uid) {
      _currentUser = UserModel(
        uid: uid,
        isGuest: false,
        isProfileComplete: true,
      );
    }
    _currentUser = _currentUser!.copyWith(
      fullName: fullName,
      email: email,
      isProfileComplete: true,
    );
    return _currentUser!;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }
}
