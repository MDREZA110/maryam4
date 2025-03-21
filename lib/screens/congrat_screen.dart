// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/tabs/tab.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class CongratScreen extends StatefulWidget {
  //final String imgpath;
  const CongratScreen({
    super.key,
  });

  @override
  State<CongratScreen> createState() => _CongratScreenState();
}

class _CongratScreenState extends State<CongratScreen> {
  User user = User();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      // loadUser();
      _loadUserAndPreferences();
    });
    // Start a timer that navigates to the home screen after 4 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const MyTabBar(),
      ));
    });
  }

  //   //*  load user data Shared prefrence
  // Future<User?> getUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? userJson = prefs.getString('user');

  //   if (userJson == null) return null; // No user data found

  //   return User.fromJson(jsonDecode(userJson)); // Convert JSON to User model
  // }

  // void loadUser() async {
  //   User? loadedUser = await getUser();
  //   if (loadedUser != null) {
  //     setState(() {
  //       user = loadedUser;
  //     });
  //   }
  // }

//!  new_shared_Pref

  Future<void> _loadUserAndPreferences() async {
    // Load user using PreferenceService instead of local method
    User? loadedUser = await PreferenceService.getUser();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
      });
    }

    // Load preferences
    try {
      bool darkMode = await PreferenceService.getDarkMode();
      // double size = await PreferenceService.getTextSize();

      setState(() {
        isDarkMode = darkMode;
      });
    } catch (e) {
      print('Error loading preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/bg_image.png',
            fit: BoxFit.cover,
          ),
          Container(color: const Color.fromARGB(162, 103, 6, 58)),
          Center(
            child: SizedBox(
              width: 400,
              child: Stack(
                clipBehavior: Clip.none, // Prevent clipping
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      height: 250, // Increased height for spacing
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Text(
                            "Congratulations! 🎉",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Your account is now active.\n"
                            "Get ready to explore—\n"
                            "Redirecting you to the Home \n page in a few seconds...",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50, // Moves avatar above card
                    left: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white, // Blend with card
                      child: ClipOval(
                        child: Image.asset(
                          user.gender.toString() == 'Male'
                              ? "assets/images/man.png"
                              : "assets/images/women.png",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
