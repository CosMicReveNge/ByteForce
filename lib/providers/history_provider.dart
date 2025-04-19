import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MangaLo/models/reading_history.dart';

class HistoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ReadingHistory> _history = [];
  bool _incognitoMode = false;

  List<ReadingHistory> get history => _history;
  bool get incognitoMode => _incognitoMode;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (_auth.currentUser == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('history')
              .orderBy('lastReadAt', descending: true)
              .get();

      _history =
          snapshot.docs
              .map((doc) => ReadingHistory.fromMap(doc.data()))
              .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading reading history: $e');
    }
  }

  Future<void> addToHistory({
    required String mangaId,
    required String chapterId,
    required String mangaTitle,
    required String chapterTitle,
    required int chapterNumber,
    required int pageNumber,
    required int totalPages,
  }) async {
    if (_auth.currentUser == null || _incognitoMode) return;

    try {
      final progress = pageNumber / totalPages;

      // Check if entry already exists
      final existingEntryIndex = _history.indexWhere(
        (h) => h.chapterId == chapterId,
      );

      if (existingEntryIndex != -1) {
        // Update existing entry
        final updatedEntry = _history[existingEntryIndex].copyWith(
          pageNumber: pageNumber,
          progress: progress,
          lastReadAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('history')
            .doc(updatedEntry.id)
            .update(updatedEntry.toMap());

        _history[existingEntryIndex] = updatedEntry;
      } else {
        // Create new entry
        final newEntry = ReadingHistory(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          mangaId: mangaId,
          chapterId: chapterId,
          mangaTitle: mangaTitle,
          chapterTitle: chapterTitle,
          chapterNumber: chapterNumber,
          pageNumber: pageNumber,
          totalPages: totalPages,
          progress: progress,
          lastReadAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('history')
            .doc(newEntry.id)
            .set(newEntry.toMap());

        _history.insert(0, newEntry);
      }

      // Update manga's last read timestamp
      await _firestore.collection('manga').doc(mangaId).update({
        'lastReadAt': DateTime.now().toIso8601String(),
      });

      notifyListeners();
    } catch (e) {
      print('Error adding to reading history: $e');
    }
  }

  Future<void> removeFromHistory(String historyId) async {
    if (_auth.currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('history')
          .doc(historyId)
          .delete();

      _history.removeWhere((h) => h.id == historyId);
      notifyListeners();
    } catch (e) {
      print('Error removing from reading history: $e');
    }
  }

  Future<void> clearHistory() async {
    if (_auth.currentUser == null) return;

    try {
      final batch = _firestore.batch();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('history')
              .get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      _history.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing reading history: $e');
    }
  }

  Future<void> toggleIncognitoMode() async {
    _incognitoMode = !_incognitoMode;
    notifyListeners();

    // Update user preferences
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'preferences.incognitoMode': _incognitoMode,
      });
    }
  }

  ReadingHistory? getHistoryByMangaId(String mangaId) {
    try {
      return _history.firstWhere((h) => h.mangaId == mangaId);
    } catch (e) {
      return null;
    }
  }

  ReadingHistory? getHistoryByChapterId(String chapterId) {
    try {
      return _history.firstWhere((h) => h.chapterId == chapterId);
    } catch (e) {
      return null;
    }
  }
}
