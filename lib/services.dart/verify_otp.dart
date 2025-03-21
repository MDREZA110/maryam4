// // ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/personaldetail_screen.dart';

import 'package:maryam/tabs/tab.dart';

// Future<void> verifyOtp(
//     BuildContext context, String otp, String phoneNumber) async {
//   final url = Uri.parse('https://api.emaryam.com/WebService.asmx/CheckOtp');

//   try {
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"OTP": otp, "UserName": phoneNumber}),
//     );

//     print("🔹 API Response Status: ${response.statusCode}");
//     print("🔹 API Response Body: ${response.body}");

//     if (response.statusCode == 200) {
//       final decodedResponse = jsonDecode(response.body);

//       if (decodedResponse is Map<String, dynamic> &&
//           decodedResponse.containsKey('d')) {
//         final nestedDecoded = decodedResponse['d'];

//         if (nestedDecoded is Map<String, dynamic>) {
//           final message = nestedDecoded['message'];

//           // 🚨 If OTP is incorrect, show error and STOP
//           if (message == "OTP does not match") {
//             print("❌ Invalid OTP! Not navigating.");
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Invalid OTP. Please try again.")),
//             );
//             return; // 🚨 Stop execution here!
//           }

//           final dataList = nestedDecoded['data'] as List<dynamic>?;
//           User? user;

//           if (dataList != null && dataList.isNotEmpty) {
//             final userData = dataList.first as Map<String, dynamic>;

//             user = User(
//               userId: userData['UserId'].toString(),
//               name: userData['Name'],
//               state: userData['StateId']?.toString(),
//               phoneNumber: userData['MobileNo'],
//               address: userData['Address'],
//               email: userData['EmailId'],
//               gender: userData['Gender'],
//               imgPath: userData['ProfilePic'],
//               whatsappNumber: userData['MobileNo'],
//               stateName: null,
//               dob: _parseDate(userData['DOB']),
//             );

//             // ✅ Save User Data to SharedPreferences
//             await PreferenceService.saveUser(user);
//             print("✅ User saved successfully!");
//           }

//           // ✅ Navigation Logic
//           if (user?.name == null) {
//             print("🔹 Name is NULL, navigating to PersonalDetailScreen.");
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) =>
//                   PersonaldetailScreen(phone: phoneNumber.trim()),
//             ));
//           } else {
//             print("🔹 Name exists, navigating to MyTabBar.");
//             Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (context) => MyTabBar(),
//             ));
//           }
//         }
//       }
//     } else {
//       print('❌ Failed to verify OTP. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('❌ Error: $e');
//   }
// }

// // // Helper function to parse date
DateTime? _parseDate(String? dateString) {
  if (dateString == null) return null;
  final timestampMatch = RegExp(r"\/Date\((\d+)\)\/").firstMatch(dateString);
  if (timestampMatch != null) {
    final milliseconds = int.parse(timestampMatch.group(1)!);
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }
  return null;
}

Future<void> verifyOtp(
    BuildContext context, String otp, String phoneNumber) async {
  final url = Uri.parse('https://api.emaryam.com/WebService.asmx/CheckOtp');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"OTP": otp, "UserName": phoneNumber}),
    );

    print("🔹 API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('d')) {
        final nestedDecoded = decodedResponse['d'];

        // 🔹 Case 1: OTP **Invalid** (New Response Format)
        if (nestedDecoded is Map<String, dynamic> &&
            nestedDecoded.containsKey('data')) {
          final dataList = nestedDecoded['data'] as List<dynamic>?;

          if (dataList != null && dataList.isNotEmpty) {
            final firstData = dataList.first as Map<String, dynamic>;
            final message = firstData['Message'] ?? "";

            if (message == "OTP does not match") {
              print("❌ Invalid OTP! Not navigating.");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Invalid OTP. Please try again.")),
              );
              return; // 🚨 Stop execution here!
            }
          }
        }

        // 🔹 Case 2: OTP **Valid** (Old Response Format with User Data)
        User? user;
        if (nestedDecoded is Map<String, dynamic> &&
            nestedDecoded.containsKey('data')) {
          final dataList = nestedDecoded['data'] as List<dynamic>?;

          if (dataList != null && dataList.isNotEmpty) {
            final userData = dataList.first as Map<String, dynamic>;

            user = User(
              userId: userData['UserId'].toString(),
              name: userData['Name'],
              state: userData['StateId']?.toString(),
              phoneNumber: userData['MobileNo'],
              address: userData['Address'],
              email: userData['EmailId'],
              gender: userData['Gender'],
              imgPath: userData['ProfilePic'],
              whatsappNumber: userData['MobileNo'],
              stateName: null,
              dob: _parseDate(userData['DOB']),
            );

            // ✅ Save User Data to SharedPreferences
            await PreferenceService.saveUser(user);
            print("✅ User saved successfully!");
          }
        }

        // ✅ Navigation Logic
        if (user?.name == null) {
          print("🔹 Name is NULL, navigating to PersonalDetailScreen.");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PersonaldetailScreen(phone: phoneNumber.trim()),
          ));
        } else {
          print("🔹 Name exists, navigating to MyTabBar.");
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyTabBar(),
          ));
        }
      }
    } else {
      print('❌ Failed to verify OTP. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
