import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    required this.avatarUrl,
    this.AvatarFile,
    this.radius = 18.0,
  }) : super(key: key);

  final String avatarUrl;
  final File? AvatarFile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      backgroundImage: _getAvatar(),
      child: _getChild(),
    );
  }

  Icon? _getChild() {
    if (AvatarFile == null && avatarUrl.isEmpty) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    }
    return null;
  }

  dynamic? _getAvatar() {
    if (AvatarFile != null) {
      return FileImage(AvatarFile!);
    }

    if (avatarUrl.isNotEmpty) {
      return CachedNetworkImageProvider(avatarUrl);
    }
    return null;
  }
}
