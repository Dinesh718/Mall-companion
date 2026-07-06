import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class ContinueAsGuestUseCase {
  final AuthRepository repository;

  ContinueAsGuestUseCase(this.repository);

  Future<AuthUser> call() async {
    return await repository.continueAsGuest();
  }
}
