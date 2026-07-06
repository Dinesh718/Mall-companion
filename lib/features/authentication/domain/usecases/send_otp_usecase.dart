import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<void> call(String phoneNumber) async {
    await repository.sendOtp(phoneNumber);
  }
}
