import 'package:flutter/material.dart';
import 'package:MangaLo/models/manga.dart';

class MangaProvider extends ChangeNotifier {
  bool _isLoading = true;
  List<MangaModel> _mangaList = [];

  bool get isLoading => _isLoading;
  List<MangaModel> get mangaList => _mangaList;

  List<MangaModel> _recentlyRead = [];
  List<MangaModel> _newlyAdded = [];
  List<MangaModel> _library = [];

  List<MangaModel> get recentlyRead => _recentlyRead;
  List<MangaModel> get newlyAdded => _newlyAdded;
  List<MangaModel> get library => _library;

  final List<MangaModel> _localManga = [
    MangaModel(
      id: '1',
      title: 'One Piece',
      pdfPath: 'one_piece_vol01.pdf',
      coverPath: 'assets/covers/onepiece.jpg',
      rating: 4.8,
      genres: ['Adventure', 'Action'],
      description: 'The story of Monkey D. Luffy...',
    ),
    MangaModel(
      id: '2',
      title: 'Jujutsu Kaisen',
      pdfPath: 'jujutsu_kaisen_vol01.pdf',
      coverPath: 'assets/covers/jjkcover.jpg',
      rating: 4.7,
      genres: ['Dark Fantasy'],
      description: 'A world of curses and sorcerers...',
    ),
  ];

  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate a short loading delay
    await Future.delayed(const Duration(seconds: 1));

    _mangaList = _localManga;
    _recentlyRead = _localManga;
    _newlyAdded = _localManga.reversed.toList();
    _library = _localManga;

    _isLoading = false;
    notifyListeners();
  }

  Future<MangaModel?> getMangaDetails(String mangaId) async {
    try {
      return _localManga.firstWhere((manga) => manga.id == mangaId);
    } catch (e) {
      return null;
    }
  }

  void updateLastRead({required String mangaId}) {
    final index = _localManga.indexWhere((m) => m.id == mangaId);
    if (index != -1) {
      _localManga[index] = _localManga[index].copyWith(
        lastReadAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
