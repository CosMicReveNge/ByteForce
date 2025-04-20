import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        children: [
          // App info
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'MangaLo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version $_version ($_buildNumber)',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A Cleaner & Simpler Way to Read Manga and Webtoons',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),

          const Divider(),

          // App details
          ListTile(
            title: const Text('App version'),
            subtitle: Text('$_version ($_buildNumber)'),
          ),

          ListTile(
            title: const Text('Platform'),
            subtitle: Text(Platform.operatingSystem),
          ),

          const Divider(),

          // Links
          ListTile(
            title: const Text('Website'),
            subtitle: const Text('Visit our website'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open website
            },
          ),

          ListTile(
            title: const Text('GitHub'),
            subtitle: const Text('View source code'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open GitHub
            },
          ),

          ListTile(
            title: const Text('Report an issue'),
            subtitle: const Text('Report bugs or request features'),
            trailing: const Icon(Icons.bug_report),
            onTap: () {
              // TODO: Open issue reporter
            },
          ),

          const Divider(),

          // Legal
          ListTile(
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),

          ListTile(
            title: const Text('Terms of service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Open terms of service
            },
          ),

          ListTile(
            title: const Text('Licenses'),
            subtitle: const Text('Open source licenses'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'MangaLo',
                applicationVersion: _version,
              );
            },
          ),
        ],
      ),
    );
  }
}
