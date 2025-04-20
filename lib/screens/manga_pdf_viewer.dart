import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum ReadingMode { vertical, ltr, rtl }

class MangaPdfViewer extends StatefulWidget {
  final String pdfAssetPath;

  const MangaPdfViewer({
    super.key,
    required this.pdfAssetPath,
  });

  @override
  State<MangaPdfViewer> createState() => _MangaPdfViewerState();
}

class _MangaPdfViewerState extends State<MangaPdfViewer> {
  ReadingMode _readingMode = ReadingMode.vertical;

  void _showReadingModeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ReadingMode.values.map((mode) {
          return ListTile(
            title: Text(mode.toString().split('.').last.toUpperCase()),
            onTap: () {
              setState(() {
                _readingMode = mode;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildViewer() {
    Widget pdfViewer = SfPdfViewer.asset(widget.pdfAssetPath);

    if (_readingMode == ReadingMode.rtl) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.14159),
        child: pdfViewer,
      );
    } else {
      return pdfViewer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_agenda),
            onPressed: _showReadingModeSelector,
          ),
        ],
      ),
      body: _buildViewer(),
    );
  }
}
