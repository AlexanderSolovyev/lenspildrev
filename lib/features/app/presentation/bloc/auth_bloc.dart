import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:s3/features/app/domain/usecases/auth_state_changes.dart';
import 'package:s3/features/app/domain/usecases/user_sign_in.dart';
import 'package:s3/features/app/domain/usecases/user_sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStateChanges _authStateChanges;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;

  AuthBloc(this._authStateChanges, this._userSignIn, this._userSignOut)
      : super(Unitialized());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is UserLogin) {
      yield* _mapUserLogin(event);
    } else if (event is UserLogOut) {
      yield* _mapUserLogOut();
    }
  }

  Stream<AuthState> _mapUserLogOut() async* {
    await _userSignOut.call();
    yield Unauthenticated();
  }

  Stream<AuthState> _mapUserLogin(event) async* {
    yield Loading();
    try {
      final user = await _userSignIn(Params(event.email, event.password));
      if (user != null) {
        yield Authenticated(user.email!);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield ShowLoginForm();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authStateChanges.isAuthenticated();
      if (!isSignedIn) {
        yield Unauthenticated();
      }
      final userId = await _authStateChanges.getUserId();
      yield Authenticated(userId);
    } catch (_) {
      yield Unauthenticated();
    }
  }
}
