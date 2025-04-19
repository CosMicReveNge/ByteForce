import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/models/chapter.dart';

class MangaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Manga> _recentlyRead = [];
  List<Manga> _newlyAdded = [];
  List<Chapter> _chapters = [];

  List<Manga> get recentlyRead => _recentlyRead;
  List<Manga> get newlyAdded => _newlyAdded;
  List<Chapter> get chapters => _chapters;

  Future<void> fetchRecentlyRead() async {
    try {
      final snapshot =
          await _firestore
              .collection('manga')
              .orderBy('lastReadAt', descending: true)
              .limit(10)
              .get();

      _recentlyRead =
          snapshot.docs.map((doc) => Manga.fromMap(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching recently read manga: $e');
    }
  }

  Future<void> fetchNewlyAdded() async {
    try {
      final snapshot =
          await _firestore
              .collection('manga')
              .orderBy('createdAt', descending: true)
              .limit(10)
              .get();

      _newlyAdded =
          snapshot.docs.map((doc) => Manga.fromMap(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching newly added manga: $e');
    }
  }

  Future<Manga?> getMangaDetails(String mangaId) async {
    try {
      final doc = await _firestore.collection('manga').doc(mangaId).get();
      if (doc.exists) {
        return Manga.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error fetching manga details: $e');
      return null;
    }
  }

  Future<void> fetchChapters(String mangaId) async {
    try {
      final snapshot =
          await _firestore
              .collection('chapters')
              .where('mangaId', isEqualTo: mangaId)
              .orderBy('number', descending: true)
              .get();

      _chapters =
          snapshot.docs.map((doc) => Chapter.fromMap(doc.data())).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching chapters: $e');
    }
  }

  Future<void> markChapterAsRead(String chapterId) async {
    try {
      await _firestore.collection('chapters').doc(chapterId).update({
        'isRead': true,
      });

      // Update local state
      final index = _chapters.indexWhere((chapter) => chapter.id == chapterId);
      if (index != -1) {
        final updatedChapter = Chapter(
          id: _chapters[index].id,
          mangaId: _chapters[index].mangaId,
          title: _chapters[index].title,
          number: _chapters[index].number,
          releaseDate: _chapters[index].releaseDate,
          pageUrls: _chapters[index].pageUrls,
          isRead: true,
        );

        _chapters[index] = updatedChapter;
        notifyListeners();
      }
    } catch (e) {
      print('Error marking chapter as read: $e');
    }
  }
}
