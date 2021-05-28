import 'package:s3/features/app/domain/repositories/user_repository.dart';

class UserSignOut {
  final UserRepository repository;

  UserSignOut(this.repository);

  Future<void> call() async {
    await repository.signOut();
  }
}
