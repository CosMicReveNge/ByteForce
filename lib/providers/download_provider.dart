import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/models/download.dart';

class DownloadProvider with ChangeNotifier {
  final List<Download> _downloads = [];
  List<Download> get downloads => _downloads;

  Future<void> downloadManga(MangaModel manga) async {
    Download? newDownload;

    try {
      // Check for existing download
      if (_downloads.any((d) => d.mangaId == manga.id)) {
        throw Exception('Manga already downloaded');
      }

      final dir = await getApplicationDocumentsDirectory();
      final filename =
          '${manga.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfPath = '${dir.path}/$filename';

      newDownload = Download(
        id: filename,
        mangaId: manga.id,
        title: manga.title,
        pdfPath: pdfPath,
        status: DownloadStatus.downloading,
        progress: 0.0,
        createdAt: DateTime.now(),
      );

      _downloads.add(newDownload);
      notifyListeners();

      // Simulate download progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        _updateProgress(newDownload.id, i / 100);
      }

      // Copy from assets to documents directory
      final byteData = await rootBundle.load(manga.pdfPath);
      final buffer = byteData.buffer;
      await File(pdfPath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      _updateStatus(newDownload.id, DownloadStatus.completed);
    } catch (e) {
      print('Download error: $e');
      if (newDownload != null) {
        _updateStatus(newDownload.id, DownloadStatus.failed);
      }
    }
  }

  void _updateProgress(String downloadId, double progress) {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _downloads[index] = _downloads[index].copyWith(progress: progress);
      notifyListeners();
    }
  }

  void _updateStatus(String downloadId, DownloadStatus status) {
    final index = _downloads.indexWhere((d) => d.id == downloadId);
    if (index != -1) {
      _downloads[index] = _downloads[index].copyWith(status: status);
      notifyListeners();
    }
  }

  Future<void> deleteDownload(String downloadId) async {
    final download = _downloads.firstWhere((d) => d.id == downloadId);
    try {
      final file = File(download.pdfPath);
      if (await file.exists()) {
        await file.delete();
      }
      _downloads.removeWhere((d) => d.id == downloadId);
      notifyListeners();
    } catch (e) {
      print('Delete error: $e');
    }
  }
}
