import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s3/core/usecases/usecase.dart';
import 'package:s3/features/app/domain/repositories/user_repository.dart';

class UserSignIn implements UseCase<Params> {
  final UserRepository repository;

  UserSignIn(this.repository);

  Future<User?> call(Params params) async {
    return await repository.userSignIn(params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
