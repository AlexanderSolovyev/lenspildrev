import 'package:equatable/equatable.dart';
import 'package:s3/features/app/domain/entities/user_details.dart';
import 'package:s3/core/usecases/usecase.dart';
import 'package:s3/features/app/domain/repositories/user_repository.dart';

class GetUserDetails implements UseCase<Params> {
  final UserRepository repository;
  GetUserDetails(this.repository);

  Future<UserDetails> call(Params params) async {
    return await repository.getUserDetails(params.userUID);
  }
}

class Params extends Equatable {
  final String userUID;

  Params(this.userUID);

  @override
  List<Object> get props => [userUID];
}
