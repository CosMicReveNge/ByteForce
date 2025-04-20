import 'package:flutter/material.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/screens/manga_pdf_viewer.dart'; // ✅ Make sure this import is correct

class MangaCard extends StatelessWidget {
  final MangaModel manga;

  const MangaCard({
    super.key,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MangaPdfViewer(pdfAssetPath: 'assets/pdfs/${manga.pdfPath}'),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/covers/${manga.coverPath}',
                height: 180,
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                manga.title,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
