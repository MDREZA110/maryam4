// // ignore_for_file: avoid_print, duplicate_ignore

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:maryam/services.dart/api_service.dart';
// import 'package:maryam/tabs/magzine.dart';
// import 'package:maryam/tabs/tab.dart';
// import 'package:maryam/screens/otp_screen.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   TextEditingController phoneNumberController = TextEditingController();

// // false

//   // String? _validatePhone(String value) {
//   //   if (value.isEmpty) {
//   //     return 'Phone number is required';
//   //   } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//   //     return 'Enter a valid 10-digit phone number';
//   //   }
//   //   return null;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // bool isvalidOnpressed = false;
//     //String myHintText = " -  -  -  -  -  -  -  -  -  -";
//     bool isDarkMode =
//         MediaQuery.of(context).platformBrightness == Brightness.dark;

//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Image.asset(
//             'assets/images/bg_image.png',
//             fit: BoxFit.cover,
//           ),
//           Container(color: const Color.fromARGB(162, 103, 6, 58)),
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Image.asset('assets/images/logo.png'),
//                 ),
//                 const SizedBox(height: 35),

// //^ signup

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 40),
//                   child: Container(
//                     width: 320,
//                     padding: const EdgeInsets.only(
//                         left: 16, right: 16, bottom: 20, top: 6),
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? const Color.fromARGB(255, 44, 44, 44)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           height: 16,
//                         ),
//                         const Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             fontSize: 42,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFFCD3864),
//                             fontFamily: 'Inter',
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           "with phone number",
//                           style: TextStyle(
//                               fontSize: 14,
//                               color:
//                                   isDarkMode ? Colors.white60 : Colors.black54),
//                         ),
//                         const SizedBox(height: 12),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 11),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               border:
//                                   Border.all(color: Colors.black54, width: 1.5),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 16),
//                                   child: Text(
//                                     "+91",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       //fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: TextField(
//                                     controller: phoneNumberController,
//                                     keyboardType: TextInputType.phone,
//                                     decoration: InputDecoration(
//                                       // errorText: validatePassword(
//                                       //     passwordController.text),
//                                       hintText: " -  -  -  -  -  -  -  -  -  -",

//                                       hintStyle: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.white70
//                                               : Colors.black38,
//                                           fontSize: 16),
//                                       border: InputBorder.none,
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               vertical: 12),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         ElevatedButton(
//                           onPressed: () async {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => OtpScreen(
//                                       phoneNumber: phoneNumberController.text,
//                                     )));
//                             // if (_validatePhone(
//                             //         phoneNumberController.text.trim()) ==
//                             //     null) {
//                             //   setState(() {
//                             //     isvalidOnpressed = true;
//                             //   });
//                             // }
//                             //String  phoneNumber= phoneNumberController.text.trim();

//                             // if (isvalidOnpressed == true) {
//                             //   // Replace with actual password logic

//                             // }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             //backgroundColor: const Color(0xFFCD3864), //#CD3864
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 40, vertical: 15),

//                             shadowColor: isDarkMode
//                                 ? Colors.transparent
//                                 : Colors.pink.shade300,
//                             elevation: 5,
//                           ),
//                           child: Text(
//                             "Get OTP",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color:
//                                     isDarkMode ? Colors.white54 : Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 80,
//             left: 00,
//             right: 00,
//             top: 650,
//             child: Center(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 127, vertical: 15),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => const MyTabBar()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         isDarkMode ? Colors.black45 : Colors.grey, //#CD3864
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),

//                     shadowColor: const Color.fromARGB(255, 26, 26, 26),
//                     elevation: 5,
//                   ),
//                   child: Center(
//                     child: Row(
//                       children: [
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text(
//                           "Skip",
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: isDarkMode
//                                   ? const Color.fromARGB(255, 142, 142, 142)
//                                   : const Color.fromARGB(255, 51, 51, 51),
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Icon(
//                           Icons.arrow_circle_right_rounded,
//                           size: 20,
//                           color: isDarkMode
//                               ? const Color.fromARGB(255, 142, 142, 142)
//                               : const Color.fromARGB(255, 51, 51, 51),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const Positioned(
//             bottom: 40,
//             left: 0,
//             right: 0,
//             top: 740,
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Facing difficulties?',
//                       style: TextStyle(
//                         color: Colors.white,
//                       )),
//                   Text(' Chat with us',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//!_________________________________  current  code  _______________________________________

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/screens/otp_screen.dart';
import 'package:maryam/services.dart/api_service.dart';
import 'package:maryam/services.dart/fetch_otp.dart';
import 'package:maryam/tabs/tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maryam/models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _errorText; // Holds the error message
  User randomUser = User();

  // One function to generate and save a random user
  // Future<void> _generateAndSaveUser(BuildContext context) async {
  //   User randomUser = User(
  //     name: "raza",
  //     state: "1",
  //     stateName: "Lucknow",
  //     phoneNumber: "6394895557",
  //     address: "house",
  //     email: "user@example.com",
  //     dob: DateTime(1990, 5, 5),
  //     gender: "Male",
  //     imgPath: "aaa.png",
  //     whatsappNumber: "6394895557",
  //   );

  //   await PreferenceService.saveUser(randomUser);

  //   // Show confirmation message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Random user saved!")),
  //   );
  // }

//*  working code
  Future<void> validateAndNavigate() async {
    String value = phoneNumberController.text;

    if (value.isEmpty) {
      setState(() {
        _errorText = "Please enter a number";
      });
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      setState(() {
        _errorText = "Enter a valid 10-digit number";
      });
    } else {
      setState(() {
        _errorText = null; // No error
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("  ✅    navigating...")),
      );

      fetchOtp(context, value.trim());
      //   final authService = AuthService();
      //   await authService.sendPhoneNumber(
      //       context, phoneNumberController.text.trim());
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset('assets/images/bg_image.png', fit: BoxFit.cover),
          Container(color: const Color.fromARGB(162, 103, 6, 58)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    width: 320,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFCD3864)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "with phone number",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.black54, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text("+91",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Expanded(
                                  child: TextField(
                                    //TODO
                                    cursorErrorColor:
                                        const Color.fromARGB(255, 123, 43, 37),
                                    controller: phoneNumberController,
                                    keyboardType: TextInputType.phone,

                                    decoration: InputDecoration(
                                      hintText: " -  -  -  -  -  -  -  -  -  -",
                                      hintStyle: TextStyle(
                                          color: Colors.black38, fontSize: 16),
                                      // errorText: _errorText,
                                      // errorStyle: TextStyle(
                                      //   color: const Color.fromARGB(
                                      //       255, 123, 43, 37),
                                      //   // fontSize: 16
                                      // ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_errorText != null && _errorText!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text(
                                " ${_errorText!}   !! ", // <-- _errorText! could be null here
                                style: TextStyle(
                                  color: Color.fromARGB(255, 123, 43, 37),
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          //^ OTP  onPressed
                          onPressed: () {
                            validateAndNavigate();

                            //   //! for testing shared pref
                            //  // _generateAndSaveUser(context);
                            //   Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         OtpScreen(phoneNumber: "6394895557"),
                            //   ));

                            //!_____________________________________________
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shadowColor: Colors.pink.shade300,
                            elevation: 5,
                          ),
                          child: Text(
                            "Get OTP",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

//!  SKIP buttone
          Positioned(
            top: 655,
            bottom: 80,
            left: 00,
            right: 00,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 127, vertical: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    // SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();
                    // await prefs.clear();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyTabBar()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, //#CD3864
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    shadowColor: const Color.fromARGB(255, 26, 26, 26),
                    elevation: 5,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Skip",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 51, 51, 51),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 20,
                          color: Color.fromARGB(255, 51, 51, 51),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            top: 740,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Facing difficulties?',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                Text(' Chat with us',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
