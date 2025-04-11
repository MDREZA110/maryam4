import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/signup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';

class MagzineTab extends StatefulWidget {
  const MagzineTab({super.key});

  @override
  State<MagzineTab> createState() => _MagzineTabState();
}

class _MagzineTabState extends State<MagzineTab> {
  User user = User();

  @override
  void initState() {
    super.initState();
    loadUser(); // Load user on widget init
  }

  Future<void> loadUser() async {
    User? loadedUser = await PreferenceService.getUser();
    setState(() {
      user = loadedUser ?? User(); // In case null, use empty User object
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    bool isNameEmpty = user.name == null || user.name!.trim().isEmpty;

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Center(
        child: isNameEmpty
            ? SizedBox(
                height: 60,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text('Login',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            : Text(
                'no magzine',
                style: TextStyle(
                    fontSize: 20,
                    //  fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 67, 67, 67)),
              ),
      ),
    );
  }
}

class Mytabbar {
  const Mytabbar();
}
