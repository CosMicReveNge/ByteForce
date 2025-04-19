import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MangaLo/models/download.dart';
import 'package:MangaLo/models/chapter.dart';
import 'package:MangaLo/models/manga.dart';

class DownloadProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Download> _downloads = [];
  bool _isDownloading = false;
  int _maxConcurrentDownloads = 2;
  bool _downloadOnWifiOnly = true;

  List<Download> get downloads => _downloads;
  List<Download> get queue =>
      _downloads.where((d) => d.status == DownloadStatus.queued).toList();
  List<Download> get completed =>
      _downloads.where((d) => d.status == DownloadStatus.completed).toList();
  bool get isDownloading => _isDownloading;
  bool get downloadOnWifiOnly => _downloadOnWifiOnly;
  int get maxConcurrentDownloads => _maxConcurrentDownloads;

  DownloadProvider() {
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    if (_auth.currentUser == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('downloads')
              .get();

      _downloads =
          snapshot.docs.map((doc) => Download.fromMap(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading downloads: $e');
    }
  }

  Future<void> queueChapterDownload(Chapter chapter, Manga manga) async {
    if (_auth.currentUser == null) return;

    try {
      // Check if already downloaded or queued
      final existingDownload = _downloads.firstWhere(
        (d) => d.chapterId == chapter.id,
        orElse:
            () => Download(
              id: '',
              mangaId: '',
              chapterId: '',
              title: '',
              chapterNumber: 0,
              pageUrls: [],
              localPaths: [],
              status: DownloadStatus.failed,
              progress: 0,
              createdAt: DateTime.now(),
            ),
      );

      if (existingDownload.id.isNotEmpty) {
        // Already exists, don't queue again
        return;
      }

      final download = Download(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mangaId: manga.id,
        chapterId: chapter.id,
        title: chapter.title,
        chapterNumber: chapter.number,
        pageUrls: chapter.pageUrls,
        localPaths: [],
        status: DownloadStatus.queued,
        progress: 0,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('downloads')
          .doc(download.id)
          .set(download.toMap());

      _downloads.add(download);
      notifyListeners();

      // Start download process if not already running
      if (!_isDownloading) {
        _processDownloadQueue();
      }
    } catch (e) {
      print('Error queueing download: $e');
    }
  }

  Future<void> _processDownloadQueue() async {
    if (_downloads
            .where((d) => d.status == DownloadStatus.downloading)
            .length >=
        _maxConcurrentDownloads) {
      return;
    }

    final nextDownloads =
        _downloads
            .where((d) => d.status == DownloadStatus.queued)
            .take(
              _maxConcurrentDownloads -
                  _downloads
                      .where((d) => d.status == DownloadStatus.downloading)
                      .length,
            )
            .toList();

    if (nextDownloads.isEmpty) {
      _isDownloading = false;
      notifyListeners();
      return;
    }

    _isDownloading = true;
    notifyListeners();

    for (final download in nextDownloads) {
      _downloadChapter(download);
    }
  }

  Future<void> _downloadChapter(Download download) async {
    try {
      // Update status to downloading
      final updatedDownload = download.copyWith(
        status: DownloadStatus.downloading,
      );

      await _updateDownload(updatedDownload);

      // Create directory for manga and chapter
      final appDir = await getApplicationDocumentsDirectory();
      final mangaDir = Directory('${appDir.path}/manga/${download.mangaId}');
      final chapterDir = Directory(
        '${appDir.path}/manga/${download.mangaId}/chapter_${download.chapterNumber}',
      );

      if (!await mangaDir.exists()) {
        await mangaDir.create(recursive: true);
      }

      if (!await chapterDir.exists()) {
        await chapterDir.create(recursive: true);
      }

      // Download each page
      final localPaths = <String>[];
      int downloadedPages = 0;

      for (int i = 0; i < download.pageUrls.length; i++) {
        final url = download.pageUrls[i];
        final fileName = 'page_${i + 1}.jpg';
        final filePath = '${chapterDir.path}/$fileName';
        final file = File(filePath);

        // Download file
        final response = await http.get(Uri.parse(url));
        await file.writeAsBytes(response.bodyBytes);

        localPaths.add(filePath);
        downloadedPages++;

        // Update progress
        final progress = downloadedPages / download.pageUrls.length;
        final progressUpdate = updatedDownload.copyWith(
          progress: progress,
          localPaths: localPaths,
        );

        await _updateDownload(progressUpdate);
      }

      // Mark as completed
      final completedDownload = updatedDownload.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
        localPaths: localPaths,
        completedAt: DateTime.now(),
      );

      await _updateDownload(completedDownload);

      // Process next in queue
      _processDownloadQueue();
    } catch (e) {
      print('Error downloading chapter: $e');

      // Mark as failed
      final failedDownload = download.copyWith(status: DownloadStatus.failed);

      await _updateDownload(failedDownload);

      // Process next in queue
      _processDownloadQueue();
    }
  }

  Future<void> _updateDownload(Download download) async {
    if (_auth.currentUser == null) return;

    try {
      // Update in Firestore
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('downloads')
          .doc(download.id)
          .update(download.toMap());

      // Update local list
      final index = _downloads.indexWhere((d) => d.id == download.id);
      if (index != -1) {
        _downloads[index] = download;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating download: $e');
    }
  }

  Future<void> cancelDownload(String downloadId) async {
    if (_auth.currentUser == null) return;

    try {
      final download = _downloads.firstWhere((d) => d.id == downloadId);

      // Delete from Firestore
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('downloads')
          .doc(downloadId)
          .delete();

      // Remove from local list
      _downloads.removeWhere((d) => d.id == downloadId);
      notifyListeners();

      // Delete any downloaded files
      for (final path in download.localPaths) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error canceling download: $e');
    }
  }

  Future<void> deleteDownload(String downloadId) async {
    await cancelDownload(downloadId);
  }

  Future<void> pauseDownload(String downloadId) async {
    if (_auth.currentUser == null) return;

    try {
      final download = _downloads.firstWhere((d) => d.id == downloadId);

      if (download.status == DownloadStatus.downloading ||
          download.status == DownloadStatus.queued) {
        final pausedDownload = download.copyWith(status: DownloadStatus.paused);

        await _updateDownload(pausedDownload);
      }
    } catch (e) {
      print('Error pausing download: $e');
    }
  }

  Future<void> resumeDownload(String downloadId) async {
    if (_auth.currentUser == null) return;

    try {
      final download = _downloads.firstWhere((d) => d.id == downloadId);

      if (download.status == DownloadStatus.paused ||
          download.status == DownloadStatus.failed) {
        final queuedDownload = download.copyWith(status: DownloadStatus.queued);

        await _updateDownload(queuedDownload);

        // Start download process if not already running
        if (!_isDownloading) {
          _processDownloadQueue();
        }
      }
    } catch (e) {
      print('Error resuming download: $e');
    }
  }

  Future<void> setMaxConcurrentDownloads(int max) async {
    _maxConcurrentDownloads = max;
    notifyListeners();

    // Update user preferences
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'preferences.maxConcurrentDownloads': max,
      });
    }
  }

  Future<void> setDownloadOnWifiOnly(bool wifiOnly) async {
    _downloadOnWifiOnly = wifiOnly;
    notifyListeners();

    // Update user preferences
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'preferences.downloadOnWifiOnly': wifiOnly,
      });
    }
  }

  bool isChapterDownloaded(String chapterId) {
    return _downloads.any(
      (d) => d.chapterId == chapterId && d.status == DownloadStatus.completed,
    );
  }

  Download? getDownloadByChapterId(String chapterId) {
    try {
      return _downloads.firstWhere((d) => d.chapterId == chapterId);
    } catch (e) {
      return null;
    }
  }
}
