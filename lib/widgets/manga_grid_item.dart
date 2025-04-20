import 'package:flutter/material.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/screens/manga_pdf_viewer.dart'; // ✅ Correct import

class MangaGridItem extends StatelessWidget {
  final MangaModel manga;
  final VoidCallback onTap;

  const MangaGridItem({super.key, required this.manga, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaPdfViewer(
              pdfAssetPath: 'assets/pdfs/${manga.pdfPath}', // ✅ Fixed path
            ),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.asset(
                'assets/covers/${manga.coverPath}', // ✅ Make sure it's prefixed
                fit: BoxFit.cover,
                height: 150.0,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150.0,
                    color: Colors.grey[300],
                    child:
                        const Center(child: Icon(Icons.broken_image, size: 40)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    manga.genres.join(', '),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Rating: ${manga.rating.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
