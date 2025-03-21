// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/screens/signup.dart';

import 'package:maryam/tabs/magzine.dart';
// ignore: unused_import
import 'package:maryam/tabs/tab.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/providers/text_size_provider.dart';

// ignore: unused_import
import 'package:maryam/splash_screen.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Option 1: If you need to bypass certificate verification (for development only)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized(); // Ensure platform initialization

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TextSizeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return MaterialApp(
      title: 'maryam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Urbanist',
        cardColor: isDarkMode
            ? const Color.fromARGB(221, 192, 192, 192)
            : Colors.white,
        appBarTheme: AppBarTheme(
          color: isDarkMode ? Colors.black87 : Colors.white,
        ),
        scaffoldBackgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCD3864),
          ),
        ),
      ),

      // darkTheme: ThemeData.dark(  //^  darkTheme  causing font issues

      //     // useMaterial3: true,
      //     ), // Define dark theme
      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light, // User-controlled theme
      home: const SplashScreen(),
    );
  }
}






// class MyApp extends StatelessWidget {
//   const MyApp({
//     super.key,
//   });

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     // bool isDarkMode =
//     //     MediaQuery.of(context).platformBrightness == Brightness.dark;

//     return MaterialApp(
//         title: 'maryam',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//           fontFamily: 'Urbanist',
//           scaffoldBackgroundColor: isDarkMode ? Colors.black87 : Colors.white,

//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFCD3864),
//             ),
//           ),
//         ),
//         darkTheme: ThemeData.dark(
//           useMaterial3: true,
//         ),
//         themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
//         home: const SplashScreen());
//   }
// }
