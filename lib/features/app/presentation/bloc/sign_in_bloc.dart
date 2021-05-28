import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:s3/features/app/domain/usecases/user_sign_in.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserSignIn userSignIn;

  SignInBloc(this.userSignIn) : super(ShowForm());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is UserLogin) {
      yield Loading();
      await userSignIn(Params(event.email, event.password));
      yield ShowForm();
    }
  }
}
