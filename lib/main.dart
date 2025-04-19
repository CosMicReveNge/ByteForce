import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:testflutter/screens/home_screen.dart';
import 'package:testflutter/providers/manga_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MangaProvider(),
      child: MaterialApp(
        title: 'Manga Reader',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            elevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
