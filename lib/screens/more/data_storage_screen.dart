import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/download_provider.dart';

class DataStorageScreen extends StatelessWidget {
  const DataStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Data and Storage')),
      body: ListView(
        children: [
          // Storage usage
          const ListTile(
            title: Text('Storage usage'),
            subtitle: Text('Manage app storage'),
            enabled: false,
          ),

          // Storage info
          ListTile(
            title: const Text('Storage information'),
            subtitle: Text(
              'Downloads: 0 MB\nCache: 0 MB',
            ), // TODO: Get actual storage info
            trailing: TextButton(
              onPressed: () {
                _showClearCacheDialog(context);
              },
              child: const Text('Clear cache'),
            ),
          ),

          const Divider(),

          // Downloads
          const ListTile(
            title: Text('Downloads'),
            subtitle: Text('Manage downloaded manga'),
            enabled: false,
          ),

          // Downloaded manga
          ListTile(
            title: const Text('Downloaded manga'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadedMangaScreen(),
                ),
              );
            },
          ),

          // Download location
          ListTile(
            title: const Text('Download location'),
            subtitle: const Text(
              'Internal storage',
            ), // TODO: Get actual location
            trailing: const Icon(Icons.folder),
            onTap: () {
              // TODO: Implement download location selection
            },
          ),

          const Divider(),

          // Cache
          const ListTile(
            title: Text('Cache'),
            subtitle: Text('Manage app cache'),
            enabled: false,
          ),

          // Image cache
          ListTile(
            title: const Text('Image cache'),
            subtitle: const Text('0 MB'), // TODO: Get actual size
            trailing: TextButton(
              onPressed: () {
                _showClearImageCacheDialog(context);
              },
              child: const Text('Clear'),
            ),
          ),

          // Database cache
          ListTile(
            title: const Text('Database cache'),
            subtitle: const Text('0 MB'), // TODO: Get actual size
            trailing: TextButton(
              onPressed: () {
                _showClearDatabaseCacheDialog(context);
              },
              child: const Text('Clear'),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear cache'),
        content: const Text(
          'Are you sure you want to clear the app cache?',
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
              // TODO: Implement clear cache
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearImageCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear image cache'),
        content: const Text(
          'Are you sure you want to clear the image cache?',
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
              // TODO: Implement clear image cache
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearDatabaseCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear database cache'),
        content: const Text(
          'Are you sure you want to clear the database cache?',
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
              // TODO: Implement clear database cache
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class DownloadedMangaScreen extends StatelessWidget {
  const DownloadedMangaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloaded Manga')),
      body: const Center(child: Text('No downloaded manga')),
    );
  }
}
