// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:maryam/widgets/suscribe/member_details.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  double _magazineSubscriptionCost = 0.0;
  double _grandTotal = 0.0;
  List<dynamic> magazineData = []; //Map<String, dynamic>

  Future<void> fetchMagazineData() async {
    final url =
        Uri.parse("https://api.emaryam.com/WebService.asmx/IsseDetails");

    try {
      final response =
          await http.post(url, headers: {"Content-Type": "aplication/json"});

      print(" response body is : ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        setState(() {
          magazineData = responseData; // as List<Map<String, dynamic>>
          print(responseData);
        });
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Magazine data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMagazineData();
  }

  String? _selectedMagazineType = 'Select';
  String? _selectedPackageForIssue = 'Select';
  String? _selectedTypeOfPost = 'Select';
  String errorText = '';

  late int issueIdNo;
  late int postIdNo = 19;
  final List<String> categories = [
    'Select',
    'Print Magazine Hardcopy Only',
    'E-Magazine Digitalcopy Only'
  ];
//^  old gold
  final List<String> typesOfPost = ['Select', 'Registered', 'General Post'];

  List<String> getOptionsForMagazine(String? selected) {
    if (selected == 'Print Magazine Hardcopy Only') {
      return ['Select', '12 Issue', '24 Issue', '36 Issue'];
    } else if (selected == 'E-Magazine Digitalcopy Only') {
      return [
        'Select',
        '1 Issue',
        '6 Issue',
        '12 Issue',
        '18 Issue',
        '24 Issue',
        '36 Issue'
      ];
    }
    return ['Select'];
  }

//& -------------      new       -------------------
// // Extract types of post dynamically from API response
//   List<String> getTypesOfPost(List<dynamic> apiResponse) {
//     Set<String> types = apiResponse
//         .where((item) => item['PostTypeId'] != null)
//         .map((item) => item['PostTypeId'] == 1 ? 'Registered' : 'General Post')
//         .toSet();
//     return ['Select', ...types];
//   }

// // Function to get issue options dynamically based on the API response
//   List<String> getOptionsForMagazine(
//       String? selected, List<dynamic> apiResponse) {
//     if (selected == null || selected == 'Select') {
//       return ['Select'];
//     }

//     // Extract unique issue names for the selected category
//     Set<String> issueOptions = apiResponse
//         .where((item) => item['MagazineType'] == selected)
//         .map((item) => item['IssueName'].toString())
//         .toSet();

//     return ['Select', ...issueOptions];
//   }

//TODO
  void updatePrice() {
    if (_selectedMagazineType == 'Select' ||
        _selectedPackageForIssue == 'Select') {
      setState(() {
        _magazineSubscriptionCost = 0.0;
        _grandTotal = 0.0;
      });
      return;
    }

    // Convert the selection to match the API format
    String magazineTypeForApi =
        _selectedMagazineType == 'E-Magazine Digitalcopy Only'
            ? 'E Magazine Digitalcopy Only'
            : 'Print Magazine Hardcopy Only';

    // For digital magazines, find matching item based on magazine type and issue name
    if (magazineTypeForApi == 'E Magazine Digitalcopy Only') {
      for (var item in magazineData) {
        if (item['MagazineType'] == magazineTypeForApi &&
            item['IssueName'] == _selectedPackageForIssue) {
          setState(() {
            _magazineSubscriptionCost = item['Amount'].toDouble();
            _grandTotal = _magazineSubscriptionCost;
            issueIdNo = item['IssueId'];
            postIdNo = item['PostTypeId'];

            print(
                "-------------------------------------------------------      $issueIdNo");
            print(
                "-------------------------------------------------------      $postIdNo");
          });
          return;
        }
      }
    }

    // For print magazines
    else if (magazineTypeForApi == 'Print Magazine Hardcopy Only') {
      // If post type is selected, use that to find the exact price
      if (_selectedTypeOfPost != 'Select') {
        int? postTypeId;
        if (_selectedTypeOfPost == 'Registered') {
          postTypeId = 1;
        } else if (_selectedTypeOfPost == 'General Post') {
          postTypeId = 2;
        }

        for (var item in magazineData) {
          if (item['MagazineType'] == magazineTypeForApi &&
              item['IssueName'] == _selectedPackageForIssue &&
              item['PostTypeId'] == postTypeId) {
            setState(() {
              _magazineSubscriptionCost = item['Amount'].toDouble();
              _grandTotal = _magazineSubscriptionCost;
              issueIdNo = item['IssueId'];
              postIdNo = item['PostTypeId'];
            });
            return;
          }
        }
      }
      // If post type is not selected yet, show an average or the General Post price as default
      else {
        // Look for General Post price (PostTypeId = 2) as default
        for (var item in magazineData) {
          if (item['MagazineType'] == magazineTypeForApi &&
              item['IssueName'] == _selectedPackageForIssue &&
              item['PostTypeId'] == 2) {
            // Default to General Post price
            setState(() {
              _magazineSubscriptionCost = item['Amount'].toDouble();
              _grandTotal = _magazineSubscriptionCost;
            });
            return;
          }
        }
      }
    }

    // If no match found
    setState(() {
      _magazineSubscriptionCost = 0.0;
      _grandTotal = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          padding: const EdgeInsets.all(25),
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Subscribe Now",
                  style: TextStyle(
                      color: Color(0xFFCD3864),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 35),

//^ First Dropdown
              DropdownButtonFormField<String>(
                value: _selectedMagazineType,
                decoration: const InputDecoration(
                  labelText: "Select Magazine",
                  border: OutlineInputBorder(),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMagazineType = value;
                    _selectedPackageForIssue =
                        'Select'; // Reset second dropdown
                  });
                },
              ),

              const SizedBox(height: 30),

//^second DropDown
              // Show Second Dropdown Only if First is Selected
              if (_selectedMagazineType != 'Select') ...[
                DropdownButtonFormField<String>(
                  value: _selectedPackageForIssue,
                  decoration: const InputDecoration(
                    labelText: "Duration",
                    border: OutlineInputBorder(),
                  ),
                  items: getOptionsForMagazine(
                    _selectedMagazineType,
                  ).map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPackageForIssue = value;
                    });

                    updatePrice();
                  },
                ),

//^ third dropdown
                if (_selectedPackageForIssue != 'Select' &&
                    _selectedMagazineType ==
                        'Print Magazine Hardcopy Only') ...[
                  const SizedBox(
                    height: 25,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedTypeOfPost,
                    decoration: const InputDecoration(
                      labelText: "Select Post Type",
                      border: OutlineInputBorder(),
                    ),
                    items: typesOfPost.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTypeOfPost = value; // Reset second dropdown
                      });
                      updatePrice();
                    },
                  ),
                ],
                SizedBox(
                  height: 3,
                ),
                if (_selectedTypeOfPost != 'Select')
                  GestureDetector(
                    onTap: () {
                      if (_selectedTypeOfPost == 'Registered' ||
                          _selectedTypeOfPost == 'General Post') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                _selectedTypeOfPost == 'Registered'
                                    ? "Express Delivery"
                                    : "Normal Delivery",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                _selectedTypeOfPost == 'Registered'
                                    ? "The magazine will be dispatched by Registered Post. Charges Extra. If you don’t receive, you can claim."
                                    : "The magazine will be dispatched by Ordinary Post. No claim.",
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      const Color.fromARGB(255, 131, 194, 244),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 12,
                      child: Icon(
                        Icons.question_mark,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                Text(
                  'Magazine Subscription Cost',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  width: 320,
                  color: const Color.fromARGB(255, 192, 192, 192),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 10),
                    child: Text(
                      _magazineSubscriptionCost.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Grand Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  width: 320,
                  color: const Color.fromARGB(255, 192, 192, 192),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 10),
                    child: Text(
                      '$_grandTotal',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 13),

                // SizedBox(
                //   height: 3,
                // ),
                Text(
                  errorText,
                  style: TextStyle(
                      color: const Color.fromARGB(255, 176, 60, 51),
                      fontSize: 12),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007b83),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                        onPressed: () {
                          if (_selectedMagazineType != 'Select' &&
                              _selectedPackageForIssue != 'Select' &&
                              (_selectedMagazineType !=
                                      'Print Magazine Hardcopy Only' ||
                                  _selectedTypeOfPost != 'Select')) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MemberDetails(
                                issueIdNo: issueIdNo,
                                postTypeId: postIdNo,
// TODO
                                selectedMagazineType:
                                    _selectedMagazineType.toString(),
                                selectedPackageForIssue:
                                    _selectedPackageForIssue.toString(),
                                selectedTypeOfPost:
                                    _selectedTypeOfPost.toString(),
                                grandTotal: _grandTotal,
                                magazineSubscriptionCost:
                                    _magazineSubscriptionCost,
                              ),
                            ));
                          } else {
                            setState(() {
                              errorText = _selectedMagazineType == 'Select'
                                  ? "Please Select Magazine Type"
                                  : _selectedPackageForIssue == 'Select'
                                      ? 'Please Select Issue'
                                      : _selectedMagazineType ==
                                                  'Print Magazine Hardcopy Only' &&
                                              _selectedTypeOfPost == 'Select'
                                          ? 'Please Select Post Type'
                                          : '';
                            });
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Proceed",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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

                          // if (_selectedMagazineType != null &&
                          //     _selectedPackageForIssue != null) {
                          //   Navigator.pop(
                          //       context); // Close modal after subscribing
                          // }
                        },
                        child: const Center(
                          child: Text(
                            "Cancle",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//^_________________________________________________________________________________
