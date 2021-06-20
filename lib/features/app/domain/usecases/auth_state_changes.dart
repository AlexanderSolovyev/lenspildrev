import 'package:s3/features/app/domain/repositories/user_repository.dart';

class AuthStateChanges {
  final UserRepository repository;

  AuthStateChanges(this.repository);

  //Stream<User?> authStateChanges() => repository.authStateChanges();
  Future<bool> isAuthenticated() => repository.isAuthenticated();
  Future<void> authenticate() => repository.authenticate();
  Future<String> getUserId() => repository.getUserId();
}
