// providers/community_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MangaLo/models/comment.dart';
import 'package:MangaLo/models/user.dart';

class CommunityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all top-level comments (no parent)
  Future<void> fetchComments() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot =
          await _firestore
              .collection('communities')
              .where('parentId', isNull: true)
              .orderBy('createdAt', descending: true)
              .get();

      _comments =
          snapshot.docs
              .map((doc) => Comment.fromMap(doc.data(), doc.id))
              .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load comments: $e';
      notifyListeners();
      print('Error fetching comments: $e');
    }
  }

  // Fetch replies for a specific comment
  Future<List<Comment>> fetchReplies(String commentId) async {
    try {
      final snapshot =
          await _firestore
              .collection('communities')
              .where('parentId', isEqualTo: commentId)
              .orderBy('createdAt', descending: false)
              .get();

      return snapshot.docs
          .map((doc) => Comment.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching replies: $e');
      return [];
    }
  }

  // Add a new comment
  Future<bool> addComment(String content, {String? parentId}) async {
    try {
      if (_auth.currentUser == null) {
        _errorMessage = 'You must be logged in to post a comment';
        notifyListeners();
        return false;
      }

      final userDoc =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .get();

      if (!userDoc.exists) {
        _errorMessage = 'User profile not found';
        notifyListeners();
        return false;
      }

      final userData = userDoc.data()!;
      final username = userData['username'] ?? 'Anonymous';
      final userPhotoUrl = userData['photoUrl'];

      final newComment = Comment(
        id: '',
        userId: _auth.currentUser!.uid,
        username: username,
        userPhotoUrl: userPhotoUrl,
        content: content,
        createdAt: DateTime.now(),
        likes: [],
        replyCount: 0,
        parentId: parentId,
      );

      final docRef = await _firestore
          .collection('communities')
          .add(newComment.toMap());

      // If this is a reply, increment the parent's reply count
      if (parentId != null) {
        await _firestore.collection('communities').doc(parentId).update({
          'replyCount': FieldValue.increment(1),
        });

        // Update local state if the parent is in our list
        final index = _comments.indexWhere((c) => c.id == parentId);
        if (index != -1) {
          _comments[index] = _comments[index].copyWith(
            replyCount: _comments[index].replyCount + 1,
          );
          notifyListeners();
        }
      } else {
        // Add the new comment to our list if it's a top-level comment
        _comments.insert(0, Comment.fromMap(newComment.toMap(), docRef.id));
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = 'Failed to add comment: $e';
      notifyListeners();
      print('Error adding comment: $e');
      return false;
    }
  }

  // Toggle like on a comment
  Future<void> toggleLike(String commentId) async {
    try {
      if (_auth.currentUser == null) {
        _errorMessage = 'You must be logged in to like a comment';
        notifyListeners();
        return;
      }

      final userId = _auth.currentUser!.uid;
      final commentRef = _firestore.collection('communities').doc(commentId);
      final commentDoc = await commentRef.get();

      if (!commentDoc.exists) {
        _errorMessage = 'Comment not found';
        notifyListeners();
        return;
      }

      final comment = Comment.fromMap(commentDoc.data()!, commentDoc.id);
      final likes = List<String>.from(comment.likes);

      if (likes.contains(userId)) {
        // Unlike
        likes.remove(userId);
      } else {
        // Like
        likes.add(userId);
      }

      await commentRef.update({'likes': likes});

      // Update local state
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _comments[index] = _comments[index].copyWith(likes: likes);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle like: $e';
      notifyListeners();
      print('Error toggling like: $e');
    }
  }

  // Delete a comment
  Future<bool> deleteComment(String commentId) async {
    try {
      if (_auth.currentUser == null) {
        _errorMessage = 'You must be logged in to delete a comment';
        notifyListeners();
        return false;
      }

      final commentRef = _firestore.collection('communities').doc(commentId);
      final commentDoc = await commentRef.get();

      if (!commentDoc.exists) {
        _errorMessage = 'Comment not found';
        notifyListeners();
        return false;
      }

      final comment = Comment.fromMap(commentDoc.data()!, commentDoc.id);

      // Check if the user is the author of the comment
      if (comment.userId != _auth.currentUser!.uid) {
        _errorMessage = 'You can only delete your own comments';
        notifyListeners();
        return false;
      }

      // If this is a reply, decrement the parent's reply count
      if (comment.parentId != null) {
        await _firestore.collection('communities').doc(comment.parentId).update(
          {'replyCount': FieldValue.increment(-1)},
        );

        // Update local state if the parent is in our list
        final parentIndex = _comments.indexWhere(
          (c) => c.id == comment.parentId,
        );
        if (parentIndex != -1) {
          _comments[parentIndex] = _comments[parentIndex].copyWith(
            replyCount: _comments[parentIndex].replyCount - 1,
          );
        }
      }

      // Delete the comment
      await commentRef.delete();

      // Update local state
      _comments.removeWhere((c) => c.id == commentId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete comment: $e';
      notifyListeners();
      print('Error deleting comment: $e');
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
