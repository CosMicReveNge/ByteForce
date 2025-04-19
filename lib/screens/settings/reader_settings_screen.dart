import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';

class ReaderSettingsScreen extends StatelessWidget {
  const ReaderSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: ListView(
        children: [
          // Reading direction
          ListTile(
            title: const Text('Reading direction'),
            subtitle: Text(
              _getReadingDirectionText(settingsProvider.readingDirection),
            ),
            onTap: () {
              _showReadingDirectionDialog(context, settingsProvider);
            },
          ),

          const Divider(),

          // Display settings
          const ListTile(
            title: Text('Display'),
            subtitle: Text('Adjust how manga is displayed'),
            enabled: false,
          ),

          // Keep screen on
          SwitchListTile(
            title: const Text('Keep screen on'),
            subtitle: const Text(
              'Prevent screen from turning off while reading',
            ),
            value: settingsProvider.keepScreenOn,
            onChanged: (value) {
              settingsProvider.setKeepScreenOn(value);
            },
          ),

          // Brightness
          ListTile(
            title: const Text('Brightness'),
            subtitle: const Text('Adjust screen brightness while reading'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Slider(
              value: settingsProvider.brightness,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(settingsProvider.brightness * 100).round()}%',
              onChanged: (value) {
                settingsProvider.setBrightness(value);
              },
            ),
          ),

          const Divider(),

          // Navigation settings
          const ListTile(
            title: Text('Navigation'),
            subtitle: Text('Adjust how you navigate through manga'),
            enabled: false,
          ),

          // Show page number
          SwitchListTile(
            title: const Text('Show page number'),
            subtitle: const Text('Display current page number while reading'),
            value: settingsProvider.showPageNumber,
            onChanged: (value) {
              settingsProvider.setShowPageNumber(value);
            },
          ),

          // Tap to scroll
          SwitchListTile(
            title: const Text('Tap to scroll'),
            subtitle: const Text(
              'Tap on screen edges to navigate between pages',
            ),
            value: settingsProvider.tapToScroll,
            onChanged: (value) {
              settingsProvider.setTapToScroll(value);
            },
          ),
        ],
      ),
    );
  }

  String _getReadingDirectionText(ReadingDirection direction) {
    switch (direction) {
      case ReadingDirection.leftToRight:
        return 'Left to right';
      case ReadingDirection.rightToLeft:
        return 'Right to left';
      case ReadingDirection.vertical:
        return 'Vertical';
      default:
        return 'Left to right';
    }
  }

  void _showReadingDirectionDialog(
    BuildContext context,
    SettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reading direction'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ReadingDirection>(
                  title: const Text('Left to right'),
                  subtitle: const Text('Western comics style'),
                  value: ReadingDirection.leftToRight,
                  groupValue: provider.readingDirection,
                  onChanged: (value) {
                    provider.setReadingDirection(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<ReadingDirection>(
                  title: const Text('Right to left'),
                  subtitle: const Text('Manga style'),
                  value: ReadingDirection.rightToLeft,
                  groupValue: provider.readingDirection,
                  onChanged: (value) {
                    provider.setReadingDirection(value!);
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<ReadingDirection>(
                  title: const Text('Vertical'),
                  subtitle: const Text('Webtoon style'),
                  value: ReadingDirection.vertical,
                  groupValue: provider.readingDirection,
                  onChanged: (value) {
                    provider.setReadingDirection(value!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
