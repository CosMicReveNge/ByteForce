import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/providers/history_provider.dart';
import 'package:MangaLo/screens/settings/settings_screen.dart';
import 'package:MangaLo/screens/downloads/download_queue_screen.dart';
import 'package:MangaLo/screens/more/categories_screen.dart';
import 'package:MangaLo/screens/more/statistics_screen.dart';
import 'package:MangaLo/screens/more/data_storage_screen.dart';
import 'package:MangaLo/screens/more/about_screen.dart';
import 'package:MangaLo/screens/more/help_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          // Downloaded only
          SwitchListTile(
            secondary: const Icon(Icons.offline_bolt),
            title: const Text('Downloaded only'),
            subtitle: const Text('Filters all entries in your library'),
            value: false, // TODO: Implement downloaded only filter
            onChanged: (value) {
              // TODO: Implement downloaded only filter
            },
          ),

          // Incognito mode
          SwitchListTile(
            secondary: const Icon(Icons.visibility_off),
            title: const Text('Incognito mode'),
            subtitle: const Text('Pauses reading history'),
            value: historyProvider.incognitoMode,
            onChanged: (value) {
              historyProvider.toggleIncognitoMode();
            },
          ),

          const Divider(),

          // Download queue
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download queue'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadQueueScreen(),
                ),
              );
            },
          ),

          // Categories
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesScreen(),
                ),
              );
            },
          ),

          // Statistics
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),

          // Data and storage
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Data and storage'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataStorageScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),

          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),

          // Help
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
