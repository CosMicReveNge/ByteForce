import 'package:flutter/material.dart';

class BrowseSettingsScreen extends StatelessWidget {
  const BrowseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: ListView(
        children: [
          // Sources
          const ListTile(
            title: Text('Sources'),
            subtitle: Text('Manage manga sources'),
            enabled: false,
          ),

          // Enabled sources
          ListTile(
            title: const Text('Enabled sources'),
            subtitle: const Text('Select which sources to use'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to sources screen
            },
          ),

          // Source language
          ListTile(
            title: const Text('Source language'),
            subtitle: const Text('Filter sources by language'),
            trailing: DropdownButton<String>(
              value: 'en', // TODO: Implement source language
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ja', child: Text('Japanese')),
              ],
              onChanged: (value) {
                // TODO: Implement source language
              },
            ),
          ),

          const Divider(),

          // Extensions
          const ListTile(
            title: Text('Extensions'),
            subtitle: Text('Manage source extensions'),
            enabled: false,
          ),

          // Install extensions
          ListTile(
            title: const Text('Install extensions'),
            subtitle: const Text('Browse and install source extensions'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to extensions screen
            },
          ),

          // Update extensions
          ListTile(
            title: const Text('Update extensions'),
            subtitle: const Text('Check for extension updates'),
            trailing: const Icon(Icons.system_update),
            onTap: () {
              // TODO: Implement extension updates
            },
          ),

          const Divider(),

          // Search settings
          const ListTile(
            title: Text('Search'),
            subtitle: Text('Configure search behavior'),
            enabled: false,
          ),

          // Global search
          SwitchListTile(
            title: const Text('Global search'),
            subtitle: const Text('Search across all sources'),
            value: true, // TODO: Implement global search
            onChanged: (value) {
              // TODO: Implement global search
            },
          ),
        ],
      ),
    );
  }
}
