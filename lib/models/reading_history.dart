class ReadingHistory {
  final String id;
  final String mangaId;
  final String chapterId;
  final String mangaTitle;
  final String chapterTitle;
  final int chapterNumber;
  final int pageNumber;
  final int totalPages;
  final double progress;
  final DateTime lastReadAt;

  ReadingHistory({
    required this.id,
    required this.mangaId,
    required this.chapterId,
    required this.mangaTitle,
    required this.chapterTitle,
    required this.chapterNumber,
    required this.pageNumber,
    required this.totalPages,
    required this.progress,
    required this.lastReadAt,
  });

  factory ReadingHistory.fromMap(Map<String, dynamic> map) {
    return ReadingHistory(
      id: map['id'] ?? '',
      mangaId: map['mangaId'] ?? '',
      chapterId: map['chapterId'] ?? '',
      mangaTitle: map['mangaTitle'] ?? '',
      chapterTitle: map['chapterTitle'] ?? '',
      chapterNumber: map['chapterNumber'] ?? 0,
      pageNumber: map['pageNumber'] ?? 0,
      totalPages: map['totalPages'] ?? 0,
      progress: map['progress']?.toDouble() ?? 0.0,
      lastReadAt:
          map['lastReadAt'] != null
              ? DateTime.parse(map['lastReadAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mangaId': mangaId,
      'chapterId': chapterId,
      'mangaTitle': mangaTitle,
      'chapterTitle': chapterTitle,
      'chapterNumber': chapterNumber,
      'pageNumber': pageNumber,
      'totalPages': totalPages,
      'progress': progress,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  ReadingHistory copyWith({
    String? id,
    String? mangaId,
    String? chapterId,
    String? mangaTitle,
    String? chapterTitle,
    int? chapterNumber,
    int? pageNumber,
    int? totalPages,
    double? progress,
    DateTime? lastReadAt,
  }) {
    return ReadingHistory(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      mangaTitle: mangaTitle ?? this.mangaTitle,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      totalPages: totalPages ?? this.totalPages,
      progress: progress ?? this.progress,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
