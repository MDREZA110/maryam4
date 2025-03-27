// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/models/subscription_model.dart';

import 'package:maryam/models/user.dart';
import 'package:maryam/services.dart/post_member_details.dart';
import 'package:maryam/widgets/suscribe/show_transaction_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberDetails extends StatefulWidget {
  const MemberDetails(
      {super.key,
      required this.selectedMagazineType,
      required this.selectedPackageForIssue,
      required this.selectedTypeOfPost,
      required this.grandTotal,
      required this.magazineSubscriptionCost,
      required this.issueIdNo,
      required this.postTypeId});
  final int issueIdNo;
  final int postTypeId;
  final double grandTotal;
  final double magazineSubscriptionCost;
  final String selectedMagazineType;
  final String selectedPackageForIssue;
  final String selectedTypeOfPost;
  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  // Create a global key to uniquely identify the form
  final _formKey = GlobalKey<FormState>();
  User user = User();

  @override
  void initState() {
    super.initState();
    _fetchStates();
    loadUser(); // Load user data when screen starts
  }

//*  get user detail Shared preference

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('user');

    if (userJson == null) return null; // No user data found

    return User.fromJson(jsonDecode(userJson)); // Convert JSON to User model
  }

  void loadUser() async {
    User? loadedUser = await getUser();
    setState(() {
      user = loadedUser!;
    });
  }

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  final TextEditingController _pincode = TextEditingController();

  final TextEditingController _landmark = TextEditingController();
  bool _isWhatsappSameAsPhone = false;

  String? selectedState;
  String? selectedCity;

  List<String> states = [];
  List<String> stateId = [];
  Map<String, String> stateMap = {};

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
              _fetchCities(entry.value); // Fetch cities for the selected state
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

  //TODO    city api
//^ city api
  List<String> cityNames = [];
  late String cityName;
  late String stateName;
  List<String> cityIds = [];
  Map<String, String> cityMap = {};
  List<Map<String, dynamic>> cityList = [];

  Future<void> _fetchCities(String stateId) async {
    final response = await http.post(
      Uri.parse('https://api.emaryam.com/WebService.asmx/GetCityList'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"CountryId": 82, "StateId": int.parse(stateId)}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = jsonDecode(responseData['d'])['data'];

      setState(() {
        cityNames = data.map((city) => city['CityName'].toString()).toList();
        cityIds = data.map((city) => city['CityId'].toString()).toList();

        // Fill the map with city names and corresponding IDs
        cityMap = {
          for (var city in data)
            city['CityName'].toString(): city['CityId'].toString()
        };

        // Store city data as a list of maps
        cityList = data.map((city) {
          return {
            "CityId": city["CityId"].toString(),
            "CityName": city["CityName"].toString(),
          };
        }).toList();
      });

      print(cityList); // Debug output
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load cities")),
      );
    }
  }

//^_______________

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(27.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Member Detail",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 205, 0, 68),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),

                  SizedBox(
                    height: 12,
                  ),
                  // Name Field

                  Row(
                    children: const [
                      Text('Name',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _nameController,
                    // _nameController.text.isEmpty
                    //     ? TextEditingController(text: user.name)
                    //     : _nameController,
                    decoration: const InputDecoration(
                      //labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  //^ Mobile Number
                  Row(
                    children: const [
                      Text('Mobile Number',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    //  _phoneController.text.isEmpty
                    //     ? TextEditingController(text: user.phoneNumber)
                    //     : _phoneController,
                    decoration: const InputDecoration(
                      //  labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },

//&  readOnly: true,
                  ),

                  const SizedBox(height: 16),

                  //^ Email Field
                  Row(
                    children: const [
                      Text('Email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _emailController,
                    // _emailController.text.isEmpty
                    //     ? TextEditingController(text: user.email)
                    //     : _emailController,
                    // _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  //^ whatsapp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Row(
                        children: [
                          Text('Whatsapp Number',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('*',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _isWhatsappSameAsPhone,
                            onChanged: (bool? value) {
                              setState(() {
                                _isWhatsappSameAsPhone = value ?? false;
                                if (_isWhatsappSameAsPhone) {
                                  _whatsappController.text =
                                      _phoneController.text.trim();
                                  // TextEditingController(
                                  //         text: user.phoneNumber)
                                  //     .text;
                                }
                              });
                            },
                          ),
                          const Text('If Same'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _whatsappController,
                    // _whatsappController.text.isEmpty
                    //     ? TextEditingController(text: user.whatsappNumber)
                    //     : _whatsappController,
                    //  _whatsappController,
                    enabled: !_isWhatsappSameAsPhone,
                    decoration: const InputDecoration(
                      // labelText: 'Whatsapp Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  //^state
                  Row(
                    children: const [
                      Text('State',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    //_selectedState,
                    decoration: const InputDecoration(
                      //labelText: "Select Magazine",
                      border: OutlineInputBorder(),
                    ),
                    items: states.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedState = value;
                        selectedCity = null; // Reset selected city
                        _fetchCities(stateMap[
                            selectedState]!); // Fetch cities for the selected state
                      });
                    },
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  //^District
                  Row(
                    children: const [
                      Text('District',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 3,
                  // ),
                  // DropdownButtonFormField<String>(
                  //   value: selectedCity,
                  //   decoration: const InputDecoration(
                  //     //labelText: "Select Magazine",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   items: cityList.map((city) {
                  //     return DropdownMenuItem<String>(
                  //       value: city['CityName'],
                  //       child: Text(city['CityName']),
                  //     );
                  //   }).toList(),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedCity = value;
                  //     });
                  //   },
                  // ),

                  SizedBox(
                    width: 300, // Adjust the width as needed
                    child: DropdownButtonFormField<String>(
                      isExpanded:
                          true, // Ensure the dropdown expands to fill the width
                      value: selectedCity,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: cityList.map((city) {
                        return DropdownMenuItem<String>(
                          value: city['CityName'],
                          child: Text(city['CityName']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  //^ address
                  Row(
                    children: const [
                      Text('Address',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  //^ pincode
                  Row(
                    children: const [
                      Text('Pincode',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('*',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _pincode,
                    decoration: const InputDecoration(
                      labelText: 'Pincode',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length != 6) {
                        return 'Please enter Pincode';
                      }

                      return null;
                    },
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text('Landmark',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(
                    height: 3,
                  ),
                  TextFormField(
                    controller: _landmark,
                    decoration: const InputDecoration(
                      labelText: 'Landmark',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Text(
                      "Note: You need to pay ${widget.grandTotal} . Follow the payment instructions to complete your transaction. Thank you!"),
                  const SizedBox(height: 24),

                  // Submit Button

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007b83),
                            // padding: const EdgeInsets.symmetric(
                            //     vertical: 12, horizontal: 20),
                          ),
                          onPressed: () async {
                            // if (_formKey.currentState!.validate()) {
                            // SubscriptionData subscriptionData =
                            //     SubscriptionData(
                            //   eMagazineType: widget.selectedMagazineType,
                            //   name:   _nameController.text.trim(),           //"ankit Sir",
                            //   whatsappNo: _whatsappController.toString().trim(), //"9565931965",
                            //   mobileNo:  _phoneController.text.trim(),  //"9565931965",
                            //   emailId: "K@gmail.com",
                            //   issueId: widget.issueIdNo,
                            //   postTypeId: widget.postTypeId,
                            //   amount: widget.magazineSubscriptionCost,
                            //   postTypeAmount: 200,
                            //   totalAmount: widget.grandTotal,
                            //   state: "Up",
                            //   city: "Deoria",
                            //   pinCode: "204505",
                            //   landMark: "mahanagar",
                            //   address: "deoria",
                            //   addedBy: 1,
                            // );

                            if (_formKey.currentState!.validate()) {
                              SubscriptionData subscriptionData =
                                  SubscriptionData(
                                eMagazineType: widget.selectedMagazineType,
                                name:
                                    _nameController.text.trim(), //"ankit Sir",
                                whatsappNo: _whatsappController.text
                                    .toString()
                                    .trim(), //"9565931965",
                                mobileNo: _phoneController.text
                                    .trim(), //"9565931965",
                                emailId: _emailController.text
                                    .trim(), //"K@gmail.com",
                                issueId: widget.issueIdNo,
                                postTypeId: widget.postTypeId,
                                amount: widget.magazineSubscriptionCost,
                                postTypeAmount: 200,
                                totalAmount: widget.grandTotal,
                                state: selectedState!,
                                city: selectedCity!, //"Deoria",
                                pinCode: _pincode.text.trim(), //"204505",
                                landMark: _landmark.text.trim(), //"mahanagar",
                                address:
                                    _addressController.text.trim(), //"deoria",
                                addedBy: 7,
                              );

//^   API Calling
                              SubscriptionResponse? response =
                                  await fetchSubscriptionData(subscriptionData);

                              if (response != null) {
                                print("Success! Status: ${response.status}");
                                for (var item in response.data) {
                                  print(
                                      "User Name: ${item.name}, Total Amount: ${item.totalAmount}");
                                  print("Response Body: $response");

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DisplayTransactionDetailsScreen(
                                          subscriptionData: subscriptionData,
                                          name: _nameController.text.trim(),
                                          phoneNumber:
                                              _phoneController.text.trim(),
                                          price: widget.grandTotal,
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                print("Failed to fetch data.");
                              }

                              // If the form is valid, process the data
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );

                              // Access the entered data
                              String name = _nameController.text;
                              String email = _emailController.text;
                              String phone = _phoneController.text;
                              String address = _addressController.text;

                              // Do something with the data (e.g., save to database)
                              // print('Name: $name');
                              // print('Email: $email');
                              // print('Phone: $phone');
                              // print('Address: $address');
                              // }
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Pay",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFf44336),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text(
                              "Back",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
