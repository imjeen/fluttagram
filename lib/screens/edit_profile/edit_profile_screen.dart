import 'dart:io';

import 'package:fluttagram/models/user_model.dart';
import 'package:fluttagram/repositories/storage/storage_repository.dart';
import 'package:fluttagram/repositories/user/user_repository.dart';
import 'package:fluttagram/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:fluttagram/screens/profile/bloc/profile_bloc.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:fluttagram/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreenArgs {
  final BuildContext context;
  const EditProfileScreenArgs({required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = "/editProfile";

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => EditProfileScreen(
        user: args.context.read<ProfileBloc>().state.user,
        profileBloc: args.context.read<ProfileBloc>(),
      ),
    );
  }

  final User user;
  final ProfileBloc profileBloc;

  EditProfileScreen({
    Key? key,
    required this.user,
    required this.profileBloc,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileCubit>(
      create: (context) => EditProfileCubit(
        userRepository: context.read<UserRepository>(),
        storageRepository: context.read<StorageRepository>(),
        profileBloc: profileBloc,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Edit Profile')),
          body: BlocConsumer<EditProfileCubit, EditProfileState>(
            listener: (context, state) {
              if (state.status == EditProfileStatus.success) {
                Navigator.of(context).pop();
              } else if (state.status == EditProfileStatus.error) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(content: state.failure.message),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (state.status == EditProfileStatus.submitting)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 32.0),
                    GestureDetector(
                      onTap: () => _selectProfileImage(context),
                      child: UserProfileImage(
                        radius: 80.0,
                        avatarUrl: user.profileImageUrl,
                        avatarFile: state.profileImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              initialValue: state.username,
                              decoration:
                                  const InputDecoration(hintText: 'Username'),
                              validator: (value) => (value ?? '').trim().isEmpty
                                  ? 'Username cannot be empty.'
                                  : null,
                              onChanged: (value) {
                                context
                                    .read<EditProfileCubit>()
                                    .usernameChanged(value);
                              },
                            ),
                            const SizedBox(height: 18.0),
                            TextFormField(
                              initialValue: state.bio,
                              decoration:
                                  const InputDecoration(hintText: 'Bio'),
                              validator: (value) => (value ?? '').trim().isEmpty
                                  ? 'Bio cannot be empty.'
                                  : null,
                              onChanged: (value) {
                                context
                                    .read<EditProfileCubit>()
                                    .bioChanged(value);
                              },
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true &&
                                    state.status !=
                                        EditProfileStatus.submitting) {
                                  context.read<EditProfileCubit>().submit();
                                }
                              },
                              child: const Text('Update'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void _selectProfileImage(BuildContext context) async {
  final editProfileCubit = context.read<EditProfileCubit>(); // 异步前缓存 context 相关
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print('nothing selected');
    return;
  }

  final File file = File(pickedFile.path);

  editProfileCubit.profileImageChanged(file);
}
