// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/services.dart/check_otp_api.dart';
import 'package:maryam/services.dart/fetch_otp.dart';
import 'package:maryam/services.dart/verify_otp.dart';
import 'package:maryam/tabs/homeScreen/home_screen.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/services.dart/api_service.dart';
import 'package:maryam/tabs/magzine.dart';
import 'package:maryam/tabs/tab.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  const OtpScreen({super.key, required this.phoneNumber, required this.otp});

  @override
  // ignore: library_private_types_in_public_api
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _counter = 30;
  Timer? _timer;
  //late String _generatedOtp;
  String _enteredOtp = '';
  String? message;

  @override
  void initState() {
    super.initState();
    //  _generatedOtp = _generateOtp();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your OTP: ${widget.otp}')),
      );
    });
    startTimer();

    // sendWhatsAppMessage(
    //     username: 'maryam', password: "pwd@123", message: _generatedOtp);
  }

  // User? _user;

  // Future<void> _loadUserData() async {
  //   User? user = await PreferenceService.getUser();
  //   setState(() {
  //     _user = user;
  //   });
  // }

  //^ Generates a 4-digit OTP
  // String _generateOtp() {
  //   final random = Random();
  //   final otp = (random.nextInt(9000) + 1000).toString();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Your OTP: $otp')),
  //     );
  //   });
  //   return otp;
  // }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "   Please Enter OTP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              length: 4,
              showCursor: true,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCD3864), width: 2),
                  color: Colors.white,
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCD3864), width: 2),
                  color: Colors.white,
                ),
              ),
              onCompleted: (pin) {
                _enteredOtp = pin;
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  //#CD3864
                  "Resend Code in:",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  "00:$_counter",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFCD3864),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                _timer?.cancel();
                setState(() async {
                  _counter = 30;

                  fetchOtp(context, widget.phoneNumber.trim());
                  //TODO
                  // _generatedOtp = _generateOtp();

                  // final authService = AuthService();
                  // await authService.reSendOtp(
                  //     context, widget.phoneNumber.trim());
                  // _loadUserData();
                  startTimer();
                });
              },
              child: const Text("Resend Again?",
                  style: TextStyle(
                    color: Color(0xFFCD3864),
                  )),
            ),
            const SizedBox(height: 8),

            //^comented for testing
            // if (message! == "OTP does not match") const SizedBox(height: 12),
            ElevatedButton(
//               onPressed: () async {
//                 if (_counter > 0) {
//                   //TODO
//                   verifyOtp(
//                       context, widget.otp.trim(), widget.phoneNumber.trim());
// //&  ---------------    comented for testing    ------------------------
//                   // final otpApiObj = OtpApis();
//                   // setState(() async {
//                   //   message = await otpApiObj.checkOtp(
//                   //       context, widget.phoneNumber.trim(), _enteredOtp.trim());
//                   //   _loadUserData();
//                   // });
//                   verifyOtp(
//                       context, widget.otp.trim(), widget.phoneNumber.trim());

//                   // if (message != "OTP does not match") {
//                   //   _user == null
//                   //       ? Navigator.of(context).push(MaterialPageRoute(
//                   //           builder: (context) => PersonaldetailScreen(
//                   //               phone: widget.phoneNumber.trim()),
//                   //         ))
//                   //       : Navigator.of(context).push(MaterialPageRoute(
//                   //           builder: (context) => MyTabBar(),
//                   //         ));
//                   // }
// //&  -----------------------------------------------------------------------

//                   // if (_enteredOtp == _generatedOtp) {
//                   //   final authService = AuthService();
//                   //   await authService.sendPhoneNumber(
//                   //       context, widget.phoneNumber.trim());
//                   // } else {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     const SnackBar(content: Text('Invalid OTP')),
//                   //   );
//                   // }
//                 }
//               },

              onPressed: () async {
                if (_counter > 0) {
                  print(
                      "🔹 Verifying OTP: $_enteredOtp for ${widget.phoneNumber}");

                  // Call verifyOtp and wait for response
                  await verifyOtp(
                      context, _enteredOtp.trim(), widget.phoneNumber.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCD3864),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Continue",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
