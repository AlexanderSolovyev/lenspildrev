import 'package:firebase_auth/firebase_auth.dart';
import 'package:s3/features/app/domain/repositories/user_repository.dart';

class AuthStateChanges {
  final UserRepository repository;

  AuthStateChanges(this.repository);

  Stream<User?> get authStateChanges => repository.authStateChanges();
}
