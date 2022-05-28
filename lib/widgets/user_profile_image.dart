import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    required this.avatarUrl,
    this.avatarFile,
    this.radius = 18.0,
  }) : super(key: key);

  final String avatarUrl;
  final File? avatarFile;
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
    if (avatarFile == null && avatarUrl.isEmpty) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    }
    return null;
  }

  dynamic? _getAvatar() {
    // print('#avatarFile=$avatarFile, \n#avatarUrl=$avatarUrl');
    if (avatarFile != null && avatarFile?.path.isEmpty != true) {
      return FileImage(avatarFile!);
    }

    if (avatarUrl.isNotEmpty) {
      return CachedNetworkImageProvider(avatarUrl);
    }
    return null;
  }
}
