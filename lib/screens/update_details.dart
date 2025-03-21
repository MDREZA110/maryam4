// // ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/congrat_screen.dart';
import 'package:maryam/services.dart/api_service.dart';
import 'package:maryam/services.dart/register_user.dart';
import 'package:maryam/widgets/costom_textfield.dart';

class UpdateDetails extends StatefulWidget {
  const UpdateDetails({super.key});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _dobController = "01/02/2004";
  DateTime? _selectedDate;
  final String gender = '';

  // File? _imageFile;
  String? selectedGender;
  String? selectedState;
  List<String> states = [];
  List<String> stateId = [];
  Map<String, String> stateMap = {}; // Map to store State Name -> State ID
  static const sizedBoxHeight = 15.0;
  User user = User();
  bool _isLoading = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchStates();
    loadUser();
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");

    if (userJson != null) {
      print("✅ Retrieved User JSON: $userJson"); // Debugging
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        return User.fromJson(userMap);
      } catch (e) {
        print("❌ Error parsing user JSON: $e");
        return null;
      }
    } else {
      print("❌ No user found in SharedPreferences");
      return null;
    }
  }

  void loadUser() async {
    User? loadedUser = await getUser();
    if (loadedUser != null) {
      print("✅ Loaded User: ${jsonEncode(loadedUser.toJson())}"); // Debugging
      setState(() {
        user = loadedUser;
        print(loadedUser);

        _nameController.text = user.name ?? '';
        _addressController.text = user.address ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';

        if (user.dob != null) {
          _selectedDate = user.dob;
          _dobController =
              "${user.dob!.day}/${user.dob!.month}/${user.dob!.year}";
        }

        selectedGender = user.gender;
        selectedState = user.stateName; // Ensure the state is set
        _dataLoaded = true;
      });
    } else {
      print("❌ No user found in SharedPreferences!");
    }
  }

  // TODO   state api updd
//*---------------------------  state api   --------------------------------------

  Future<void> _fetchStates() async {
    final response = await http.post(
      Uri.parse('https://api.emaryam.com/WebService.asmx/GetStateList'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"CountryId": 82}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = jsonDecode(responseData['d'])['data'];
      setState(() {
        states = data.map((state) => state['StateName'].toString()).toList();
        stateId = data.map((state) => state['stateid'].toString()).toList();

        // Fill the map with state names and corresponding IDs
        stateMap = {
          for (var state in data)
            state['StateName'].toString(): state['stateid'].toString()
        };

        // Once states are loaded, set selectedState based on user.state if it exists
        if (user.state != null) {
          // Find state name that corresponds to the ID
          for (var entry in stateMap.entries) {
            if (entry.value == user.state) {
              selectedState = entry.key;
              break;
            }
          }
        }
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load states")),
      );
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() async {
  //       _imageFile = File(pickedFile.path);
  //       // String imgLocalPath = await uploadFileToServer(File(pickedFile.path));
  //     });
  //   }
  // }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text) ||
        !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(_phoneController.text) ||
        _selectedDate == null ||
        selectedGender == null ||
        selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return false;
    }
    return true;
  }

  Future<void> _updateUserProfile() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Print debug information
      print("📤 Sending update request with data:");

      print(
          "##################################################################");
      print(_dobController);
      print(stateMap[selectedState]!);
      print(_phoneController.text);

      print(_emailController.text);

      print(DateFormat("dd/MM/yyyy").format(_selectedDate!));
      print(_addressController.text);

      print(
        stateMap[selectedState]!,
      );

      // Create the request body
      final requestBody = {
        // "FullName": "kanhaiya",
        // "Stateid": stateMap[selectedState]!,
        // "MobileNo": "7777777777",
        // "EmailId": "k@gmail.com",
        // "ProfilePic": "dfsd123",
        // "DOB": "12/02/2003",
        // "Address": "lko",
        // "Gender": "Male",
        // "UpdatedBy": 1

        "FullName": _nameController.text.trim(),
        "Stateid": stateMap[selectedState]!,
        "MobileNo": _phoneController.text.trim(),
        "EmailId": _emailController.text.trim(),
        "ProfilePic": "dfsd123", // Use a constant value as in your example
        "DOB": _dobController,
        //DateFormat("dd/MM/yyyy").format(_selectedDate!),
        "Address": _addressController.text.trim(),
        "Gender": selectedGender,
        "UpdatedBy": 1
      };

      // Print the request body for debugging
      print(jsonEncode(requestBody));

      final response = await http.post(
        Uri.parse(
            'https://api.emaryam.com/WebService.asmx/UserRegistrationUpdate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            //requestBody

            {
              "FullName": _nameController.text.trim(), //
              "Stateid": stateMap[selectedState]!,
              "MobileNo": _phoneController.text.trim(),
              "EmailId": "k@gmail.com",
              "ProfilePic": "dfsd123",
              "DOB": DateFormat("dd/MM/yyyy").format(_selectedDate!),
              //"12/02/2003",
              //DateFormat("dd/MM/yyyy").format(_selectedDate!),
              "Address": selectedGender!,
              "Gender": "Male",
              "UpdatedBy": 1
              // "FullName": "bbb",
              // //_nameController.text.trim(),
              // "Stateid": 1,
              // "MobileNo": _phoneController.text.trim(), //👍
              // "EmailId": "bbb@gmail.com",

              // // _emailController.text.trim(),
              // "ProfilePic": "dfsd123",
              // "DOB": "12/02/2003",
              // "Address": "lko",
              // "Gender": "Male",
              // "UpdatedBy": 1

              // "FullName": _nameController.text.trim(),             //👍
              // "Stateid": stateMap[selectedState],                  //👍
              // "MobileNo": _phoneController.text.trim(),            //👍
              // "EmailId": "a@gmail.com",
              // //_emailController.text.trim(),                      //👍
              // "ProfilePic": "dfsd123",
              // "DOB": DateFormat("dd/MM/yyyy").format(_selectedDate!),
              // "Address": _addressController.text.trim(),
              // "Gender": selectedGender,
              // "UpdatedBy": 1
            }),
      );
      print(DateFormat("dd/MM/yyyy").format(_selectedDate!));

      // Print response for debugging
      //print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Parse the nested JSON structure
        final jsonResponse = jsonDecode(response.body);
        // print("📥 Parsed outer JSON: $jsonResponse");

        final innerJson = jsonDecode(jsonResponse['d']);
        // print("📥 Parsed inner JSON: $innerJson");

        if (innerJson['status'] == 'success') {
          // Update local user data
          User updatedUser = User(
              dob: _selectedDate,
              name: _nameController.text,
              state: stateMap[selectedState]!,
              stateName: selectedState,
              phoneNumber: _phoneController.text,
              address: _addressController.text,
              email: _emailController.text,
              gender: selectedGender!,
              imgPath: "dfsd123");

          // Use PreferenceService to save updated user
          await PreferenceService.saveUser(updatedUser);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(innerJson['message'])),
          );

          Navigator.pop(context);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(innerJson['message'] ?? "Update failed")),
          );
        }
      } else {
        // Handle HTTP error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to update profile: HTTP ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Print the error for debugging
      print("❌ Error updating profile: $e");

      // Handle general error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "   Update Your Profile",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: _dataLoaded
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey[300],
                              // backgroundImage:
                              // _imageFile != null
                              //     ? FileImage(_imageFile!) as ImageProvider
                              //     :
                              //     const AssetImage(
                              //         "assets/images/pfp.png"), // Default image
                              child: Image.asset(
                                selectedGender.toString() == 'Male'
                                    ? "assets/images/man.png"
                                    : "assets/images/women.png",
                                height: 90,
                              )
                              //  _imageFile == null
                              //     ? Image.asset("assets/images/pfp.png", )
                              //     : null, // Show camera icon if no image selected
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'Full Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButtonFormField<String>(
                      icon: Image.asset('assets/images/icon_dropdown.png'),
                      focusColor: Colors.white10,
                      value: selectedState,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100], // Light grey background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          borderSide: BorderSide.none, // No border
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      hint: const Text(
                        "State",
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  CustomTextField(
                    hintText: '+91 1234567890',
                    controller: _phoneController,
                    hideCursor: true,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  CustomTextField(
                    hintText: 'Email',
                    imagePath: 'assets/images/icon_email.png',
                    controller: _emailController,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  CustomTextField(
                    hintText: 'Address',
                    controller: _addressController,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  CustomTextField(
                    onClick: _pickDate,
                    hintText: 'Date of Birth', // Default hint
                    controller: TextEditingController(text: _dobController),
                    imagePath: 'assets/images/icon_calendar.png',
                    selectedDate: _selectedDate,
                    hideCursor: true,
                  ),
                  const SizedBox(height: sizedBoxHeight),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DropdownButtonFormField<String>(
                      icon: Image.asset('assets/images/icon_dropdown.png'),
                      focusColor: Colors.white10,
                      value: selectedGender,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100], // Light grey background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          borderSide: BorderSide.none, // No border
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      hint: const Text(
                        "Gender",
                        style: TextStyle(color: Colors.grey),
                      ),
                      items: ["Female", "Male"].map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    // TODO
                    onPressed: _isLoading ? null : _updateUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD3864), //#CD3864
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 15),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Continue",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCD3864),
              ),
            ),
    );
  }
}





//! ---  wORKING CODE  ----- 
// // // ignore_for_file: avoid_print

// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:ftpconnect/ftpconnect.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:maryam/models/user.dart';
// import 'package:maryam/screens/congrat_screen.dart';
// import 'package:maryam/services.dart/api_service.dart';
// import 'package:maryam/services.dart/register_user.dart';
// import 'package:maryam/widgets/costom_textfield.dart';

// class UpdateDetails extends StatefulWidget {
//   const UpdateDetails({super.key});

//   @override
//   State<UpdateDetails> createState() => _UpdateDetailsState();
// }

// class _UpdateDetailsState extends State<UpdateDetails> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   final TextEditingController _dobController = TextEditingController();
//   DateTime? _selectedDate;
//   final String gender = '';

//   // File? _imageFile;
//   String? selectedGender;
//   String? selectedState;
//   List<String> states = [];
//   List<String> stateId = [];
//   Map<String, String> stateMap = {}; // Map to store State Name -> State ID
//   static const sizedBoxHeight = 15.0;
//   User user = User();
//   bool _isLoading = false;
//   bool _dataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//     loadUser();
//   }

// //*  load user data Shared prefrence
//   Future<User?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? userJson = prefs.getString('user');

//     if (userJson == null) return null; // No user data found

//     return User.fromJson(jsonDecode(userJson)); // Convert JSON to User model
//   }

//   void loadUser() async {
//     User? loadedUser = await getUser();
//     if (loadedUser != null) {
//       setState(() {
//         user = loadedUser;

//         print("shared pref data :  $user");
//         // Pre-fill fields with existing user data
//         _nameController.text = user.name!;
//         _addressController.text = user.address ?? '';
//         _emailController.text = user.email ?? '';
//         _phoneController.text = user.phoneNumber!;

//         if (user.dob != null) {
//           _selectedDate = user.dob;
//           _dobController.text =
//               "${user.dob!.day}/${user.dob!.month}/${user.dob!.year}";
//         }

//         selectedGender = user.gender;
//         _dataLoaded = true;

//         // We'll need to match the state ID to the state name later when states are loaded
//       });
//     } else {
//       print('pref is null');
//     }
//   }

//   // TODO   state api updd
// //*---------------------------  state api   --------------------------------------

//   Future<void> _fetchStates() async {
//     final response = await http.post(
//       Uri.parse('https://api.emaryam.com/WebService.asmx/GetStateList'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"CountryId": 82}),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       final List<dynamic> data = jsonDecode(responseData['d'])['data'];
//       setState(() {
//         states = data.map((state) => state['StateName'].toString()).toList();
//         stateId = data.map((state) => state['stateid'].toString()).toList();

//         // Fill the map with state names and corresponding IDs
//         stateMap = {
//           for (var state in data)
//             state['StateName'].toString(): state['stateid'].toString()
//         };

//         // Once states are loaded, set selectedState based on user.state if it exists
//         if (user.state != null) {
//           // Find state name that corresponds to the ID
//           for (var entry in stateMap.entries) {
//             if (entry.value == user.state) {
//               selectedState = entry.key;
//               break;
//             }
//           }
//         }
//       });
//     } else {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load states")),
//       );
//     }
//   }

//   void _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _dobController.text =
//             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//     }
//   }

//   // Future<void> _pickImage(ImageSource source) async {
//   //   final pickedFile = await ImagePicker().pickImage(source: source);

//   //   if (pickedFile != null) {
//   //     setState(() async {
//   //       _imageFile = File(pickedFile.path);
//   //       // String imgLocalPath = await uploadFileToServer(File(pickedFile.path));
//   //     });
//   //   }
//   // }

//   bool _validateInputs() {
//     if (_nameController.text.isEmpty ||
//         _addressController.text.isEmpty ||
//         !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text) ||
//         !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(_phoneController.text) ||
//         _selectedDate == null ||
//         selectedGender == null ||
//         selectedState == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return false;
//     }
//     return true;
//   }

//   // New function to update user profile via API
//   Future<void> _updateUserProfile() async {
//     loadUser();
//     if (!_validateInputs()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Don't split the image path, just use the full filename or path as needed
//       // final String profilePic = _imageFile != null
//       //     ? _imageFile!.path // Use full path or just extract filename if needed
//       //     : (user.imgPath ?? "assets/images/pfp.png");

//       final response = await http.post(
//         Uri.parse(
//             'https://api.emaryam.com/WebService.asmx/UserRegistrationUpdate'), // Your API endpoint
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "FullName": _nameController.text,
//           "Stateid": int.parse(stateMap[selectedState]!),
//           "MobileNo": _phoneController.text,
//           "EmailId": _emailController.text,
//           //"ProfilePic": "none__",
//           //profilePic, // Use the full path/filename
//           "DOB": _dobController.text,
//           "Address": _addressController.text,
//           "Gender": selectedGender,
//           "UpdatedBy": 7
//         }),
//       );

//       // TODO    update api

//       setState(() {
//         _isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         // Parse the nested JSON structure
//         final jsonResponse = jsonDecode(response.body);
//         final innerJson = jsonDecode(jsonResponse['d']);

//         if (innerJson['status'] == 'success') {
//           // Update local user data
//           User updatedUser = User(
//               dob: _selectedDate!,
//               name: _nameController.text,
//               state: stateMap[selectedState]!,
//               phoneNumber: _phoneController.text,
//               address: _addressController.text,
//               email: _emailController.text,
//               gender: selectedGender!,
//               imgPath: 'null'
//               //  _imageFile //! ?.path ?? user.imgPath ?? 'assets/images/pfp.png',
//               );

//           // Save updated user to SharedPreferences
//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//           String userJson = jsonEncode(updatedUser.toJson());
//           await prefs.setString("user", userJson);

//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(innerJson['message'])),
//           );

//           // Navigate to congrats screen
//           Navigator.pop(context);
//           // Navigator.of(context).push(MaterialPageRoute(
//           //   builder: (context) => const CongratScreen(),
//           // ));
//         } else {
//           // Show error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(innerJson['message'] ?? "Update failed")),
//           );
//         }
//       } else {
//         // Handle HTTP error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   "Failed to update profile: HTTP ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle general error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating profile: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "   Update Your Profile",
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: user != null
//           ? SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Center(
//                     child: SizedBox(
//                       height: 130,
//                       width: 130,
//                       child: Stack(
//                         children: [
//                           CircleAvatar(
//                               radius: 55,
//                               backgroundColor: Colors.grey[300],
//                               // backgroundImage:
//                               // _imageFile != null
//                               //     ? FileImage(_imageFile!) as ImageProvider
//                               //     :
//                               //     const AssetImage(
//                               //         "assets/images/pfp.png"), // Default image
//                               child: Image.asset(
//                                 user.gender.toString() == 'Male'
//                                     ? "assets/images/man.png"
//                                     : "assets/images/women.png",
//                                 height: 90,
//                               )
//                               //  _imageFile == null
//                               //     ? Image.asset("assets/images/pfp.png", )
//                               //     : null, // Show camera icon if no image selected
//                               ),
//                           // Positioned(
//                           //   right: -28,
//                           //   bottom: -7,
//                           //   child: GestureDetector(
//                           //   //  onTap: _showImagePickerOptions, // Tap to pick an image
//                           //     child: Image.asset(
//                           //       "assets/images/edit.png",
//                           //       width: 100,
//                           //       height: 100,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextField(
//                     hintText: 'Full Name',
//                     controller: _nameController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: DropdownButtonFormField<String>(
//                       icon: Image.asset('assets/images/icon_dropdown.png'),
//                       focusColor: Colors.white10,
//                       value: selectedState,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100], // Light grey background
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(10), // Rounded corners
//                           borderSide: BorderSide.none, // No border
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                       ),
//                       hint: const Text(
//                         "State",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       items: states.map((String state) {
//                         return DropdownMenuItem<String>(
//                           value: state,
//                           child: Text(state),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedState = value;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: '+91 1234567890',
//                     controller: _phoneController,
//                     hideCursor: true,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: 'Email',
//                     imagePath: 'assets/images/icon_email.png',
//                     controller: _emailController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: 'Address',
//                     controller: _addressController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     onClick: _pickDate,
//                     hintText: 'Date of Birth', // Default hint
//                     controller: _dobController,
//                     imagePath: 'assets/images/icon_calendar.png',
//                     selectedDate: _selectedDate,
//                     hideCursor: true,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: DropdownButtonFormField<String>(
//                       icon: Image.asset('assets/images/icon_dropdown.png'),
//                       focusColor: Colors.white10,
//                       value: selectedGender,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100], // Light grey background
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(10), // Rounded corners
//                           borderSide: BorderSide.none, // No border
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                       ),
//                       hint: const Text(
//                         "Gender",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       items: ["Female", "Male"].map((String item) {
//                         return DropdownMenuItem<String>(
//                           value: item,
//                           child: Text(item),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     // TODO
//                     onPressed: _isLoading ? null : _updateUserProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFCD3864), //#CD3864
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 60, vertical: 15),
//                       elevation: 5,
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             "Continue",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   )
//                 ],
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFCD3864),
//               ),
//             ),
//     );
//   }
// }

//!------------------------------------------------------------\

// // // ignore_for_file: avoid_print

// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:ftpconnect/ftpconnect.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:maryam/models/user.dart';
// import 'package:maryam/screens/congrat_screen.dart';
// import 'package:maryam/services.dart/api_service.dart';
// import 'package:maryam/services.dart/register_user.dart';
// import 'package:maryam/widgets/costom_textfield.dart';

// class UpdateDetails extends StatefulWidget {
//   const UpdateDetails({super.key});

//   @override
//   State<UpdateDetails> createState() => _UpdateDetailsState();
// }

// class _UpdateDetailsState extends State<UpdateDetails> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   final TextEditingController _dobController = TextEditingController();
//   DateTime? _selectedDate;
//   final String gender = '';

//   File? _imageFile;
//   String? selectedGender;
//   String? selectedState;
//   List<String> states = [];
//   List<String> stateId = [];
//   Map<String, String> stateMap = {}; // Map to store State Name -> State ID
//   static const sizedBoxHeight = 15.0;
//   User user = User();
//   bool _isLoading = false;
//   bool _dataLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//     loadUser();
//   }

// //*  load user data Shared prefrence
//   Future<User?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? userJson = prefs.getString('user');

//     if (userJson == null) return null; // No user data found

//     return User.fromJson(jsonDecode(userJson)); // Convert JSON to User model
//   }

//   void loadUser() async {
//     User? loadedUser = await getUser();
//     if (loadedUser != null) {
//       setState(() {
//         user = loadedUser;

//         // Pre-fill fields with existing user data
//         _nameController.text = user.name ?? '';
//         _addressController.text = user.address ?? '';
//         _emailController.text = user.email ?? '';
//         _phoneController.text = user.phoneNumber ?? '';

//         if (user.dob != null) {
//           _selectedDate = user.dob;
//           _dobController.text =
//               "${user.dob!.day}/${user.dob!.month}/${user.dob!.year}";
//         }

//         selectedGender = user.gender;
//         _dataLoaded = true;

//         // We'll need to match the state ID to the state name later when states are loaded
//       });
//     }
//   }

//   // TODO   state api updd
// //*---------------------------  state api   --------------------------------------

//   Future<void> _fetchStates() async {
//     final response = await http.post(
//       Uri.parse('https://api.emaryam.com/WebService.asmx/GetStateList'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"CountryId": 82}),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       final List<dynamic> data = jsonDecode(responseData['d'])['data'];
//       setState(() {
//         states = data.map((state) => state['StateName'].toString()).toList();
//         stateId = data.map((state) => state['stateid'].toString()).toList();

//         // Fill the map with state names and corresponding IDs
//         stateMap = {
//           for (var state in data)
//             state['StateName'].toString(): state['stateid'].toString()
//         };

//         // Once states are loaded, set selectedState based on user.state if it exists
//         if (user.state != null) {
//           // Find state name that corresponds to the ID
//           for (var entry in stateMap.entries) {
//             if (entry.value == user.state) {
//               selectedState = entry.key;
//               break;
//             }
//           }
//         }
//       });
//     } else {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load states")),
//       );
//     }
//   }

//   void _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _dobController.text =
//             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//     }
//   }

//   // Future<void> _pickImage(ImageSource source) async {
//   //   final pickedFile = await ImagePicker().pickImage(source: source);

//   //   if (pickedFile != null) {
//   //     setState(() async {
//   //       _imageFile = File(pickedFile.path);
//   //       // String imgLocalPath = await uploadFileToServer(File(pickedFile.path));
//   //     });
//   //   }
//   // }

//   //^ API UPLOAD IMAGE   on cloude

//   // Future<String?> uploadFileToServer(File imageFile) async {
//   //   final ftpConnect = FTPConnect(
//   //     "https://api.emaryam.com/Upload",
//   //   );

//   //   try {
//   //     await ftpConnect.connect();

//   //     // Define where the image will be stored on the server
//   //     String fileName = imageFile.uri.pathSegments.last;
//   //     String serverFolder = "uploads"; // Change this to your actual folder
//   //     String remotePath = "$serverFolder/$fileName";

//   //     bool uploaded =
//   //         await ftpConnect.uploadFile(imageFile, sRemoteName: remotePath);

//   //     await ftpConnect.disconnect();

//   //     if (uploaded) {
//   //       // Return the full URL of the uploaded file
//   //       return "https://yourserver.com/$remotePath";
//   //     } else {
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     print("Error: $e");
//   //     return null;
//   //   }
//   // }

// //^ _______________________________________________

//   // void _showImagePickerOptions() {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     builder: (context) {
//   //       return Wrap(
//   //         children: [
//   //           ListTile(
//   //             leading: const Icon(Icons.photo_library),
//   //             title: const Text('Pick from Gallery'),
//   //             onTap: () {
//   //               _pickImage(ImageSource.gallery);
//   //               Navigator.pop(context);
//   //             },
//   //           ),
//   //           ListTile(
//   //             leading: const Icon(Icons.camera_alt),
//   //             title: const Text('Take a Photo'),
//   //             onTap: () {
//   //               _pickImage(ImageSource.camera);
//   //               Navigator.pop(context);
//   //             },
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   bool _validateInputs() {
//     if (_nameController.text.isEmpty ||
//         _addressController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _phoneController.text.isEmpty ||
//         _selectedDate == null ||
//         selectedGender == null ||
//         selectedState == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return false;
//     }
//     return true;
//   }

//   // New function to update user profile via API
//   Future<void> _updateUserProfile() async {
//     if (!_validateInputs()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // Don't split the image path, just use the full filename or path as needed
//       // final String profilePic = _imageFile != null
//       //     ? _imageFile!.path // Use full path or just extract filename if needed
//       //     : (user.imgPath ?? "assets/images/pfp.png");

//       final response = await http.post(
//         Uri.parse(
//             'https://api.emaryam.com/WebService.asmx/UserRegistrationUpdate'), // Your API endpoint
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "FullName": _nameController.text,
//           "Stateid": int.parse(stateMap[selectedState]!),
//           "MobileNo": _phoneController.text,
//           "EmailId": _emailController.text,
//           "ProfilePic": "none__",
//           //profilePic, // Use the full path/filename
//           "DOB": _dobController.text,
//           "Address": _addressController.text,
//           "Gender": selectedGender,
//           "UpdatedBy": 1
//         }),
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         // Parse the nested JSON structure
//         final jsonResponse = jsonDecode(response.body);
//         final innerJson = jsonDecode(jsonResponse['d']);

//         if (innerJson['status'] == 'success') {
//           // Update local user data
//           User updatedUser = User(
//               dob: _selectedDate!,
//               name: _nameController.text,
//               state: stateMap[selectedState]!,
//               phoneNumber: _phoneController.text,
//               address: _addressController.text,
//               email: _emailController.text,
//               gender: selectedGender!,
//               imgPath:
//                   _imageFile //! ?.path ?? user.imgPath ?? 'assets/images/pfp.png',
//               );

//           // Save updated user to SharedPreferences
//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//           String userJson = jsonEncode(updatedUser.toJson());
//           await prefs.setString("user", userJson);

//           // Show success message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(innerJson['message'])),
//           );

//           // Navigate to congrats screen
//           Navigator.pop(context);
//           // Navigator.of(context).push(MaterialPageRoute(
//           //   builder: (context) => const CongratScreen(),
//           // ));
//         } else {
//           // Show error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(innerJson['message'] ?? "Update failed")),
//           );
//         }
//       } else {
//         // Handle HTTP error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   "Failed to update profile: HTTP ${response.statusCode}")),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle general error
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error updating profile: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "   Update Your Profile",
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: _dataLoaded
//           ? SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Center(
//                     child: SizedBox(
//                       height: 130,
//                       width: 130,
//                       child: Stack(
//                         children: [
//                           CircleAvatar(
//                               radius: 55,
//                               backgroundColor: Colors.grey[300],
//                               // backgroundImage:
//                               // _imageFile != null
//                               //     ? FileImage(_imageFile!) as ImageProvider
//                               //     :
//                               //     const AssetImage(
//                               //         "assets/images/pfp.png"), // Default image
//                               child: Image.asset(
//                                 user.gender.toString() == 'Male'
//                                     ? "assets/images/man.png"
//                                     : "assets/images/women.png",
//                                 height: 90,
//                               )
//                               //  _imageFile == null
//                               //     ? Image.asset("assets/images/pfp.png", )
//                               //     : null, // Show camera icon if no image selected
//                               ),
//                           // Positioned(
//                           //   right: -28,
//                           //   bottom: -7,
//                           //   child: GestureDetector(
//                           //   //  onTap: _showImagePickerOptions, // Tap to pick an image
//                           //     child: Image.asset(
//                           //       "assets/images/edit.png",
//                           //       width: 100,
//                           //       height: 100,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   CustomTextField(
//                     hintText: 'Full Name',
//                     controller: _nameController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: DropdownButtonFormField<String>(
//                       icon: Image.asset('assets/images/icon_dropdown.png'),
//                       focusColor: Colors.white10,
//                       value: selectedState,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100], // Light grey background
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(10), // Rounded corners
//                           borderSide: BorderSide.none, // No border
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                       ),
//                       hint: const Text(
//                         "State",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       items: states.map((String state) {
//                         return DropdownMenuItem<String>(
//                           value: state,
//                           child: Text(state),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedState = value;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: '+91 1234567890',
//                     controller: _phoneController,
//                     hideCursor: true,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: 'Email',
//                     imagePath: 'assets/images/icon_email.png',
//                     controller: _emailController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     hintText: 'Address',
//                     controller: _addressController,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   CustomTextField(
//                     onClick: _pickDate,
//                     hintText: 'Date of Birth', // Default hint
//                     controller: _dobController,
//                     imagePath: 'assets/images/icon_calendar.png',
//                     selectedDate: _selectedDate,
//                     hideCursor: true,
//                   ),
//                   const SizedBox(height: sizedBoxHeight),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: DropdownButtonFormField<String>(
//                       icon: Image.asset('assets/images/icon_dropdown.png'),
//                       focusColor: Colors.white10,
//                       value: selectedGender,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[100], // Light grey background
//                         border: OutlineInputBorder(
//                           borderRadius:
//                               BorderRadius.circular(10), // Rounded corners
//                           borderSide: BorderSide.none, // No border
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 15),
//                       ),
//                       hint: const Text(
//                         "Gender",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       items: ["Female", "Male"].map((String item) {
//                         return DropdownMenuItem<String>(
//                           value: item,
//                           child: Text(item),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedGender = value;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     // TODO
//                     onPressed: _isLoading ? null : _updateUserProfile,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFCD3864), //#CD3864
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 60, vertical: 15),
//                       elevation: 5,
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             "Continue",
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   )
//                 ],
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFFCD3864),
//               ),
//             ),
//     );
//   }
// }

//^__________________________________________
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:maryam/models/user.dart';
// import 'package:maryam/screens/congrat_screen.dart';
// import 'package:maryam/services.dart/api_service.dart';
// import 'package:maryam/services.dart/register_user.dart';
// import 'package:maryam/widgets/costom_textfield.dart';

// class UpdateDetails extends StatefulWidget {
//   const UpdateDetails({super.key});

//   @override
//   State<UpdateDetails> createState() => _UpdateDetailsState();
// }

// class _UpdateDetailsState extends State<UpdateDetails> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   final TextEditingController _dobController = TextEditingController();
//   DateTime? _selectedDate;
//   final String gender = '';

//   File? _imageFile;
//   String? selectedGender;
//   String? selectedState;
//   List<String> states = [];
//   List<String> stateId = [];
//   Map<String, String> stateMap = {}; // Map to store State Name -> State ID
//   static const sizedBoxHeight = 15.0;
//   User user = User();

//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//     loadUser();
//   }

// //*  load user data Shared prefrence
//   Future<User?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? userJson = prefs.getString('user');

//     if (userJson == null) return null; // No user data found

//     return User.fromJson(jsonDecode(userJson)); // Convert JSON to User model
//   }

//   void loadUser() async {
//     User? loadedUser = await getUser();
//     setState(() {
//       user = loadedUser!;
//     });
//   }
// //*-----------------------------------------------------------------

//   Future<void> _fetchStates() async {
//     final response = await http.post(
//       Uri.parse('https://api.emaryam.com/WebService.asmx/GetStateList'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"CountryId": 82}),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       final List<dynamic> data = jsonDecode(responseData['d'])['data'];
//       setState(() {
//         states = data.map((state) => state['StateName'].toString()).toList();
//         stateId = data.map((state) => state['stateid'].toString()).toList();

//         // Fill the map with state names and corresponding IDs
//         stateMap = {
//           for (var state in data)
//             state['StateName'].toString(): state['stateid'].toString()
//         };
//       });
//     } else {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load states")),
//       );
//     }
//   }

//   void _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _dobController.text =
//             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _showImagePickerOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Pick from Gallery'),
//               onTap: () {
//                 _pickImage(ImageSource.gallery);
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 _pickImage(ImageSource.camera);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _validateAndSubmit() {
//     if (_nameController.text.isEmpty ||
//         _addressController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _selectedDate == null ||
//         selectedGender == null ||
//         selectedState == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     final authService = RegisterUser();
//     authService.sendDetails(
//       context,
//       User(
//         dob: _selectedDate!,
//         name: _nameController.text,
//         state: stateMap[selectedState]!,
//         phoneNumber: _phoneController.text,
//         address: _addressController.text,
//         email: _emailController.text,
//         gender: selectedGender!,
//         imgPath: 'assets/images/pfp.png',
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "   Update Your Profile",
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Center(
//               child: SizedBox(
//                 height: 130,
//                 width: 130,
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 55,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!) as ImageProvider
//                           : const AssetImage(
//                               "assets/images/pfp.png"), // Default image
//                       child: _imageFile == null
//                           ? Image.asset("assets/images/pfp.png")
//                           : null, // Show camera icon if no image selected
//                     ),
//                     Positioned(
//                       right: -28,
//                       bottom: -7,
//                       child: GestureDetector(
//                         onTap: _showImagePickerOptions, // Tap to pick an image
//                         child: Image.asset(
//                           "assets/images/edit.png",
//                           width: 100,
//                           height: 100,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 5),
//             CustomTextField(
//               hintText: 'Full Name',
//               controller: _nameController,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: DropdownButtonFormField<String>(
//                 icon: Image.asset('assets/images/icon_dropdown.png'),
//                 focusColor: Colors.white10,
//                 value: selectedState,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[100], // Light grey background
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10), // Rounded corners
//                     borderSide: BorderSide.none, // No border
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//                 hint: const Text(
//                   "State",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 items: states.map((String state) {
//                   return DropdownMenuItem<String>(
//                     value: state,
//                     child: Text(state),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedState = value;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               hintText: '+91 1234567890',
//               controller: //_phoneController,

//                   _phoneController.text.isEmpty
//                       ? TextEditingController(text: user.phoneNumber)
//                       : _phoneController,
//               hideCursor: true,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               hintText: 'Email',
//               imagePath: 'assets/images/icon_email.png',
//               controller:
//                   // _emailController,
//                   _emailController.text.isEmpty
//                       ? TextEditingController(text: user.email)
//                       : _emailController,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               hintText: 'Address',
//               controller:
//                   // _addressController,

//                   _addressController.text.isEmpty
//                       ? TextEditingController(text: user.address)
//                       : _addressController,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               onClick: _pickDate,
//               hintText: 'Date of Birth', // Default hint
//               controller: _dobController,
//               imagePath: 'assets/images/icon_calendar.png',
//               selectedDate: _selectedDate,
//               hideCursor: true,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: DropdownButtonFormField<String>(
//                 icon: Image.asset('assets/images/icon_dropdown.png'),
//                 focusColor: Colors.white10,
//                 value: selectedGender,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[100], // Light grey background
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10), // Rounded corners
//                     borderSide: BorderSide.none, // No border
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//                 hint: const Text(
//                   "Gender",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//                 items: ["Female", "Male"].map((String item) {
//                   return DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(item),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedGender = value;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: //
//                   () async {
//                 User user = User(
//                   dob: _selectedDate!,
//                   name: _nameController.text,
//                   state: stateMap[selectedState]!,
//                   phoneNumber: _phoneController.text,
//                   address: _addressController.text,
//                   email: _emailController.text,
//                   gender: selectedGender!,
//                   imgPath: 'assets/images/pfp.png',
//                 );

//                 _validateAndSubmit;

//                 final authService = RegisterUser();

//                 await authService.sendDetails(context, user);

//                 final SharedPreferences prefs =
//                     await SharedPreferences.getInstance();

//                 String userJson = jsonEncode(user.toJson());
//                 await prefs.setString("user", userJson);

//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const CongratScreen(),
//                 ));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFCD3864), //#CD3864
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
//                 elevation: 5,
//               ),
//               child: const Text(
//                 "Continue",
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
