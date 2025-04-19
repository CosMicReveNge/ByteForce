import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';

class LibrarySettingsScreen extends StatelessWidget {
  const LibrarySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: ListView(
        children: [
          // Display settings
          const ListTile(
            title: Text('Display'),
            subtitle: Text('Adjust how manga is displayed in your library'),
            enabled: false,
          ),

          // Show unread only
          SwitchListTile(
            title: const Text('Show unread only'),
            subtitle: const Text('Only show manga with unread chapters'),
            value: settingsProvider.showUnreadOnly,
            onChanged: (value) {
              settingsProvider.setShowUnreadOnly(value);
            },
          ),

          // Group by source
          SwitchListTile(
            title: const Text('Group by source'),
            subtitle: const Text('Group manga by their source'),
            value: settingsProvider.groupBySource,
            onChanged: (value) {
              settingsProvider.setGroupBySource(value);
            },
          ),

          const Divider(),

          // Update settings
          const ListTile(
            title: Text('Updates'),
            subtitle: Text('Configure how library updates work'),
            enabled: false,
          ),

          // Auto update
          ListTile(
            title: const Text('Global update frequency'),
            subtitle: const Text('How often to check for updates'),
            trailing: DropdownButton<String>(
              value: 'daily', // TODO: Implement update frequency
              items: const [
                DropdownMenuItem(value: 'manual', child: Text('Manual')),
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
              ],
              onChanged: (value) {
                // TODO: Implement update frequency
              },
            ),
          ),

          // Update on Wi-Fi only
          SwitchListTile(
            title: const Text('Update on Wi-Fi only'),
            subtitle: const Text(
              'Only check for updates when connected to Wi-Fi',
            ),
            value: true, // TODO: Implement Wi-Fi only updates
            onChanged: (value) {
              // TODO: Implement Wi-Fi only updates
            },
          ),

          const Divider(),

          // Categories
          ListTile(
            title: const Text('Categories'),
            subtitle: const Text('Manage your manga categories'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to categories screen
            },
          ),
        ],
      ),
    );
  }
}
