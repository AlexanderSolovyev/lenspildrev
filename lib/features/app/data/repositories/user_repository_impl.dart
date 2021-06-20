import 'package:firebase_auth/firebase_auth.dart';
import 'package:s3/features/app/data/data_source/user_remote_data_source.dart';
import 'package:s3/features/app/domain/entities/user_details.dart';
import 'package:s3/features/app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<User?> authStateChanges() => remoteDataSource.authStateChanges;

  @override
  Future<User?> userSignIn(email, password) async {
    return remoteDataSource.userSignIn(email, password);
  }

  @override
  Future<void> signOut() async {
    remoteDataSource.signOut();
  }

  @override
  Future<UserDetails> getUserDetails(userUID) async {
    return remoteDataSource.getUserDetails(userUID);
  }

  @override
  Future<bool> isAuthenticated() {
    return remoteDataSource.isAuthenticated();
  }

  @override
  Future<void> authenticate() {
    return remoteDataSource.authenticate();
  }

  @override
  Future<String> getUserId() {
    return remoteDataSource.getUserId();
  }
}
