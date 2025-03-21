import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maryam/screens/signup.dart';
//import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Container(
      //   color: const Color(0xFFEB268F),
      //   child:
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/bg_image.png',
            fit: BoxFit.cover,
          ),
          Container(color: const Color.fromARGB(162, 103, 6, 58)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
        ],
        // ),
      ),
    );
  }
}

// void main() {
//   runApp(const MaterialApp(
//     home: SplashScreen(),
//   ));
// }
