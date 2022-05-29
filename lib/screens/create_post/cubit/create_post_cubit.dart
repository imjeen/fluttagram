import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/blocs/auth/auth_bloc.dart';
import 'package:fluttagram/models/failure_model.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/post/post_repository.dart';
import 'package:fluttagram/repositories/storage/storage_repository.dart';
import 'package:uuid/uuid.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;

  CreatePostCubit({
    required AuthBloc authBloc,
    required PostRepository postRepository,
    required StorageRepository storageRepository,
  })  : _authBloc = authBloc,
        _postRepository = postRepository,
        _storageRepository = storageRepository,
        super(CreatePostState.initial());

  void postImageChange(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChange(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));

    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.id);

      final postImageUrl =
          await _storageRepository.uploadPostImage(image: state.postImage!);

      final post = Post(
        id: Uuid().v4(),
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );

      await _postRepository.createPost(
        post: post,
        userId: _authBloc.state.user.id,
      );

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      print('#err: $err');
      emit(state.copyWith(
        status: CreatePostStatus.error,
        failure: const Failure(message: 'unable to create the post'),
      ));
    }
  }

  void reset() {
    emit(state.copyWith(status: CreatePostStatus.initial));
  }
}
