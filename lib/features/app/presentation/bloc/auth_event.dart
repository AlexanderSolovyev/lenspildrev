part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class UserLogin extends AuthEvent {
  final String email;
  final String password;

  UserLogin(this.email, this.password);
}

class UserLogOut extends AuthEvent {}
