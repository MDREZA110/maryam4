import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class MagzineTab extends StatefulWidget {
  const MagzineTab({super.key});

  @override
  State<MagzineTab> createState() => _MagzineTabState();
}

class _MagzineTabState extends State<MagzineTab> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Center(
        child: Text(
          'Magazine Tab',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class Mytabbar {
  const Mytabbar();
}
