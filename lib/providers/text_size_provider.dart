import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';

// class TextSizeProvider extends ChangeNotifier {
//   double _textSize = 16.0; // Default text size

//   double get textSize => _textSize;

//   TextSizeProvider() {
//     loadTextSize();
//   }

//   Future<void> loadTextSize() async {
//     _textSize = await PreferenceService.getTextSize();
//     notifyListeners();
//   }

//   Future<void> setTextSize(double size) async {
//     _textSize = size;
//     await PreferenceService.saveTextSize(size);
//     notifyListeners();
//   }
// }

class TextSizeProvider extends ChangeNotifier {
  double _textSize = 12.0; // Default initially
  bool _initialized = false;

  double get textSize => _textSize;
  bool get initialized => _initialized;

  TextSizeProvider() {
    loadTextSize();
  }

  Future<void> loadTextSize() async {
    _textSize = await PreferenceService.getTextSize();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setTextSize(double size) async {
    _textSize = size;
    await PreferenceService.saveTextSize(size);
    notifyListeners();
  }
}
