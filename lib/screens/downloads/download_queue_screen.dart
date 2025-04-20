import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DownloadStatus { queued, downloading, completed, failed }

class Download {
  final String id;
  final String title;
  final int chapterNumber;
  double progress;
  DownloadStatus status;
  DateTime? completedAt;

  Download({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.progress,
    required this.status,
    this.completedAt,
  });
}

class DownloadProvider with ChangeNotifier {
  final List<Download> _downloads = [];

  List<Download> get downloads => _downloads;

  void addDownload(Download download) {
    _downloads.add(download);
    notifyListeners();
  }

  void deleteDownload(String id) {
    _downloads.removeWhere((download) => download.id == id);
    notifyListeners();
  }

  void updateDownloadProgress(String id, double progress) {
    final download = _downloads.firstWhere((d) => d.id == id);
    download.progress = progress;
    notifyListeners();
  }

  void completeDownload(String id) {
    final download = _downloads.firstWhere((d) => d.id == id);
    download.status = DownloadStatus.completed;
    download.completedAt = DateTime.now();
    notifyListeners();
  }
}

class DownloadQueueScreen extends StatelessWidget {
  const DownloadQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);
    final downloads = downloadProvider.downloads;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Downloads'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Queue'), Tab(text: 'Completed')],
          ),
        ),
        body: TabBarView(
          children: [
            // Queue tab
            _buildQueueTab(context, downloadProvider),

            // Completed tab
            _buildCompletedTab(context, downloadProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueTab(BuildContext context, DownloadProvider provider) {
    final queue = provider.downloads
        .where(
          (d) =>
              d.status == DownloadStatus.queued ||
              d.status == DownloadStatus.downloading ||
              d.status == DownloadStatus.failed,
        )
        .toList();

    if (queue.isEmpty) {
      return const Center(child: Text('Download queue is empty'));
    }

    return ListView.builder(
      itemCount: queue.length,
      itemBuilder: (context, index) {
        final download = queue[index];
        return _buildDownloadItem(context, download, provider);
      },
    );
  }

  Widget _buildCompletedTab(BuildContext context, DownloadProvider provider) {
    final completed = provider.downloads
        .where((d) => d.status == DownloadStatus.completed)
        .toList();

    if (completed.isEmpty) {
      return const Center(child: Text('No completed downloads'));
    }

    return ListView.builder(
      itemCount: completed.length,
      itemBuilder: (context, index) {
        final download = completed[index];
        return ListTile(
          title: Text('Chapter ${download.chapterNumber}: ${download.title}'),
          subtitle: Text('Completed on ${_formatDate(download.completedAt!)}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              provider.deleteDownload(download.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildDownloadItem(
    BuildContext context,
    Download download,
    DownloadProvider provider,
  ) {
    return ListTile(
      title: Text('Chapter ${download.chapterNumber}: ${download.title}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getStatusText(download.status)),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: download.progress,
            backgroundColor: Colors.grey[300],
          ),
        ],
      ),
      trailing: _buildActionButton(context, download, provider),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    Download download,
    DownloadProvider provider,
  ) {
    switch (download.status) {
      case DownloadStatus.queued:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            // Pause download action can be added here if required
          },
        );
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            // Pause download action can be added here if required
          },
        );
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Retry download action can be added here if required
          },
        );
      case DownloadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.check_circle),
          onPressed: null,
        );
      default:
        return const SizedBox.shrink(); // Empty space for unknown statuses
    }
  }

  String _getStatusText(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.queued:
        return 'Queued';
      case DownloadStatus.downloading:
        return 'Downloading...';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.completed:
        return 'Completed';
      default:
        return 'Unknown'; // For unhandled statuses
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
