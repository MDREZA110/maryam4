// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:maryam/screens/otp_screen.dart';

Future<void> fetchOtp(BuildContext context, String phoneNumber) async {
  final url =
      Uri.parse('https://api.emaryam.com/WebService.asmx/LoginUserForMobile');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Set JSON content type
      },
      body: jsonEncode({
        "UserName": phoneNumber, // Sending phone number in request
      }),
    );
    if (response.statusCode == 200) {
      // First-level decoding
      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey('d')) {
        // Second-level decoding
        final nestedDecoded = jsonDecode(decodedResponse['d']);

        if (nestedDecoded is Map<String, dynamic>) {
          final status = nestedDecoded['status'];
          final message = nestedDecoded['message'];
          final otp = nestedDecoded['otp'];

          print('Status: $status');
          print('Message: $message');
          print('OTP: $otp');

          // Navigate to OTP Screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => OtpScreen(phoneNumber: phoneNumber, otp: otp),
          ));
        }
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
