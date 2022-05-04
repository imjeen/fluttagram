import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttagram/models/user_model.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final User author;
  final String content;
  final DateTime date;

  const Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.date,
  });

  @override
  List<Object?> get props => [id, postId, author, content, date];

  Comment copyWith({
    String? id,
    String? postId,
    User? author,
    String? content,
    DateTime? date,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postId': postId,
      "author": FirebaseFirestore.instance.collection('users').doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Comment?> fromDocument(DocumentSnapshot? doc) async {
    final data = doc?.data() as Map<String, dynamic>?;
    final authorRef = data?['author'] as DocumentReference?;

    if (data == null || doc == null || authorRef == null) return null;

    final authorDoc = await authorRef.get();

    if (authorDoc.exists == false) return null;

    return Comment(
      id: doc.id,
      postId: data['postId'] ?? '',
      author: User.fromDocument(authorDoc),
      content: data['content'] ?? '',
      date: (data['date'] ?? Timestamp).toDate(),
    );
  }
}
