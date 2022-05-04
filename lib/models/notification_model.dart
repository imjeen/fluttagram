import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/enums/notification_type.dart';
import 'package:fluttagram/models/post_model.dart';
import 'package:fluttagram/models/user_model.dart';

class Notification extends Equatable {
  final String? id;
  final NotificationType type;
  final User fromUser;
  final Post? post;
  final DateTime date;

  const Notification({
    this.id,
    required this.type,
    required this.fromUser,
    this.post,
    required this.date,
  });

  @override
  List<Object?> get props => [id, type, fromUser, post, date];

  Notification copyWith({
    String? id,
    NotificationType? type,
    User? fromUser,
    Post? post,
    DateTime? date,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUser: fromUser ?? this.fromUser,
      date: date ?? this.date,
      post: post ?? this.post,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "type": EnumToString.convertToString(type),
      "fromUser":
          FirebaseFirestore.instance.collection('users').doc(fromUser.id),
      "post": FirebaseFirestore.instance.collection('posts').doc(post?.id),
      "date": Timestamp.fromDate(date),
    };
  }

  static Future<Notification?> fromDocument(DocumentSnapshot? doc) async {
    final data = doc?.data() as Map<String, dynamic>?;
    final fromUserRef = data?['fromUser'] as DocumentReference?;
    final postRef = data?['post'] as DocumentReference?;

    if (data == null || doc == null || fromUserRef == null) return null;

    final fromUserDoc = await fromUserRef.get();
    final postDoc = await postRef?.get();

    if (!fromUserDoc.exists) return null;

    return Notification(
      id: doc.id,
      type: EnumToString.fromString(NotificationType.values, data['type'])!,
      post: postDoc?.exists == true ? await Post.fromDocument(postDoc) : null,
      fromUser: User.fromDocument(fromUserDoc),
      date: (data['date'] ?? Timestamp.now()).toDate(),
    );
  }
}
