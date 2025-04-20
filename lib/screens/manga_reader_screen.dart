import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/models/manga.dart';
import 'package:MangaLo/providers/manga_provider.dart';

class MangaPdfViewerScreen extends StatefulWidget {
  final MangaModel manga;
  final String pdfPath;

  const MangaPdfViewerScreen({
    super.key,
    required this.manga,
    required this.pdfPath,
  });

  @override
  State<MangaPdfViewerScreen> createState() => _MangaPdfViewerScreenState();
}

class _MangaPdfViewerScreenState extends State<MangaPdfViewerScreen> {
  late PDFViewController _pdfViewController;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MangaProvider>(context, listen: false)
          .updateLastRead(mangaId: widget.manga.id);
    });
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            PDFView(
              filePath: widget.pdfPath,
              onRender: (pages) => setState(() => _totalPages = pages!),
              onViewCreated: (controller) => _pdfViewController = controller,
              onPageChanged: (page, _) => setState(() => _currentPage = page!),
            ),
            if (_showControls) _buildControlsOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return AnimatedOpacity(
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
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        widget.manga.title,
        style: const TextStyle(fontSize: 18),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Slider(
            value: _currentPage.toDouble(),
            min: 0,
            max: (_totalPages - 1).toDouble(),
            onChanged: (value) => _pdfViewController.setPage(value.toInt()),
            activeColor: Colors.white,
            inactiveColor: Colors.grey[700],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: _currentPage > 0
                    ? () => _pdfViewController.setPage(_currentPage - 1)
                    : null,
              ),
              Text(
                'Page ${_currentPage + 1}/$_totalPages',
                style: const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: _currentPage < _totalPages - 1
                    ? () => _pdfViewController.setPage(_currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
