class MangaModel {
  final String id;
  final String title;
  final String pdfPath;
  final String coverPath;
  final double rating;
  final List<String> genres;
  final String description;
  final DateTime? lastReadAt;

  MangaModel({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.coverPath,
    required this.rating,
    required this.genres,
    required this.description,
    this.lastReadAt,
  });

  MangaModel copyWith({
    DateTime? lastReadAt,
  }) {
    return MangaModel(
      id: id,
      title: title,
      pdfPath: pdfPath,
      coverPath: coverPath,
      rating: rating,
      genres: genres,
      description: description,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
