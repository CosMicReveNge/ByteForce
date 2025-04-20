import 'package:flutter/material.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/widgets/star_rating.dart';

class MangaDetailScreen extends StatelessWidget {
  final MangaModel manga;

  const MangaDetailScreen({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                manga.coverPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          manga.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      StarRating(rating: manga.rating, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: manga.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    manga.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
