import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/download_provider.dart';

class DownloadSettingsScreen extends StatefulWidget {
  const DownloadSettingsScreen({super.key});

  @override
  _DownloadSettingsScreenState createState() => _DownloadSettingsScreenState();
}

class _DownloadSettingsScreenState extends State<DownloadSettingsScreen> {
  bool _downloadOnWifiOnly = true;
  int _maxConcurrentDownloads = 3;
  bool _autoDownloadNewChapters = true;

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: ListView(
        children: [
          // Download settings
          const ListTile(
            title: Text('Download settings'),
            subtitle: Text('Configure how downloads work'),
            enabled: false,
          ),

          // Download on Wi-Fi only
          SwitchListTile(
            title: const Text('Download on Wi-Fi only'),
            subtitle: const Text('Only download manga when connected to Wi-Fi'),
            value: _downloadOnWifiOnly,
            onChanged: (value) {
              setState(() {
                _downloadOnWifiOnly = value;
              });
            },
          ),

          // Maximum concurrent downloads
          ListTile(
            title: const Text('Maximum concurrent downloads'),
            subtitle: const Text('How many chapters to download at once'),
            trailing: DropdownButton<int>(
              value: _maxConcurrentDownloads,
              items: [1, 2, 3, 4, 5].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _maxConcurrentDownloads = value;
                  });
                }
              },
            ),
          ),

          const Divider(),

          // Auto download settings
          const ListTile(
            title: Text('Auto download'),
            subtitle: Text('Configure automatic downloads'),
            enabled: false,
          ),

          // Auto download new chapters
          SwitchListTile(
            title: const Text('Auto download new chapters'),
            subtitle: const Text(
              'Automatically download new chapters for manga in your library',
            ),
            value: _autoDownloadNewChapters,
            onChanged: (value) {
              setState(() {
                _autoDownloadNewChapters = value;
              });
            },
          ),

          // Download ahead
          ListTile(
            title: const Text('Download ahead'),
            subtitle: const Text(
              'Download chapters ahead of current reading position',
            ),
            trailing: DropdownButton<int>(
              value: 2, // TODO: Implement download ahead
              items: [0, 1, 2, 3, 5, 10].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value == 0 ? 'Disabled' : '$value'),
                );
              }).toList(),
              onChanged: (value) {
                // TODO: Implement download ahead
              },
            ),
          ),

          const Divider(),

          // Storage settings
          ListTile(
            title: const Text('Storage'),
            subtitle: const Text('Manage download storage'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to storage settings
            },
          ),

          // Clear all downloads
          ListTile(
            title: const Text('Clear all downloads'),
            subtitle: const Text('Delete all downloaded manga'),
            trailing: const Icon(Icons.delete_outline),
            onTap: () {
              _showClearDownloadsDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showClearDownloadsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all downloads'),
        content: const Text(
          'Are you sure you want to delete all downloaded manga? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement clear all downloads
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
