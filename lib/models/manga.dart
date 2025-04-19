class Manga {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final double rating;
  final List<String> genres;
  final String description;
  final DateTime lastUpdated;
  final int chapterCount;

  Manga({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.rating,
    required this.genres,
    required this.description,
    required this.lastUpdated,
    required this.chapterCount,
  });

  factory Manga.fromMap(Map<String, dynamic> map) {
    return Manga(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      coverUrl: map['coverUrl'],
      rating: map['rating'].toDouble(),
      genres: List<String>.from(map['genres']),
      description: map['description'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
      chapterCount: map['chapterCount'],
    );
  }
}
