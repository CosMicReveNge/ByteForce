import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReadingDirection { leftToRight, rightToLeft, vertical }

enum AppThemeMode { system, light, dark }

class SettingsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.pink;

  // Reader settings
  ReadingDirection _readingDirection = ReadingDirection.leftToRight;
  bool _keepScreenOn = true;
  double _brightness = 1.0;
  bool _showPageNumber = true;
  bool _tapToScroll = true;

  // Library settings
  bool _showUnreadOnly = false;
  bool _groupBySource = false;

  // Download settings
  bool _downloadOnWifiOnly = true;
  int _maxConcurrentDownloads = 2;
  bool _autoDownloadNewChapters = false;

  // Privacy settings
  bool _secureMode = false;
  bool _requireAuthForStartup = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  ReadingDirection get readingDirection => _readingDirection;
  bool get keepScreenOn => _keepScreenOn;
  double get brightness => _brightness;
  bool get showPageNumber => _showPageNumber;
  bool get tapToScroll => _tapToScroll;
  bool get showUnreadOnly => _showUnreadOnly;
  bool get groupBySource => _groupBySource;
  bool get downloadOnWifiOnly => _downloadOnWifiOnly;
  int get maxConcurrentDownloads => _maxConcurrentDownloads;
  bool get autoDownloadNewChapters => _autoDownloadNewChapters;
  bool get secureMode => _secureMode;
  bool get requireAuthForStartup => _requireAuthForStartup;

  SettingsProvider() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    _prefs = await SharedPreferences.getInstance();

    // Load settings from SharedPreferences (for non-logged in users)
    _loadLocalSettings();

    // If user is logged in, load settings from Firestore
    if (_auth.currentUser != null) {
      await _loadCloudSettings();
    }

    notifyListeners();

    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadCloudSettings();
        notifyListeners();
      }
    });
  }

  void _loadLocalSettings() {
    // Theme settings
    final themeModeString = _prefs.getString('themeMode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.system,
    );

    final accentColorValue = _prefs.getInt('accentColor') ?? Colors.pink.value;
    _accentColor = Color(accentColorValue);

    // Reader settings
    final readingDirectionString =
        _prefs.getString('readingDirection') ?? 'leftToRight';
    _readingDirection = ReadingDirection.values.firstWhere(
      (e) => e.toString() == 'ReadingDirection.$readingDirectionString',
      orElse: () => ReadingDirection.leftToRight,
    );

    _keepScreenOn = _prefs.getBool('keepScreenOn') ?? true;
    _brightness = _prefs.getDouble('brightness') ?? 1.0;
    _showPageNumber = _prefs.getBool('showPageNumber') ?? true;
    _tapToScroll = _prefs.getBool('tapToScroll') ?? true;

    // Library settings
    _showUnreadOnly = _prefs.getBool('showUnreadOnly') ?? false;
    _groupBySource = _prefs.getBool('groupBySource') ?? false;

    // Download settings
    _downloadOnWifiOnly = _prefs.getBool('downloadOnWifiOnly') ?? true;
    _maxConcurrentDownloads = _prefs.getInt('maxConcurrentDownloads') ?? 2;
    _autoDownloadNewChapters =
        _prefs.getBool('autoDownloadNewChapters') ?? false;

    // Privacy settings
    _secureMode = _prefs.getBool('secureMode') ?? false;
    _requireAuthForStartup = _prefs.getBool('requireAuthForStartup') ?? false;
  }

  Future<void> _loadCloudSettings() async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .get();

      if (doc.exists && doc.data()!.containsKey('preferences')) {
        final preferences = doc.data()!['preferences'] as Map<String, dynamic>;

        // Theme settings
        if (preferences.containsKey('themeMode')) {
          final themeModeString = preferences['themeMode'] as String;
          _themeMode = ThemeMode.values.firstWhere(
            (e) => e.toString() == 'ThemeMode.$themeModeString',
            orElse: () => _themeMode,
          );
        }

        if (preferences.containsKey('accentColor')) {
          _accentColor = Color(preferences['accentColor'] as int);
        }

        // Reader settings
        if (preferences.containsKey('readingDirection')) {
          final readingDirectionString =
              preferences['readingDirection'] as String;
          _readingDirection = ReadingDirection.values.firstWhere(
            (e) => e.toString() == 'ReadingDirection.$readingDirectionString',
            orElse: () => _readingDirection,
          );
        }

        if (preferences.containsKey('keepScreenOn')) {
          _keepScreenOn = preferences['keepScreenOn'] as bool;
        }

        if (preferences.containsKey('brightness')) {
          _brightness = preferences['brightness'] as double;
        }

        if (preferences.containsKey('showPageNumber')) {
          _showPageNumber = preferences['showPageNumber'] as bool;
        }

        if (preferences.containsKey('tapToScroll')) {
          _tapToScroll = preferences['tapToScroll'] as bool;
        }

        // Library settings
        if (preferences.containsKey('showUnreadOnly')) {
          _showUnreadOnly = preferences['showUnreadOnly'] as bool;
        }

        if (preferences.containsKey('groupBySource')) {
          _groupBySource = preferences['groupBySource'] as bool;
        }

        // Download settings
        if (preferences.containsKey('downloadOnWifiOnly')) {
          _downloadOnWifiOnly = preferences['downloadOnWifiOnly'] as bool;
        }

        if (preferences.containsKey('maxConcurrentDownloads')) {
          _maxConcurrentDownloads =
              preferences['maxConcurrentDownloads'] as int;
        }

        if (preferences.containsKey('autoDownloadNewChapters')) {
          _autoDownloadNewChapters =
              preferences['autoDownloadNewChapters'] as bool;
        }

        // Privacy settings
        if (preferences.containsKey('secureMode')) {
          _secureMode = preferences['secureMode'] as bool;
        }

        if (preferences.containsKey('requireAuthForStartup')) {
          _requireAuthForStartup = preferences['requireAuthForStartup'] as bool;
        }
      }
    } catch (e) {
      print('Error loading cloud settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    // Save to SharedPreferences
    await _prefs.setString('themeMode', _themeMode.toString().split('.').last);
    await _prefs.setInt('accentColor', _accentColor.value);
    await _prefs.setString(
      'readingDirection',
      _readingDirection.toString().split('.').last,
    );
    await _prefs.setBool('keepScreenOn', _keepScreenOn);
    await _prefs.setDouble('brightness', _brightness);
    await _prefs.setBool('showPageNumber', _showPageNumber);
    await _prefs.setBool('tapToScroll', _tapToScroll);
    await _prefs.setBool('showUnreadOnly', _showUnreadOnly);
    await _prefs.setBool('groupBySource', _groupBySource);
    await _prefs.setBool('downloadOnWifiOnly', _downloadOnWifiOnly);
    await _prefs.setInt('maxConcurrentDownloads', _maxConcurrentDownloads);
    await _prefs.setBool('autoDownloadNewChapters', _autoDownloadNewChapters);
    await _prefs.setBool('secureMode', _secureMode);
    await _prefs.setBool('requireAuthForStartup', _requireAuthForStartup);

    // Save to Firestore if user is logged in
    if (_auth.currentUser != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'preferences': {
              'themeMode': _themeMode.toString().split('.').last,
              'accentColor': _accentColor.value,
              'readingDirection': _readingDirection.toString().split('.').last,
              'keepScreenOn': _keepScreenOn,
              'brightness': _brightness,
              'showPageNumber': _showPageNumber,
              'tapToScroll': _tapToScroll,
              'showUnreadOnly': _showUnreadOnly,
              'groupBySource': _groupBySource,
              'downloadOnWifiOnly': _downloadOnWifiOnly,
              'maxConcurrentDownloads': _maxConcurrentDownloads,
              'autoDownloadNewChapters': _autoDownloadNewChapters,
              'secureMode': _secureMode,
              'requireAuthForStartup': _requireAuthForStartup,
            },
          },
        );
      } catch (e) {
        print('Error saving cloud settings: $e');
      }
    }
  }

  // Theme settings
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    await _saveSettings();
  }

  // Reader settings
  Future<void> setReadingDirection(ReadingDirection direction) async {
    _readingDirection = direction;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setKeepScreenOn(bool value) async {
    _keepScreenOn = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setShowPageNumber(bool value) async {
    _showPageNumber = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setTapToScroll(bool value) async {
    _tapToScroll = value;
    notifyListeners();
    await _saveSettings();
  }

  // Library settings
  Future<void> setShowUnreadOnly(bool value) async {
    _showUnreadOnly = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setGroupBySource(bool value) async {
    _groupBySource = value;
    notifyListeners();
    await _saveSettings();
  }

  // Download settings
  Future<void> setDownloadOnWifiOnly(bool value) async {
    _downloadOnWifiOnly = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setMaxConcurrentDownloads(int value) async {
    _maxConcurrentDownloads = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setAutoDownloadNewChapters(bool value) async {
    _autoDownloadNewChapters = value;
    notifyListeners();
    await _saveSettings();
  }

  // Privacy settings
  Future<void> setSecureMode(bool value) async {
    _secureMode = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setRequireAuthForStartup(bool value) async {
    _requireAuthForStartup = value;
    notifyListeners();
    await _saveSettings();
  }

  // Reset settings to default
  Future<void> resetSettings() async {
    _themeMode = ThemeMode.system;
    _accentColor = Colors.pink;
    _readingDirection = ReadingDirection.leftToRight;
    _keepScreenOn = true;
    _brightness = 1.0;
    _showPageNumber = true;
    _tapToScroll = true;
    _showUnreadOnly = false;
    _groupBySource = false;
    _downloadOnWifiOnly = true;
    _maxConcurrentDownloads = 2;
    _autoDownloadNewChapters = false;
    _secureMode = false;
    _requireAuthForStartup = false;

    notifyListeners();
    await _saveSettings();
  }
}
