import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/tab.dart';
import '../screens/otp_screen.dart';

class AuthService {
  Future<void> sendPhoneNumber(BuildContext context) async {
    final response = await http.post(
      Uri.parse("https://api.emaryam.com/WebService.asmx/LoginUserForMobile"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": 'a'}),
    );
    try {
      if (response.statusCode == 200) {
        final outerJson = jsonDecode(response.body);
        final innerJson = jsonDecode(outerJson['d']);

        if (innerJson['status'] == 'success' &&
            innerJson['data'] != null &&
            innerJson['data'].isNotEmpty &&
            innerJson['data'][0]['Name'] != null &&
            innerJson['data'][0]['Name'].isNotEmpty) {
          // ignore: avoid_print
          print(innerJson['data'][0]['Name']);

          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('Success!')));

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => MyTabBar()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name not available')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
