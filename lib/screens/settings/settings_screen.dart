import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/screens/settings/appearance_settings_screen.dart';
import 'package:MangaLo/screens/settings/library_settings_screen.dart';
import 'package:MangaLo/screens/settings/reader_settings_screen.dart';
import 'package:MangaLo/screens/settings/download_settings_screen.dart';
import 'package:MangaLo/screens/settings/tracking_settings_screen.dart';
import 'package:MangaLo/screens/settings/browse_settings_screen.dart';
import 'package:MangaLo/screens/settings/data_storage_settings_screen.dart';
import 'package:MangaLo/screens/settings/security_privacy_settings_screen.dart';
import 'package:MangaLo/screens/settings/advanced_settings_screen.dart';
import 'package:MangaLo/screens/settings/about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement settings search
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Appearance
          _buildSettingItem(
            context,
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Theme, date & time format',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppearanceSettingsScreen(),
                ),
              );
            },
          ),

          // Library
          _buildSettingItem(
            context,
            icon: Icons.collections_bookmark_outlined,
            title: 'Library',
            subtitle: 'Categories, global update, chapter swipe',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibrarySettingsScreen(),
                ),
              );
            },
          ),

          // Reader
          _buildSettingItem(
            context,
            icon: Icons.chrome_reader_mode_outlined,
            title: 'Reader',
            subtitle: 'Reading mode, display, navigation',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReaderSettingsScreen(),
                ),
              );
            },
          ),

          // Downloads
          _buildSettingItem(
            context,
            icon: Icons.download_outlined,
            title: 'Downloads',
            subtitle: 'Automatic download, download ahead',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadSettingsScreen(),
                ),
              );
            },
          ),

          // Tracking
          _buildSettingItem(
            context,
            icon: Icons.sync_outlined,
            title: 'Tracking',
            subtitle: 'One-way progress sync, enhanced sync',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackingSettingsScreen(),
                ),
              );
            },
          ),

          // Browse
          _buildSettingItem(
            context,
            icon: Icons.explore_outlined,
            title: 'Browse',
            subtitle: 'Sources, extensions, global search',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrowseSettingsScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // Data and storage
          _buildSettingItem(
            context,
            icon: Icons.storage_outlined,
            title: 'Data and storage',
            subtitle: 'Manual & automatic backups, storage space',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataStorageSettingsScreen(),
                ),
              );
            },
          ),

          // Security and privacy
          _buildSettingItem(
            context,
            icon: Icons.security_outlined,
            title: 'Security and privacy',
            subtitle: 'App lock, secure screen',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecurityPrivacySettingsScreen(),
                ),
              );
            },
          ),

          // Advanced
          _buildSettingItem(
            context,
            icon: Icons.code_outlined,
            title: 'Advanced',
            subtitle: 'Dump crash logs, battery optimizations',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvancedSettingsScreen(),
                ),
              );
            },
          ),

          const Divider(),

          // About
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'MangaLo v1.0.0',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),

          // Sign out (only if logged in)
          if (authProvider.isAuthenticated)
            _buildSettingItem(
              context,
              icon: Icons.logout,
              title: 'Sign out',
              subtitle: 'Sign out of your account',
              onTap: () {
                _showSignOutDialog(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.tealAccent
            : Theme.of(context).primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
