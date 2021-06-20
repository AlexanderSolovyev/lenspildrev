part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Unitialized extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  Authenticated(this.userId);

  @override
  List<Object> get props => [userId];
}

class Unauthenticated extends AuthState {}

class ShowLoginForm extends AuthState {}

class Loading extends AuthState {}

class Error extends AuthState {}
