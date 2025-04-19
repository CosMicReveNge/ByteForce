import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:MangaLo/screens/home_screen.dart';
import 'package:MangaLo/screens/library/library_screen.dart';
import 'package:MangaLo/screens/auth/login_screen.dart';
import 'package:MangaLo/screens/communities/communities_screen.dart';
import 'package:MangaLo/providers/manga_provider.dart';
import 'package:MangaLo/providers/auth_provider.dart';
import 'package:MangaLo/providers/download_provider.dart';
import 'package:MangaLo/providers/history_provider.dart';
import 'package:MangaLo/providers/settings_provider.dart';
import 'package:MangaLo/providers/community_provider.dart';
import 'package:MangaLo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MangaProvider()),
        ChangeNotifierProvider(create: (context) => DownloadProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => CommunityProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'MangaLo',
            theme: ThemeData(
              primarySwatch: Colors.pink,
              textTheme: GoogleFonts.nunitoTextTheme().apply(),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ).copyWith(inherit: true),
              ),
              scaffoldBackgroundColor: Colors.grey[50],
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.pink,
              textTheme: GoogleFonts.nunitoTextTheme(
                Typography.whiteMountainView,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                elevation: 0,
                titleTextStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ).copyWith(inherit: true),
              ),
            ),
            themeMode: _mapAppThemeModeToFlutter(settingsProvider.themeMode),
            home: const AuthGate(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.status == AuthStatus.initial ||
            authProvider.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (authProvider.isAuthenticated) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

// Helper to map AppThemeMode to Flutter's ThemeMode
ThemeMode _mapAppThemeModeToFlutter(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
    default:
      return ThemeMode.system;
  }
}

// Bottom navigation screen
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    const Placeholder(), // History screen
    const Placeholder(), // Browse screen
    const CommunitiesScreen(), // Replaced More with Communities
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Communities',
          ),
        ],
      ),
    );
  }
}
