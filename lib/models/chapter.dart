class Chapter {
  final String id;
  final String mangaId;
  final String title;
  final int number;
  final DateTime releaseDate;
  final List<String> pageUrls;
  final bool isRead;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.title,
    required this.number,
    required this.releaseDate,
    required this.pageUrls,
    required this.isRead,
  });

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      mangaId: map['mangaId'],
      title: map['title'],
      number: map['number'],
      releaseDate: DateTime.parse(map['releaseDate']),
      pageUrls: List<String>.from(map['pageUrls']),
      isRead: map['isRead'] ?? false,
    );
  }
}
