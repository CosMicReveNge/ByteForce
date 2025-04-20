// screens/profile/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/providers/download_provider.dart';
import 'package:MangaLo/providers/history_provider.dart';
import 'package:MangaLo/screens/settings/settings_screen.dart';
import 'package:MangaLo/screens/downloads/download_queue_screen.dart';
import 'package:MangaLo/screens/more/categories_screen.dart';
import 'package:MangaLo/screens/more/statistics_screen.dart';
import 'package:MangaLo/screens/more/data_storage_screen.dart';
import 'package:MangaLo/screens/more/about_screen.dart';
import 'package:MangaLo/screens/more/help_screen.dart';
import 'package:MangaLo/screens/auth/login_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          // User profile header
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.2),
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                  child: user?.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
                const SizedBox(height: 16),

                // Username
                Text(
                  isAuthenticated ? user?.username ?? 'User' : 'Guest',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Email
                if (isAuthenticated && user?.email != null)
                  Text(
                    user!.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),

                const SizedBox(height: 16),

                // Login/Logout button
                ElevatedButton(
                  onPressed: () {
                    if (isAuthenticated) {
                      _showSignOutDialog(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: Text(isAuthenticated ? 'Sign Out' : 'Sign In'),
                ),
              ],
            ),
          ),

          const Divider(),

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
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
