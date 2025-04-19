import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';

class SecurityPrivacySettingsScreen extends StatelessWidget {
  const SecurityPrivacySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Security and Privacy')),
      body: ListView(
        children: [
          // Security settings
          const ListTile(
            title: Text('Security'),
            subtitle: Text('Secure your app'),
            enabled: false,
          ),

          // App lock
          SwitchListTile(
            title: const Text('App lock'),
            subtitle: const Text('Require authentication to open the app'),
            value: settingsProvider.requireAuthForStartup,
            onChanged: (value) {
              settingsProvider.setRequireAuthForStartup(value);
              if (value) {
                _showAuthMethodDialog(context);
              }
            },
          ),

          // Secure screen
          SwitchListTile(
            title: const Text('Secure screen'),
            subtitle: const Text('Prevent screenshots and screen recording'),
            value: settingsProvider.secureMode,
            onChanged: (value) {
              settingsProvider.setSecureMode(value);
            },
          ),

          const Divider(),

          // Privacy settings
          const ListTile(
            title: Text('Privacy'),
            subtitle: Text('Manage your privacy'),
            enabled: false,
          ),

          // Incognito mode
          ListTile(
            title: const Text('Incognito mode'),
            subtitle: const Text('Configure incognito mode behavior'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to incognito settings
            },
          ),

          // Clear history
          ListTile(
            title: const Text('Clear reading history'),
            subtitle: const Text('Delete your reading history'),
            trailing: const Icon(Icons.delete_outline),
            onTap: () {
              _showClearHistoryDialog(context);
            },
          ),

          const Divider(),

          // Data collection
          const ListTile(
            title: Text('Data collection'),
            subtitle: Text('Manage data collection settings'),
            enabled: false,
          ),

          // Usage statistics
          SwitchListTile(
            title: const Text('Usage statistics'),
            subtitle: const Text(
              'Send anonymous usage data to help improve the app',
            ),
            value: false, // TODO: Implement usage statistics
            onChanged: (value) {
              // TODO: Implement usage statistics
            },
          ),

          // Crash reports
          SwitchListTile(
            title: const Text('Crash reports'),
            subtitle: const Text('Send crash reports to help fix issues'),
            value: true, // TODO: Implement crash reports
            onChanged: (value) {
              // TODO: Implement crash reports
            },
          ),
        ],
      ),
    );
  }

  void _showAuthMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Authentication method'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('PIN'),
                  value: 'pin',
                  groupValue: 'pin', // TODO: Implement auth method
                  onChanged: (value) {
                    // TODO: Implement auth method
                    Navigator.pop(context);
                    _showSetPinDialog(context);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Biometric'),
                  value: 'biometric',
                  groupValue: 'pin', // TODO: Implement auth method
                  onChanged: (value) {
                    // TODO: Implement auth method
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showSetPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Set PIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter a 4-digit PIN'),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'PIN',
                  ),
                ),
              ],
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
                  // TODO: Implement set PIN
                  Navigator.pop(context);
                },
                child: const Text('Set'),
              ),
            ],
          ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear reading history'),
            content: const Text(
              'Are you sure you want to delete your reading history? This action cannot be undone.',
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
                  // TODO: Implement clear history
                  Navigator.pop(context);
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
