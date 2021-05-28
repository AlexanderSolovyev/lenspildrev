import 'package:equatable/equatable.dart';

abstract class UseCase<Params> {
  Future call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
