// models/comment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String content;
  final DateTime createdAt;
  final List<String> likes;
  final int replyCount;
  final String? parentId;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.replyCount,
    this.parentId,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String docId) {
    return Comment(
      id: docId,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
      replyCount: map['replyCount'] ?? 0,
      parentId: map['parentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userPhotoUrl': userPhotoUrl,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'replyCount': replyCount,
      'parentId': parentId,
    };
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? username,
    String? userPhotoUrl,
    String? content,
    DateTime? createdAt,
    List<String>? likes,
    int? replyCount,
    String? parentId,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      replyCount: replyCount ?? this.replyCount,
      parentId: parentId ?? this.parentId,
    );
  }
}
