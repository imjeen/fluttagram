import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/auth/auth_repository.dart';
// import 'package:fluttagram/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    // on<AuthEvent>((event, emit) {});
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onUserChanged);
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authRepository.logOut());
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    emit(user != null
        ? AuthState.authenticated(user: user)
        : AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
