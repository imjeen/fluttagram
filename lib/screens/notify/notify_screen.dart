import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttagram/enums/notify_type.dart';
import 'package:fluttagram/screens/comments/comments_screen.dart';
import 'package:fluttagram/screens/notify/bloc/notify_bloc.dart';
import 'package:fluttagram/widgets/centered_text.dart';
import 'package:fluttagram/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttagram/models/notify_model.dart';
import 'package:intl/intl.dart';

class NotifyScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifyBloc, NotifyState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: Builder(
            builder: (_) {
              switch (state.status) {
                case NotifyStatus.loaded:
                  return ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return NotifyTile(notification: notification);
                      });
                case NotifyStatus.error:
                  return CenteredText(text: state.failure.message);
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
        ;
      },
    );
  }
}

class NotifyTile extends StatelessWidget {
  final Notify notification;
  const NotifyTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        avatarUrl: notification.fromUser.profileImageUrl,
        radius: 18.0,
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: notification.fromUser.username,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notification.date),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _getTrailing(context, notification),
      onTap: () {},
    );
  }

  String _getText(Notify notification) {
    switch (notification.type) {
      case NotifyType.like:
        return 'liked your post.';
      case NotifyType.comment:
        return 'commented on your post.';
      case NotifyType.follow:
        return 'followed you.';
      default:
        return '';
    }
  }

  Widget _getTrailing(BuildContext context, Notify notif) {
    if (notification.type == NotifyType.like ||
        notification.type == NotifyType.comment) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          CommentsScreen.routeName,
          arguments: CommentsScreenArgs(post: notification.post!),
        ),
        child: CachedNetworkImage(
          height: 60.0,
          width: 60.0,
          imageUrl: notification.post!.imageUrl,
          fit: BoxFit.cover,
        ),
      );
    } else if (notification.type == NotifyType.follow) {
      return const SizedBox(
        height: 60.0,
        width: 60.0,
        child: Icon(Icons.person_add),
      );
    }
    return const SizedBox.shrink();
  }
}
