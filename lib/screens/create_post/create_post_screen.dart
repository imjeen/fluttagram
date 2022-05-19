import 'dart:io';

import 'package:fluttagram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:fluttagram/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = "/createPost";

  CreatePostScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (_) => ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == CreatePostStatus.success) {
              _formKey.currentState?.reset();
              context.read<CreatePostCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
                content: Text('Post Created'),
              ));
            }
          },
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  SingleChildScrollView _buildBody(
      BuildContext context, CreatePostState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _selectPostImage(context),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: state.postImage != null
                  ? Image.file(state.postImage!, fit: BoxFit.cover)
                  : const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 120.0,
                    ),
            ),
          ),
          if (state.status == CreatePostStatus.submitting)
            const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Caption'),
                    ),
                    const SizedBox(height: 28.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true &&
                            state.postImage != null &&
                            state.status != CreatePostStatus.submitting) {
                          context.read<CreatePostCubit>().submit();
                        }
                      },
                      child: const Text('Post'),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

void _selectPostImage(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print('nothing selected');
    return;
  }

  final File file = File(pickedFile.path);

  context.read<CreatePostCubit>().postImageChange(file);
}
