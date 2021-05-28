part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent([List props = const <dynamic>[]]);
  @override
  List<Object> get props => [];
}

class UserLogin extends SignInEvent {
  final String email;
  final String password;

  UserLogin(this.email, this.password) : super([email, password]);
}
