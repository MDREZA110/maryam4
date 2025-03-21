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

class OtpApis {
  Future<String?> checkOtp(
      BuildContext context, String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emaryam.com/WebService.asmx/CheckOtp'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {"phoneNumber": phoneNumber, "OTP": otp},
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data["d"]["data"][0]["Message"];
        // return data["d"]?["data"]?[0]?["Message"] ?? "No message found";
      } else {
        print("Failed to send message. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

//^ ai generated
//   Future<String?> sendMessage(String phoneNumber, String otp) async {
//   final url = Uri.parse('https://yourapi.com/sendMessage'); // Replace with actual API endpoint

//   try {
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "phoneNumber": phoneNumber,
//         "OTP": otp
//       }),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = jsonDecode(response.body);

//       // Extract "Message" from the response
//       return data["d"]?["data"]?[0]?["Message"] ?? "No message found";
//     } else {
//       print("Failed to send message. Status: ${response.statusCode}");
//       return null;
//     }
//   } catch (e) {
//     print("Error: $e");
//     return null;
//   }
// }
}
