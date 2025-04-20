import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class MangaPdfViewerScreen extends StatefulWidget {
  final String pdfPath; // asset path like 'assets/sample.pdf'
  final String mangaTitle;

  const MangaPdfViewerScreen({
    super.key,
    required this.pdfPath,
    required this.mangaTitle,
  });

  @override
  State<MangaPdfViewerScreen> createState() => _MangaPdfViewerScreenState();
}

class _MangaPdfViewerScreenState extends State<MangaPdfViewerScreen> {
  late PDFViewController _controller;
  int _currentPage = 0;
  int _totalPages = 0;
  final bool _showControls = true;
  String? _localPdfPath;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    final bytes = await rootBundle.load(widget.pdfPath);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    setState(() => _localPdfPath = file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _localPdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: _localPdfPath!,
              onRender: (pages) => setState(() => _totalPages = pages!),
              onViewCreated: (controller) => _controller = controller,
              onPageChanged: (page, _) => setState(() => _currentPage = page!),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
