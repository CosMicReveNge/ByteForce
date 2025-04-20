import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MangaPdfViewer extends StatelessWidget {
  final String pdfAssetPath;

  const MangaPdfViewer({
    super.key,
    required this.pdfAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Reader'),
      ),
      body: SfPdfViewer.asset(pdfAssetPath),
    );
  }
}
