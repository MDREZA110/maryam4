// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/congrat_screen.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/tab.dart';
import '../screens/otp_screen.dart';

class RegisterUser {
  Future<void> sendDetails(BuildContext context, User user) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.emaryam.com/WebService.asmx/UserRegistration'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            "FullName": user.name!,
            "Stateid": 1,
            "MobileNo": user.phoneNumber!,
            "EmailId": user.email!,
            "Address": user.address!,
            "DOB":
                "${user.dob?.month}/${user.dob?.day}/${user.dob?.year}", //^ NOW ADDED    format{MM/DD/YYYY}
            //   user.dob!,
            "Gender": user.gender!,
            "AddedBy": 1,
            "ProfilePic": "dfsd123"
          },
        ),
      );
      print('Full Response: ${response.body}');
      if (response.statusCode == 200) {
        final outerJson = jsonDecode(response.body);
        final innerJson = jsonDecode(outerJson['d']);

        if (innerJson['status'] == 'success' &&
            innerJson['data'] != null &&
            innerJson['data'].isNotEmpty &&
            innerJson['data'][0]['FullName'] != null &&
            innerJson['data'][0]['FullName'].isNotEmpty) {
          // ignore: avoid_print+

          print(innerJson['data'][0]['FullName']);

          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text('Success!')));

          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CongratScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not registered, try again later')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
