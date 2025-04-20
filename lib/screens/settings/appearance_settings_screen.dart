import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          // Theme mode
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_getThemeModeText(settingsProvider.themeMode)),
            onTap: () {
              _showThemeModeDialog(context, settingsProvider);
            },
          ),

          const Divider(),

          // Accent color
          ListTile(
            title: const Text('Accent color'),
            subtitle: const Text('Change the app accent color'),
            trailing: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: settingsProvider.accentColor,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              _showColorPickerDialog(context, settingsProvider);
            },
          ),

          const Divider(),

          // Date format (placeholder)
          ListTile(
            title: const Text('Date format'),
            subtitle: const Text('Change how dates are displayed'),
            onTap: () {
              // TODO: Implement date format settings
            },
          ),

          // Time format (placeholder)
          ListTile(
            title: const Text('Time format'),
            subtitle: const Text('12-hour or 24-hour format'),
            onTap: () {
              // TODO: Implement time format settings
            },
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'System default';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      default:
        return 'System default';
    }
  }

  void _showThemeModeDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Text(_getThemeModeText(mode)),
              value: mode,
              groupValue: provider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  provider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, SettingsProvider provider) {
    final colors = [
      Colors.pink,
      Colors.red,
      Colors.deepOrange,
      Colors.orange,
      Colors.amber,
      Colors.yellow,
      Colors.lime,
      Colors.lightGreen,
      Colors.green,
      Colors.teal,
      Colors.cyan,
      Colors.lightBlue,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.deepPurple,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accent color'),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: colors.map((color) {
            return InkWell(
              onTap: () {
                provider.setAccentColor(color);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.accentColor == color
                        ? Colors.white
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
