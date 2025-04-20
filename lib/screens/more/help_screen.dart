import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: ListView(
        children: [
          // Getting started
          ExpansionTile(
            title: const Text('Getting started'),
            children: [
              _buildHelpItem(
                context,
                'How to add manga to your library',
                'Browse for manga and tap the bookmark icon to add it to your library.',
              ),
              _buildHelpItem(
                context,
                'How to download manga',
                'Open a manga and tap the download icon on a chapter to download it for offline reading.',
              ),
              _buildHelpItem(
                context,
                'How to customize the reader',
                'Go to Settings > Reader to customize the reading experience.',
              ),
            ],
          ),

          // Library
          ExpansionTile(
            title: const Text('Library'),
            children: [
              _buildHelpItem(
                context,
                'How to organize your library',
                'Use categories to organize your manga. Go to More > Categories to create and manage categories.',
              ),
              _buildHelpItem(
                context,
                'How to filter your library',
                'Use the filter button in the library to filter manga by status, genre, or other criteria.',
              ),
              _buildHelpItem(
                context,
                'How to search your library',
                'Use the search button in the library to search for manga by title, author, or genre.',
              ),
            ],
          ),

          // Reader
          ExpansionTile(
            title: const Text('Reader'),
            children: [
              _buildHelpItem(
                context,
                'How to change reading direction',
                'Go to Settings > Reader > Reading direction to change the reading direction.',
              ),
              _buildHelpItem(
                context,
                'How to adjust brightness',
                'Use the brightness slider in the reader to adjust the screen brightness.',
              ),
              _buildHelpItem(
                context,
                'How to navigate between pages',
                'Tap the left or right side of the screen to navigate between pages, or use the slider at the bottom.',
              ),
            ],
          ),

          // Downloads
          ExpansionTile(
            title: const Text('Downloads'),
            children: [
              _buildHelpItem(
                context,
                'How to download manga',
                'Open a manga and tap the download icon on a chapter to download it for offline reading.',
              ),
              _buildHelpItem(
                context,
                'How to manage downloads',
                'Go to More > Download queue to manage your downloads.',
              ),
              _buildHelpItem(
                context,
                'How to delete downloads',
                'Go to More > Download queue > Completed and tap the delete icon to delete a download.',
              ),
            ],
          ),

          // Troubleshooting
          ExpansionTile(
            title: const Text('Troubleshooting'),
            children: [
              _buildHelpItem(
                context,
                'App is slow or crashing',
                'Try clearing the cache in Settings > Advanced > Clear cache.',
              ),
              _buildHelpItem(
                context,
                'Cannot download manga',
                'Check your internet connection and make sure you have enough storage space.',
              ),
              _buildHelpItem(
                context,
                'Cannot find a manga',
                'Try using different search terms or check if the source is enabled in Settings > Browse > Enabled sources.',
              ),
            ],
          ),

          // Contact
          ListTile(
            title: const Text('Contact support'),
            trailing: const Icon(Icons.email),
            onTap: () {
              // TODO: Implement contact support
            },
          ),

          // FAQ
          ListTile(
            title: const Text('Frequently asked questions'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to FAQ screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}
