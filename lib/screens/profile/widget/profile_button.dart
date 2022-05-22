import 'package:fluttagram/screens/edit_profile/edit_profile_screen.dart';
import 'package:fluttagram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key? key,
    required this.isCurrentUser,
    required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProfileScreen.routeName,
                arguments: EditProfileScreenArgs(context: context),
              );
            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ))
        : TextButton(
            onPressed: () async {
              if (isFollowing) {
                context.read<ProfileBloc>().add(ProfileUnfollowUser());
              } else {
                context.read<ProfileBloc>().add(ProfileFollowUser());
              }
            },
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: const TextStyle(fontSize: 16.0),
            ));
  }
}
