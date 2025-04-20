import 'package:flutter/material.dart';

class TrackingSettingsScreen extends StatelessWidget {
  const TrackingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: ListView(
        children: [
          // Tracking services
          const ListTile(
            title: Text('Tracking services'),
            subtitle: Text('Connect to external tracking services'),
            enabled: false,
          ),

          // MyAnimeList
          ListTile(
            title: const Text('MyAnimeList'),
            subtitle: const Text('Not logged in'),
            trailing: OutlinedButton(
              onPressed: () {
                // TODO: Implement MyAnimeList login
              },
              child: const Text('Login'),
            ),
          ),

          // AniList
          ListTile(
            title: const Text('AniList'),
            subtitle: const Text('Not logged in'),
            trailing: OutlinedButton(
              onPressed: () {
                // TODO: Implement AniList login
              },
              child: const Text('Login'),
            ),
          ),

          // Kitsu
          ListTile(
            title: const Text('Kitsu'),
            subtitle: const Text('Not logged in'),
            trailing: OutlinedButton(
              onPressed: () {
                // TODO: Implement Kitsu login
              },
              child: const Text('Login'),
            ),
          ),

          const Divider(),

          // Sync settings
          const ListTile(
            title: Text('Sync settings'),
            subtitle: Text('Configure how tracking works'),
            enabled: false,
          ),

          // Auto sync after reading
          SwitchListTile(
            title: const Text('Auto sync after reading'),
            subtitle: const Text(
              'Automatically update tracking services after reading a chapter',
            ),
            value: true, // TODO: Implement auto sync
            onChanged: (value) {
              // TODO: Implement auto sync
            },
          ),

          // Sync reading status
          SwitchListTile(
            title: const Text('Sync reading status'),
            subtitle: const Text('Update reading status on tracking services'),
            value: true, // TODO: Implement sync reading status
            onChanged: (value) {
              // TODO: Implement sync reading status
            },
          ),
        ],
      ),
    );
  }
}
