enum DownloadStatus {
  queued,
  downloading,
  completed,
  paused,
  failed,
}

class Download {
  final String id;
  final String mangaId;
  final String title;
  final String pdfPath;
  final DownloadStatus status;
  final double progress;
  final DateTime createdAt;

  Download({
    required this.id,
    required this.mangaId,
    required this.title,
    required this.pdfPath,
    required this.status,
    required this.progress,
    required this.createdAt,
  });

  Download copyWith({
    DownloadStatus? status,
    double? progress,
  }) {
    return Download(
      id: id,
      mangaId: mangaId,
      title: title,
      pdfPath: pdfPath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt,
    );
  }
}
