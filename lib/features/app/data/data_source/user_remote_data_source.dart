import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s3/features/app/data/models/user_model.dart';
import 'package:s3/features/app/domain/entities/user_details.dart';

abstract class UserRemoteDataSource {
  Stream<User?> get authStateChanges;
  Future<User?> userSignIn(email, password);
  Future<void> signOut();
  Future<UserDetails> getUserDetails(userUID);
  Future<bool> isAuthenticated();
  Future<void> authenticate();
  Future<String> getUserId();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  @override
  Future<User?> userSignIn(email, password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserDetailsModel> getUserDetails(userUID) async {
    final query = await firestore.collection('users').doc(userUID).get();
    return UserDetailsModel.fromDS(query.data()!);
  }

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<void> authenticate() {
    return firebaseAuth.signInAnonymously();
  }

  Future<String> getUserId() async {
    return (firebaseAuth.currentUser)!.uid;
  }
}
