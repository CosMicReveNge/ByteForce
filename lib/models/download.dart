enum DownloadStatus { queued, downloading, completed, failed, paused }

class Download {
  final String id;
  final String mangaId;
  final String chapterId;
  final String title;
  final int chapterNumber;
  final List<String> pageUrls;
  final List<String> localPaths;
  final DownloadStatus status;
  final double progress;
  final DateTime createdAt;
  final DateTime? completedAt;

  Download({
    required this.id,
    required this.mangaId,
    required this.chapterId,
    required this.title,
    required this.chapterNumber,
    required this.pageUrls,
    required this.localPaths,
    required this.status,
    required this.progress,
    required this.createdAt,
    this.completedAt,
  });

  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      id: map['id'] ?? '',
      mangaId: map['mangaId'] ?? '',
      chapterId: map['chapterId'] ?? '',
      title: map['title'] ?? '',
      chapterNumber: map['chapterNumber'] ?? 0,
      pageUrls: List<String>.from(map['pageUrls'] ?? []),
      localPaths: List<String>.from(map['localPaths'] ?? []),
      status: DownloadStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => DownloadStatus.queued,
      ),
      progress: map['progress']?.toDouble() ?? 0.0,
      createdAt:
          map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now(),
      completedAt:
          map['completedAt'] != null
              ? DateTime.parse(map['completedAt'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangaId': mangaId,
      'chapterId': chapterId,
      'title': title,
      'chapterNumber': chapterNumber,
      'pageUrls': pageUrls,
      'localPaths': localPaths,
      'status': status.toString(),
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Download copyWith({
    String? id,
    String? mangaId,
    String? chapterId,
    String? title,
    int? chapterNumber,
    List<String>? pageUrls,
    List<String>? localPaths,
    DownloadStatus? status,
    double? progress,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Download(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      pageUrls: pageUrls ?? this.pageUrls,
      localPaths: localPaths ?? this.localPaths,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
