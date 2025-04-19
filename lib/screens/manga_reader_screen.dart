import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/models/chapter.dart';
import 'package:MangaLo/providers/manga_provider.dart';

class MangaReaderScreen extends StatefulWidget {
  final Chapter chapter;
  final String mangaTitle;

  const MangaReaderScreen({
    Key? key,
    required this.chapter,
    required this.mangaTitle,
  }) : super(key: key);

  @override
  State<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends State<MangaReaderScreen> {
  late PageController _pageController;
  bool _showControls = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Mark chapter as read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MangaProvider>(
        context,
        listen: false,
      ).markChapterAsRead(widget.chapter.id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.chapter.pageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.chapter.pageUrls[index],
                  fit: BoxFit.contain,
                  placeholder:
                      (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white54),
                      ),
                  errorWidget:
                      (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.white54),
                      ),
                );
              },
            ),
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildAppBar(),
                        const Spacer(),
                        _buildBottomControls(),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.mangaTitle, style: const TextStyle(fontSize: 16)),
          Text(
            'Chapter ${widget.chapter.number}: ${widget.chapter.title}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Implement reader settings
          },
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed:
                    _currentPage > 0
                        ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                        : null,
              ),
              const SizedBox(width: 32),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed:
                    _currentPage < widget.chapter.pageUrls.length - 1
                        ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                        : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Page ${_currentPage + 1} of ${widget.chapter.pageUrls.length}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Colors.grey[700],
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: _currentPage.toDouble(),
              min: 0,
              max: (widget.chapter.pageUrls.length - 1).toDouble(),
              onChanged: (value) {
                _pageController.jumpToPage(value.toInt());
              },
            ),
          ),
        ],
      ),
    );
  }
}
