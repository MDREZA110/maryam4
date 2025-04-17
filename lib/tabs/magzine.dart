import 'package:flutter/material.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/signup.dart';
import 'package:maryam/services.dart/fetch_otp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';

class MagzineTab extends StatefulWidget {
  const MagzineTab({super.key});

  @override
  State<MagzineTab> createState() => _MagzineTabState();
}

class _MagzineTabState extends State<MagzineTab> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _errorText; // Holds the error message
  User randomUser = User();

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
//^ api call

      fetchOtp(context, value.trim());

//^-----

      //   final authService = AuthService();
      //   await authService.sendPhoneNumber(
      //       context, phoneNumberController.text.trim());
      // }
    }
  }

  User user = User();
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    loadUser(); // Load user on widget init
  }

  Future<void> loadUser() async {
    User? loadedUser = await PreferenceService.getUser();
    setState(() {
      user = loadedUser ?? User(); // In case null, use empty User object
      isLoading = false; // Set loading to false after user is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider
    bool isNameEmpty = user.name == null || user.name!.trim().isEmpty;

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Center(
        child: isLoading
            ? SizedBox() // Show a loading spinner while loading
            : isNameEmpty
                // ? SizedBox(
                //     height: 60,
                //     width: 150,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(builder: (context) => SignUpScreen()),
                //         );
                //       },
                //       child: Text('Login',
                //           style: TextStyle(fontSize: 18, color: Colors.white)),
                //     ),
                //   )

                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 11),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.black54, width: 1.5),
                                    ),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Text("+91",
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            //TODO
                                            cursorErrorColor:
                                                const Color.fromARGB(
                                                    255, 123, 43, 37),
                                            controller: phoneNumberController,
                                            keyboardType: TextInputType.phone,

                                            decoration: InputDecoration(
                                              hintText:
                                                  " -  -  -  -  -  -  -  -  -  -",
                                              hintStyle: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 16),
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
                                if (_errorText != null &&
                                    _errorText!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 6),
                                      Text(
                                        " ${_errorText!}   !! ", // <-- _errorText! could be null here
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 123, 43, 37),
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
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    shadowColor: Colors.pink.shade300,
                                    elevation: 5,
                                  ),
                                  child: Text(
                                    "Get OTP",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    'no magzine',
                    style: TextStyle(
                        fontSize: 20,
                        //  fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(255, 67, 67, 67)),
                  ),
      ),
    );
  }
}

class Mytabbar {
  const Mytabbar();
}
