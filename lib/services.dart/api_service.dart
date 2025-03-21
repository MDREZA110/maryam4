// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/user.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/otp_screen.dart';

class AuthService {
  User user = User();

  Future<void> sendPhoneNumber(BuildContext context, String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.emaryam.com/WebService.asmx/LoginUserForMobile'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'UserName': phoneNumber}),
      );

      if (response.statusCode == 200) {
        final outerJson = jsonDecode(response.body);
        final innerJson = jsonDecode(outerJson['d']);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(innerJson['data'][0]['FullName'])));

        if (innerJson['status'] == 'success' &&
            innerJson['data'] != null &&
            innerJson['data'].isNotEmpty &&
            innerJson['data'][0]['FullName'] != null &&
            innerJson['data'][0]['FullName'].isNotEmpty) {
          // print(innerJson['data'][0]['Name']);

          print(
              "--------------------------------           inner json is $innerJson");

          User updatedUser = User(
            name: innerJson['data'][0]['FullName'],
            state: innerJson['data'][0]['StateId'], // .toString()
            address: innerJson['data'][0]['Address'],
            email: innerJson['data'][0]['EmailId'],
            dob: DateTime.tryParse(innerJson['data'][0]['DOB']),
            //  innerJson['data'][0]['DOB'],
            gender: innerJson['data'][0]['Gender'],
            phoneNumber: phoneNumber,
            stateName: 'aa',
          );

          // print(" user name : ${updatedUser.name}");
          // print(" phone no : ${updatedUser.phoneNumber}");

          // Save updated user to SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String userJson = jsonEncode(updatedUser.toJson());
          await prefs.setString("user", userJson);

          print("✅ User updated in SharedPreferences: $userJson");

          String? storedUser = prefs.getString("user");
          print("✅ Retrieved from SharedPreferences: $storedUser");

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                otp: '000',
                phoneNumber: phoneNumber.trim(),
              ),
            ),
          );

          //! Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyTabBar()));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                otp: '0000',
                phoneNumber: phoneNumber.trim(),
              ),
            ),
          );

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Name not available')),
          // );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
        print(response.statusCode);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  //^    reSendOtp

  Future<void> reSendOtp(BuildContext context, String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.emaryam.com/WebService.asmx/LoginUserForMobile'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'UserName': phoneNumber}),
      );

      if (response.statusCode == 200) {
        final outerJson = jsonDecode(response.body);
        final innerJson = jsonDecode(outerJson['d']);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(innerJson['data'][0]['FullName'])));

        if (innerJson['status'] == 'success' &&
            innerJson['data'] != null &&
            innerJson['data'].isNotEmpty &&
            innerJson['data'][0]['FullName'] != null &&
            innerJson['data'][0]['FullName'].isNotEmpty) {
          // print(innerJson['data'][0]['Name']);

          print(
              "--------------------------------           inner json is $innerJson");

          User updatedUser = User(
            name: innerJson['data'][0]['FullName'],
            state: innerJson['data'][0]['StateId'], // .toString()
            address: innerJson['data'][0]['Address'],
            email: innerJson['data'][0]['EmailId'],
            dob: DateTime.tryParse(innerJson['data'][0]['DOB']),
            //  innerJson['data'][0]['DOB'],
            gender: innerJson['data'][0]['Gender'],
            phoneNumber: phoneNumber,
            stateName: 'aa',
          );

          // print(" user name : ${updatedUser.name}");
          // print(" phone no : ${updatedUser.phoneNumber}");

          // Save updated user to SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String userJson = jsonEncode(updatedUser.toJson());
          await prefs.setString("user", userJson);

          print("✅ User updated in SharedPreferences: $userJson");

          String? storedUser = prefs.getString("user");
          print("✅ Retrieved from SharedPreferences: $storedUser");
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Name not available')),
          // );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
        print(response.statusCode);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
