import 'package:firebase_auth/firebase_auth.dart';
import 'package:s3/features/app/domain/entities/user_details.dart';

abstract class UserRepository {
  Stream<User?> authStateChanges();
  Future<User?> userSignIn(email, password);
  Future<void> signOut();
  Future<UserDetails> getUserDetails(userUID);
}
