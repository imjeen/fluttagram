import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/user/user_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository userRepository;
  SearchCubit({required this.userRepository}) : super(SearchState.initial());

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (err) {
      state.copyWith(
        status: SearchStatus.error,
        failure:
            const Failure(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }
}
