// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsTile extends StatefulWidget {
  final String imgpath;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double? imgHeight;

  const SettingsTile(
      {super.key,
      required this.imgpath,
      required this.title,
      this.onTap,
      this.trailing,
      this.imgHeight = 30});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  // bool isDarkMode = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadUserAndPreferences();
  // }

  // //! new shared pref
  // Future<void> _loadUserAndPreferences() async {
  //   // Load user using PreferenceService instead of local method

  //   // Load preferences
  //   try {
  //     bool darkMode = await PreferenceService.getDarkMode();

  //     setState(() {
  //       isDarkMode = darkMode;
  //     });
  //   } catch (e) {
  //     print('Error loading preferences: $e');
  //   }
  // }

  // isDarkMode ? Colors.black : Colors.white,
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return ListTile(
      leading:
          // Image.asset(
          //   imgpath,
          //   height: imgHeight,
          //   width: imgHeight,
          //   color: isDarkMode ? Colors.white : Colors.black87,
          // ),

          SizedBox(
        width: 37,
        // 30,
        child: Center(
          child: Image.asset(
            widget.imgpath,
            height: widget.imgHeight,
            width: widget.imgHeight,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      title: Text(widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          )),
      trailing: widget.trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
      onTap: widget.onTap,
    );
  }
}
