import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await PreferenceService.saveDarkMode(_isDarkMode);
    notifyListeners(); // Notify UI to rebuild
  }

  Future<void> loadTheme() async {
    _isDarkMode = await PreferenceService.getDarkMode();
    notifyListeners();
  }
}
