import 'package:equatable/equatable.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/repositories/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpState.initial());

  void userNameChanged(String? value) {
    emit(state.copyWith(userName: value, status: SignUpStatus.initial));
  }

  void emailChanged(String? value) {
    emit(state.copyWith(email: value, status: SignUpStatus.initial));
  }

  void passwordChanged(String? value) {
    emit(state.copyWith(password: value, status: SignUpStatus.initial));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignUpStatus.submitting) return;

    try {
      emit(state.copyWith(status: SignUpStatus.submitting));
      await _authRepository.signUpWithEmailAndPassword(
        userName: state.userName,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignUpStatus.error));
    }
  }
}
