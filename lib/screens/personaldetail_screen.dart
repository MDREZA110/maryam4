// // ignore_for_file: avoid_print
// ignore_for_file: avoid_print, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'package:maryam/models/user.dart';
import 'package:maryam/screens/congrat_screen.dart';
import 'package:maryam/services.dart/api_service.dart';
import 'package:maryam/services.dart/register_user.dart';
import 'package:maryam/widgets/costom_textfield.dart';

class PersonaldetailScreen extends StatefulWidget {
  final String phone;
  const PersonaldetailScreen({super.key, required this.phone});

  @override
  State<PersonaldetailScreen> createState() => _PersonaldetailScreenState();
}

class _PersonaldetailScreenState extends State<PersonaldetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;
  final String gender = '';
  bool isMale = true;

  File? _imageFile;
  String? imgLocalPath;
  String? selectedGender;
  String? selectedState;
  List<String> states = [];
  List<String> stateId = [];
  Map<String, String> stateMap = {}; // Map to store State Name -> State ID
  static const sizedBoxHeight = 15.0;

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _phoneController = TextEditingController(text: widget.phone);
    _phoneController.text = widget.phone; // Set the phone number
  }

//^ API Get State List
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
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load states")),
      );
    }
  }

// //^ func  Pick Image
  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _validateAndSubmit() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedDate == null ||
        selectedGender == null ||
        selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final authService = RegisterUser();
    authService.sendDetails(
      context,
      User(
          dob: _selectedDate!,
          name: _nameController.text,
          state: stateMap[selectedState]!,
          phoneNumber: widget.phone,
          address: _addressController.text,
          email: _emailController.text,
          gender: selectedGender!,
          imgPath: "_imageFile"
          //!  imgPath: 'assets/images/pfp.png',
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "   Fill Your Profile",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
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
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[300],
                        // backgroundImage: _imageFile != null
                        //     ? FileImage(_imageFile!) as ImageProvider
                        //     : AssetImage(
                        //         selectedGender == 'Male'
                        //             ? "assets/images/man.png"
                        //             : "assets/images/women.png",
                        //       ), // Default image
                        child: Image.asset(
                          selectedGender == 'Male'
                              ? "assets/images/man.png"
                              : "assets/images/women.png",
                          height: 90,
                        ),
                      ), // Show camera icon if no image selected
                    ),
                    // Positioned(
                    //   right: -28,
                    //   bottom: -7,
                    //   child: GestureDetector(
                    //     onTap: _showImagePickerOptions, // Tap to pick an image
                    //     child: Image.asset(
                    //       "assets/images/edit.png",
                    //       width: 100,
                    //       height: 100,
                    //     ),
                    //   ),
                    // ),
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
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              controller: _dobController,
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
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              onPressed: //
                  () async {
                User user = User(
                    dob: _selectedDate!,
                    name: _nameController.text,
                    state: stateMap[selectedState]!,
                    phoneNumber: widget.phone,
                    address: _addressController.text,
                    email: _emailController.text,
                    gender: selectedGender!,
                    imgPath: "_imageFile"

                    //'assets/images/pfp.png',
                    );

                _validateAndSubmit;

                final authService = RegisterUser();

                await authService.sendDetails(context, user);

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                String userJson = jsonEncode(user.toJson());
                await prefs.setString("user", userJson);

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CongratScreen(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCD3864), //#CD3864
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                elevation: 5,
              ),
              child: const Text(
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
      ),
    );
  }
}



//!___________________________________________________

// import 'dart:convert';
// import 'dart:io';
// import 'package:ftpconnect/ftpconnect.dart';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:maryam/models/user.dart';
// import 'package:maryam/screens/congrat_screen.dart';
// import 'package:maryam/services.dart/api_service.dart';
// import 'package:maryam/services.dart/register_user.dart';
// import 'package:maryam/widgets/costom_textfield.dart';

// class PersonaldetailScreen extends StatefulWidget {
//   final String phone;
//   const PersonaldetailScreen({super.key, required this.phone});

//   @override
//   State<PersonaldetailScreen> createState() => _PersonaldetailScreenState();
// }

// class _PersonaldetailScreenState extends State<PersonaldetailScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();

//   final TextEditingController _dobController = TextEditingController();
//   DateTime? _selectedDate;
//   final String gender = '';

//   File? _imageFile;
//   String? imgLocalPath;
//   String? selectedGender;
//   String? selectedState;
//   List<String> states = [];
//   List<String> stateId = [];
//   Map<String, String> stateMap = {}; // Map to store State Name -> State ID
//   static const sizedBoxHeight = 15.0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStates();
//     _phoneController = TextEditingController(text: widget.phone);
//     _phoneController.text = widget.phone; // Set the phone number
//   }

// //^ API Get State List
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

// //^ func  Pick Image
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
//       _imageFile = File(pickedFile.path);
//       imgLocalPath = pickedFile.path;
//       imgLocalPath = await uploadFileToServer(File(pickedFile.path));
//       setState(() {});
//     }
//   }

//   //^ API UPLOAD IMAGE   on cloude

//   Future<String?> uploadFileToServer(File imageFile) async {
//     final ftpConnect = FTPConnect(
//       "https://api.emaryam.com/Upload",
//     );

//     try {
//       await ftpConnect.connect();

//       // Define where the image will be stored on the server
//       String fileName = imageFile.uri.pathSegments.last;
//       String serverFolder = "uploads"; // Change this to your actual folder
//       String remotePath = "$serverFolder/$fileName";

//       bool uploaded =
//           await ftpConnect.uploadFile(imageFile, sRemoteName: remotePath);

//       await ftpConnect.disconnect();

//       if (uploaded) {
//         // Return the full URL of the uploaded file
//         return "https://yourserver.com/$remotePath";
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }

// //^ _______________________________________________
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
//         phoneNumber: widget.phone,
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
//           "   Fill Your Profile",
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
//               controller: _phoneController,
//               hideCursor: true,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               hintText: 'Email',
//               imagePath: 'assets/images/icon_email.png',
//               controller: _emailController,
//             ),
//             const SizedBox(height: sizedBoxHeight),
//             CustomTextField(
//               hintText: 'Address',
//               controller: _addressController,
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
//                   phoneNumber: widget.phone,
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
