class Manga {
  final String id;
  final String title;
  final String coverPath;
  String status;
  String rating;
  String? pdfPath;

  Manga({
    required this.id,
    required this.title,
    required this.coverPath,
    this.status = 'N/A',
    this.rating = 'N/A',
    this.pdfPath,
  });
}

List<Manga> mangaList = [
  Manga(
    id: '1',
    title: 'One Piece',
    coverPath:
        "/assets/mangas/covers/onepiececover.jpg", // Add your actual path
    pdfPath: "/assets/mangas/pdfs/onepiece.pdf", // Add your actual path
  ),
  Manga(
    id: '2',
    title: 'Naruto',
    coverPath: "/assets/mangas/covers/narutocover.jpg",
    pdfPath: "/assets/mangas/pdfs/naruto.pdf",
  ),

  // Add more manga entries as needed
];
