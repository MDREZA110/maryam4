import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:maryam/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a preferences service class with proper naming conventions
class PreferenceService {
  static const String userKey = "user";
  static const String textSizeKey = "text_size";
  static const String darkModeKey = "is_dark_mode";

  // Save user data
  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(userKey, userJson);
  }

  // Get user data
  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(userKey);
    if (userJson == null) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  // Save text size
  static Future<void> saveTextSize(double size) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(textSizeKey, size);
  }

  // Get text size with default
  static Future<double> getTextSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(textSizeKey) ?? 16.0;
  }

  // Save dark mode
  static Future<void> saveDarkMode(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, isDarkMode);
  }

  // Get dark mode with default
  static Future<bool> getDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModeKey) ?? false;
  }
}
