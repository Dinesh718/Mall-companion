import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<AuthUser> call(String uid, String fullName, String email) async {
    return await repository.completeProfile(uid, fullName, email);
  }
}
