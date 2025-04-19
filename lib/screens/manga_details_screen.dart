import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/providers/manga_provider.dart';
import 'package:manga_reader/screens/manga_reader_screen.dart';
import 'package:manga_reader/widgets/star_rating.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;

  const MangaDetailScreen({Key? key, required this.mangaId}) : super(key: key);

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  bool _isLoading = true;
  Manga? _manga;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<MangaProvider>(context, listen: false);

    final manga = await provider.getMangaDetails(widget.mangaId);
    if (manga != null) {
      setState(() {
        _manga = manga;
      });

      await provider.fetchChapters(widget.mangaId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_manga == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Manga not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _manga!.title,
                              style: Theme.of(context).textTheme.headline5
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'by ${_manga!.author}',
                              style: Theme.of(context).textTheme.subtitle1
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      StarRating(rating: _manga!.rating, size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _manga!.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _manga!.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chapters',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        '${_manga!.chapterCount} chapters',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _buildChaptersList(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: _manga!.coverUrl,
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
          errorWidget:
              (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // TODO: Implement favorite functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildChaptersList() {
    final chapters = context.watch<MangaProvider>().chapters;

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final chapter = chapters[index];
        return ChapterListItem(
          chapter: chapter,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MangaReaderScreen(
                      chapter: chapter,
                      mangaTitle: _manga!.title,
                    ),
              ),
            );
          },
        );
      }, childCount: chapters.length),
    );
  }
}

class ChapterListItem extends StatelessWidget {
  final Chapter chapter;
  final VoidCallback onTap;

  const ChapterListItem({Key? key, required this.chapter, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapter ${chapter.number}: ${chapter.title}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: chapter.isRead ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(chapter.releaseDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  primary: chapter.isRead ? Colors.grey : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(chapter.isRead ? 'Read' : 'Read'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
