import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/download_provider.dart';
import 'package:MangaLo/models/download.dart';

class DownloadQueueScreen extends StatelessWidget {
  const DownloadQueueScreen({Key? key}) : super(key: key);

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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _showDownloadSettingsDialog(context);
              },
            ),
          ],
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
    final queue =
        provider.downloads
            .where(
              (d) =>
                  d.status == DownloadStatus.queued ||
                  d.status == DownloadStatus.downloading ||
                  d.status == DownloadStatus.paused ||
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
    final completed =
        provider.downloads
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
            provider.pauseDownload(download.id);
          },
        );
      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            provider.pauseDownload(download.id);
          },
        );
      case DownloadStatus.paused:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            provider.resumeDownload(download.id);
          },
        );
      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            provider.resumeDownload(download.id);
          },
        );
      case DownloadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.check_circle),
          onPressed: null,
        );
    }
  }

  String _getStatusText(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.queued:
        return 'Queued';
      case DownloadStatus.downloading:
        return 'Downloading...';
      case DownloadStatus.paused:
        return 'Paused';
      case DownloadStatus.failed:
        return 'Failed';
      case DownloadStatus.completed:
        return 'Completed';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _showDownloadSettingsDialog(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Download on Wi-Fi only'),
                  value: downloadProvider.downloadOnWifiOnly,
                  onChanged: (value) {
                    downloadProvider.setDownloadOnWifiOnly(value);
                  },
                ),
                ListTile(
                  title: const Text('Maximum concurrent downloads'),
                  trailing: DropdownButton<int>(
                    value: downloadProvider.maxConcurrentDownloads,
                    items:
                        [1, 2, 3, 4, 5].map((value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        downloadProvider.setMaxConcurrentDownloads(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
