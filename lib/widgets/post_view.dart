import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/screens/comments/comments_screen.dart';
import 'package:fluttagram/screens/profile/profile_screen.dart';
import 'package:fluttagram/widgets/user_profile_image.dart';
import 'package:fluttagram/extensions/datetime_extension.dart';
import 'package:flutter/material.dart';


class PostView extends StatelessWidget {
  const PostView({
    Key? key,
    required this.post,
    required this.liked,
    required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  final Post post;
  final bool liked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: ProfileScreenArgs(userId: post.author.id),
              );
            },
            child: Row(
              children: [
                UserProfileImage(avatarUrl: post.author.profileImageUrl),
                const SizedBox(width: 8.0),
                Expanded(
                    child: Text(
                  post.author.username,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ))
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.25,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onLike,
              icon: liked
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_outline),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CommentsScreen.routeName,
                  arguments: CommentsScreenArgs(post: post),
                );
              },
              icon: const Icon(Icons.comment_outlined),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${recentlyLiked ? post.likes + 1 : post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                post.date.timeAgo(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
