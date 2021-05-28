part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class ShowForm extends SignInState {}

class Loading extends SignInState {}

class Error extends SignInState {}
