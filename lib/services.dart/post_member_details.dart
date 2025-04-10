// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/subscription_model.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/otp_screen.dart';

Future<SubscriptionResponse?> fetchSubscriptionData(
    SubscriptionData subscriptionData) async {
  final url = Uri.parse(
    'https://api.emaryam.com/WebService.asmx/AddSubscription',
  );

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
      },
      body: jsonEncode(
          subscriptionData.toJson()), // Use toJson() instead of manual mapping
      // body: jsonEncode({
      //   "EMagazineType": subscriptionData.eMagazineType,
      //   "Name": subscriptionData.name,
      //   "WhatsappNo": subscriptionData.whatsappNo,
      //   "MobileNo": subscriptionData.mobileNo,
      //   "EmailId": subscriptionData.emailId,
      //   "IssueId": subscriptionData.issueId,
      //   "PostTypeId": subscriptionData.postTypeId,
      //   "Amount": subscriptionData.amount,
      //   "PostTypeAmount": subscriptionData.postTypeAmount,
      //   "TotalAmount": subscriptionData.totalAmount,
      //   "State": subscriptionData.state, //^ STATE NAME
      //   "City": subscriptionData.city,
      //   "PinCode": subscriptionData.pinCode,
      //   "LandMark": subscriptionData.landMark,
      //   "Address": subscriptionData.addedBy,
      //   "AddedBy": 1
      // }),
    );

    if (response.statusCode == 200) {
      // Extracting the "d" field from response
      Map<String, dynamic> rawData = json.decode(response.body);
      String extractedJson = rawData['d'];
      print('✅ (Json): $extractedJson');

      Map<String, dynamic> finalJson = json.decode(extractedJson);
      if (finalJson["status"] == "success" &&
          finalJson["data"] != null &&
          finalJson["data"].isNotEmpty) {
        // int subscriptionId = finalJson["data"][0]["SubscriptionId"];
        // print('✅ Subscription ID: ${finalJson["data"][0]["SubscriptionId"]}');
      } else {
        print('❌ No subscription data found.');
      }

      // Decoding the inner JSON
      Map<String, dynamic> finalData = json.decode(extractedJson);
      print('✅ Subscription ID: ${finalData["data"][0]["SubscriptionId"]}');
      return SubscriptionResponse.fromJson(finalData);
    } else {
      print('Fauld to load data: ${response.statusCode}');
      // print(response.body);
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}





// class AuthService {
//   User user = User();

//   Future<void> sendPhoneNumber(BuildContext context, String phoneNumber) async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             'https://api.emaryam.com/WebService.asmx/AddSubscription'), // Replace with your API URL
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({


//           "EMagazineType": "E Magazine Digitalcopy Only",
//           "Name": "ankit Sir",
//           "WhatsappNo": "9565931965",
//           "MobileNo": "9565931965",
//           "EmailId": "K@gmail.com",
//           "IssueId": 6,
//           "PostTypeId": 2,
//           "Amount": 2000,
//           "PostTypeAmount": 200,
//           "TotalAmount": 2200,
//           "State": "Up",
//           "City": "Deoria",
//           "PinCode": "204505",
//           "LandMark": "mahanagar",
//           "Address": "deoria",
//           "AddedBy": 1


//         }),
//       );

//       if (response.statusCode == 200) {
//         final outerJson = jsonDecode(response.body);
//         final innerJson = jsonDecode(outerJson['d']);
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(content: Text(innerJson['data'][0]['FullName'])));

//         if (innerJson['status'] == 'success' &&
//             innerJson['data'] != null &&
//             innerJson['data'].isNotEmpty &&
//             innerJson['data'][0]['FullName'] != null &&
//             innerJson['data'][0]['FullName'].isNotEmpty) {
//           // print(innerJson['data'][0]['Name']);

//           print(
//               "--------------------------------           inner json is $innerJson");

//           User updatedUser = User(
//             name: innerJson['data'][0]['FullName'],
//             state: innerJson['data'][0]['StateId'],
//             address: innerJson['data'][0]['Address'],
//             email: innerJson['data'][0]['EmailId'],
//             dob: DateTime.tryParse(innerJson['data'][0]['DOB']),
//             gender: innerJson['data'][0]['Gender'],
//             phoneNumber: phoneNumber,
//           );

//           // Save user to SharedPreferences
//           await PreferenceService.saveUser(updatedUser);

//           print("✅ User updated in SharedPreferences: $updatedUser");

//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => OtpScreen(
//                 phoneNumber: phoneNumber.trim(),
//               ),
//             ),
//           );
//         } else {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => OtpScreen(
//                 phoneNumber: phoneNumber.trim(),
//               ),
//             ),
//           );

//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   const SnackBar(content: Text('Name not available')),
//           // );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${response.statusCode}')),
//         );
//         print(response.statusCode);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }
// }
