// ignore_for_file: unused_import, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/screens/signup.dart';
import 'package:maryam/screens/update_details.dart';
import 'package:maryam/tabs/settings/aboutus.dart';
import 'package:maryam/tabs/settings/cancellationrefundpolicy.dart';
import 'package:maryam/tabs/settings/contactus.dart';
import 'package:maryam/tabs/settings/privacy_policy.dart';
import 'package:maryam/tabs/settings/shippinganddelivery_policy.dart';
import 'package:maryam/screens/personaldetail_screen.dart';
import 'package:maryam/tabs/settings/text_slider_Screen.dart';
import 'package:maryam/widgets/mylistile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:maryam/providers/theme_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  // bool isDarkMode = false;
  User user = User();
  String name = "Guest";
  String phoneNumber = "0000000000";

  @override
  void initState() {
    super.initState();
    //loadUser(); // Load user data when the widget is created
    _loadUserAndPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loadUser();
    _loadUserAndPreferences();
  }

  //! new shared pref
  Future<void> _loadUserAndPreferences() async {
    // Load user using PreferenceService instead of local method
    User? loadedUser = await PreferenceService.getUser();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
      });
    }
  }

  // isDarkMode ? Colors.black : Colors.white,

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode state
    bool isNameEmpty = user.name == null || user.name!.trim().isEmpty;

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor:
                        // isDarkMode ? Colors.black :
                        Colors.grey[300],
                    backgroundImage: AssetImage(user.gender.toString() == 'Male'
                        ? "assets/images/man.png"
                        : "assets/images/women.png"), // Default image
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  user.name ?? name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),

                //

                const SizedBox(
                  height: 8,
                ),
                Text(
                  user.phoneNumber ?? phoneNumber,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 0,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SettingsTile(
                imgpath: 'assets/images/setting_icon1.png',
                title: "Edit Profile",
                imgHeight: 20,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => const UpdateDetails()))
                      .then((_) {
                    _loadUserAndPreferences(); // Reload data on return
                  });
                },
              ),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon2.png',
                  title: "Font Size",
                  imgHeight: 25,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TextSizeScreen()));
                  }),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon3.png',
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()));
                  }),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon4.png',
                  title: "Copyright Policy",
                  imgHeight: 35,
                  onTap: () {}),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon5.png',
                  title: "About Us",
                  imgHeight: 35,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Aboutus()));
                    // Aboutus
                  }),

              //! old  Dark Mode Toggle
              // SettingsTile(
              //   imgpath: 'assets/images/setting_icon6.png',
              //   title: "Dark Mode",
              //   imgHeight: 22,
              //   trailing: Switch(
              //     value: isDarkMode,
              //     onChanged: (value) {
              //       setState(() {
              //         isDarkMode = value;
              //       });
              //     },
              //   ),
              // ),

              //* new Dark mode toggle
              SettingsTile(
                imgpath: 'assets/images/setting_icon6.png',
                title: "Dark Mode",
                imgHeight: 22,
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    //async
                    // Save the dark mode preference whenever it changes
                    //await PreferenceService.saveDarkMode(value);
                    setState(() {
                      // isDarkMode = value;
                      themeProvider.toggleTheme(); // Toggle dark mode
                    });

                    // Optionally show a confirmation
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Theme preference saved'))
                    // );
                  },
                ),
              ),

              SettingsTile(
                  imgpath: 'assets/images/setting_icon7.png',
                  title: "Contact Us",
                  imgHeight: 37,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ContactUs()));
                  }),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon8.png',
                  title: "Cancellation and Refund",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const CancellationRefundPolicyScreen()));
                  }),
              SettingsTile(
                  imgpath: 'assets/images/setting_icon9.png',
                  title: "Shipping and Delivery Policy",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const ShippingAndDeliveryPolicy()));
                  }),

              isNameEmpty
                  ? ListTile(
                      leading: SizedBox(
                          width: 37,
                          child: Icon(
                            Icons.login,
                            color: isDarkMode
                                ? Colors.white
                                : const Color.fromARGB(255, 27, 27, 27),
                          )),
                      title: Text("Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 0, 0),
                          )),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),
                        );
                      })
                  : ListTile(
                      leading: SizedBox(
                          width: 37,
                          child: Icon(
                            Icons.logout_outlined,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )),
                      title: Text("Logout",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 168, 61, 53),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    // Add logout functionality here (e.g., clear user data and navigate to login)
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.clear();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ));
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      })
            ],
          ),
        ),
        // const SizedBox(height: 5
        //     //60
        //     ), // Add some space at the bottom
      ]),
    );
  }
}

// //^ costum widget

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:maryam/screens/personaldetail_screen.dart';
// import 'package:maryam/widgets/mylistile.dart';
// import 'package:maryam/providers/theme_provider.dart';

// class SettingsTab extends ConsumerWidget {
//   const SettingsTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDarkMode = ref.watch(themeProvider); // Get current theme mode
//     final themeNotifier = ref.read(themeProvider.notifier);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 130,
//                   width: 130,
//                   child: CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: const AssetImage("assets/images/pfp2.png"),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Alisha Raza',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   '+91 987543210',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               SettingsTile(
//                 imgpath: 'assets/images/setting_icon1.png',
//                 title: "Edit Profile",
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const PersonaldetailScreen()));
//                 },
//               ),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon2.png',
//                   title: "Font Size",
//                   onTap: () {}),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon3.png',
//                   title: "Privacy Policy",
//                   onTap: () {}),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon4.png',
//                   title: "Copyright Policy",
//                   onTap: () {}),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon5.png',
//                   title: "About Us",
//                   onTap: () {}),

//               // ✅ Dark Mode Toggle using Riverpod
//               SettingsTile(
//                 imgpath: 'assets/images/setting_icon6.png',
//                 title: "Dark Mode",
//                 trailing: Switch(
//                   value: isDarkMode == ThemeMode.dark, // Check dark mode state
//                   onChanged: (value) {
//                     themeNotifier.toggleTheme(); // Toggle theme
//                   },
//                 ),
//               ),

//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon7.png',
//                   title: "Contact Us",
//                   onTap: () {}),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon8.png',
//                   title: "Cancellation and Refund",
//                   onTap: () {}),
//               SettingsTile(
//                   imgpath: 'assets/images/setting_icon9.png',
//                   title: "Shipping and Delivery Policy",
//                   onTap: () {}),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
