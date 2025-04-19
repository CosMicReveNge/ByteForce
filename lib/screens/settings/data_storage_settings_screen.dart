import 'package:flutter/material.dart';

class DataStorageSettingsScreen extends StatelessWidget {
  const DataStorageSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                // TODO: Implement clear cache
              },
              child: const Text('Clear cache'),
            ),
          ),

          const Divider(),

          // Backup and restore
          const ListTile(
            title: Text('Backup and restore'),
            subtitle: Text('Backup and restore app data'),
            enabled: false,
          ),

          // Create backup
          ListTile(
            title: const Text('Create backup'),
            subtitle: const Text(
              'Backup library, settings, and reading history',
            ),
            trailing: const Icon(Icons.backup),
            onTap: () {
              // TODO: Implement create backup
            },
          ),

          // Restore backup
          ListTile(
            title: const Text('Restore backup'),
            subtitle: const Text('Restore from a backup file'),
            trailing: const Icon(Icons.restore),
            onTap: () {
              // TODO: Implement restore backup
            },
          ),

          // Auto backup
          SwitchListTile(
            title: const Text('Automatic backup'),
            subtitle: const Text('Automatically backup app data'),
            value: false, // TODO: Implement auto backup
            onChanged: (value) {
              // TODO: Implement auto backup
            },
          ),

          const Divider(),

          // Data management
          const ListTile(
            title: Text('Data management'),
            subtitle: Text('Manage app data'),
            enabled: false,
          ),

          // Clear database
          ListTile(
            title: const Text('Clear database'),
            subtitle: const Text('Reset all app data'),
            trailing: const Icon(Icons.delete_forever),
            onTap: () {
              _showClearDatabaseDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showClearDatabaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear database'),
            content: const Text(
              'Are you sure you want to reset all app data? This action cannot be undone.',
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
                  // TODO: Implement clear database
                  Navigator.pop(context);
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
