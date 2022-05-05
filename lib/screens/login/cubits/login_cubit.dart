import 'package:equatable/equatable.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/repositories/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged({String? value}) {
    emit(state.copyWith(email: value, status: LoginStatus.initial));
  }

  void passwordChanged({String? value}) {
    emit(state.copyWith(password: value, status: LoginStatus.initial));
  }

  void logInWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;

    try {
      emit(state.copyWith(status: LoginStatus.submitting));
      await _authRepository.logInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: LoginStatus.error));
    }
  }
}
