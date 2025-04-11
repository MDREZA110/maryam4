import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:maryam/providers/text_size_provider.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:maryam/services.dart/cardscreen_comntent.dart';
import 'package:http/http.dart' as http;
import 'package:maryam/tabs/tab.dart';
import 'package:maryam/widgets/cardAndOpen/card_reuseable.dart';
import 'package:provider/provider.dart';

class WrCardScreen extends StatefulWidget {
  const WrCardScreen({super.key, required this.contentId});

  final int contentId;

  @override
  State<WrCardScreen> createState() => _WrCardScreenState();
}

class _WrCardScreenState extends State<WrCardScreen> {
  List<Map<String, dynamic>> contentList = [];
  List<Map<String, dynamic>> recentCardItems = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();

    //   fetchContent();
  }

// //^ api recent api

//   Future<void> fetchContent() async {
//     final url = Uri.parse(
//         "https://api.emaryam.com/WebService.asmx/ViewRecentPageDetails");

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "MenuId": 2,
//           "SubMenuId": 0,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         recentCardItems =
//             List<dynamic>.from(data['d']).cast<Map<String, dynamic>>();
//         print("recentCardItems: $recentCardItems");
//         setState(() {
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error fetching content: $e');
//       recentCardItems = []; // reset list on error
//     }
//   }

//^ for content from sub-menu get detail
  Future<void> fetchData() async {
    final url = Uri.parse(
        'https://api.emaryam.com/WebService.asmx/GetContentImageDetails');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"ContentId": widget.contentId.toString()}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['d']['status'] == 'success' && data['d']['data'] is List) {
          setState(() {
            contentList = List<Map<String, dynamic>>.from(data['d']['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No data available';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data';
        isLoading = false;
      });
    }
  }

//^ for content from sub-menu get detail

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final textSizeProvider = context.watch<TextSizeProvider>();
    context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode state
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

//^ AppBar

        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFCD3864),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image.asset(
                //   'assets/images/logo.png',
                //   height: 24,
                //   // fit: BoxFit.fitHeight,
                // ),

                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyTabBar(),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 24,
                  ),
                ),

                const SizedBox(
                  width: 200,
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     IconButton(
                //       icon: Image.asset(
                //         'assets/images/icon_search.png',
                //         height: 20,
                //       ),
                //       onPressed: () {
                //         // Add your onPressed code here!
                //       },
                //     ),
                //     IconButton(
                //       icon: Image.asset(
                //         'assets/images/icon_subscribe.png',
                //         height: 20,
                //       ),
                //       onPressed: () {
                //         // Add your onPressed code here!
                //       },
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     )
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),

//^ BODY

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(18), // Rounded corners
                        child: Image.network(
                          contentList.isNotEmpty
                              ? contentList[0]["ThumbnailImage"].toString()
                              : '',
                          // height: 180,
                          //width: 400,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Center(
                      child: Text(
                        contentList.isNotEmpty
                            ? contentList[0]["Title"].toString()
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 3),
                        child: Html(
                          data: contentList.isNotEmpty
                              ? contentList[0]["Description"].toString()
                              : '',
                          style: {
                            "*": Style(
                              fontSize: FontSize(textSizeProvider.textSize),
                              color: isDarkMode
                                  ? const Color.fromARGB(255, 192, 192, 192)
                                  : Colors.black,
                              // Change font color to red (Modify as needed)
                              backgroundColor: Colors.transparent,
                            ),
                          },
                        ),
                      ),
                    ),
                  ),

                  //^  Recent Card,       Most Watched          & Related Article Card

                  for (int i = 1; i <= 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 20,
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                                i == 1
                                    ? "Recent"
                                    : i == 2
                                        ? "Most Watched"
                                        : "Related Article",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      // const Color.fromARGB(255, 70, 70, 70),
                                      const Color(0xFFCD3864),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 70,
                              ),
                              child: Divider(
                                thickness: 5,
                                color: const Color.fromARGB(255, 70, 70, 70),
                              ),
                            ),
                            MyCard(
                              image:
                                  // contentList.isNotEmpty
                                  // ? contentList[0]["ThumbnailImage"].toString()
                                  // :
                                  "https://emaryam.com/Uploads/Content/ThumbnailImage/323035.jpeg",
                              title:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Title"].toString()
                                  //     :
                                  "संगत का असर",
                              contentId:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["ContentId"]
                                  //     :
                                  40,
                              description:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Description"].toString()
                                  //     :
                                  "तरन्नुम आबिदी, सरफ़राज़गंज लखनऊ",
                              content:
                                  // contentList.isNotEmpty
                                  //     ? contentList[0]["Content"].toString()
                                  //     :
                                  "हम जिस भी उम्र में हों संगत का असर हमारे ऊपर होता ही होता है कभी फ़ौरन कभी धीरे-धीरे जो हम को पता नहीं चलता। हम कभी संगत ख़ुद चुनते हैं कभी वक़्त हालात किसी का साथ कर देता है।",
                            ),
                            MyCard(
                              image:
                                  // contentList.isNotEmpty
                                  // ? contentList[0]["ThumbnailImage"].toString()
                                  // :
                                  "http://emaryam.com/Uploads/Content/ThumbnailImage/76813.jpg",
                              title:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Title"].toString()
                                  //     :
                                  "एक-दूसरे से वादा कीजिए 011",
                              contentId:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["ContentId"]
                                  //     :
                                  30,
                              description:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Description"].toString()
                                  //     :
                                  "Mariyam Magazine",
                              content:
                                  // contentList.isNotEmpty
                                  //     ? contentList[0]["Content"].toString()
                                  //     :
                                  "शादी के बाद शुरु की ज़िन्दगी बड़ी ख़ूबसूरत, इमोशंस से भरी और मोहब्बत से भरपूर होती है। इस टाइम से भरपूर फ़ायदा उठाना चाहिए और आने वाले वक़्त को और भी ख़ूबसूरत ",
                            ),
                            MyCard(
                              image:
                                  // contentList.isNotEmpty
                                  // ? contentList[0]["ThumbnailImage"].toString()
                                  // :
                                  "http://emaryam.com/Uploads/Content/ThumbnailImage/51481.jpg",
                              title:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Title"].toString()
                                  //     :
                                  "एक-दूसरे से वादा कीजिए 01",
                              contentId:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["ContentId"]
                                  //     :
                                  28,
                              description:
                                  //  contentList.isNotEmpty
                                  //     ? contentList[0]["Description"].toString()
                                  //     :
                                  "Mariyam Magazine",
                              content:
                                  // contentList.isNotEmpty
                                  //     ? contentList[0]["Content"].toString()
                                  //     :
                                  "शादी के बाद शुरु की ज़िन्दगी बड़ी ख़ूबसूरत, इमोशंस से भरी और मोहब्बत से भरपूर होती है। इस टाइम से भरपूर फ़ायदा उठाना चाहिए और आने वाले वक़्त को और भी ख़ूबसूरत बनाने के लिए एक-दूसरे से कुछ वादे भी करना चाहिएं। यह वादे इसलिए ज़रूरी हैं ताकि एक-दूसरे पर भरोसा, दोस्ती और मोहब्बत ",
                            ),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}


// final textSizeProvider = Provider.of<TextSizeProvider>(context);

//   fontSize: FontSize(textSizeProvider.textSize),


//  textSizeProvider.textSize, 




















// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:maryam/services.dart/cardscreen_comntent.dart';
// import 'package:http/http.dart' as http;

// class WrCardScreen extends StatefulWidget {
//   const WrCardScreen({super.key, this.date, required this.contentId});
//   final String? date;
//   final int contentId;

//   @override
//   State<WrCardScreen> createState() => _WrCardScreenState();
// }

// class _WrCardScreenState extends State<WrCardScreen> {
//   List<Map<String, dynamic>> contentList = [];
//   bool isLoading = true;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final url = Uri.parse(
//         'https://api.emaryam.com/WebService.asmx/GetContentImageDetails');

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"ContentId": widget.contentId.toString()}),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['d']['status'] == 'success' && data['d']['data'] is List) {
//           setState(() {
//             contentList = List<Map<String, dynamic>>.from(data['d']['data']);
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             errorMessage = 'No data available';
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Error: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to load data';
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),

// //^ AppBar

//         child: AppBar(
//           backgroundColor: const Color(0xFFCD3864),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Image.asset(
//                   'assets/images/logo.png',
//                   height: 24,
//                   // fit: BoxFit.fitHeight,
//                 ),
//                 const SizedBox(
//                   width: 80,
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: Image.asset(
//                         'assets/images/icon_search.png',
//                         height: 20,
//                       ),
//                       onPressed: () {
//                         // Add your onPressed code here!
//                       },
//                     ),
//                     IconButton(
//                       icon: Image.asset(
//                         'assets/images/icon_subscribe.png',
//                         height: 20,
//                       ),
//                       onPressed: () {
//                         // Add your onPressed code here!
//                       },
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),

// //^ BODY

//       body: SingleChildScrollView(
//         child: Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                 ),
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(18), // Rounded corners
//                     child: Image.network(
//                       contentList.isNotEmpty
//                           ? contentList[0]["ThumbnailImage"].toString()
//                           : '',
//                     )),
//               ),
//               const SizedBox(
//                 height: 6,
//               ),
//               Text(
//                 contentList.isNotEmpty
//                     ? contentList[0]["Title"].toString()
//                     : '',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.pink,
//                 ),
//               ),
//               // const SizedBox(height: 3),
//               // const Text(
//               //   'maryam Magazine / Apr 24 2023',
//               //   style: TextStyle(fontSize: 14),
//               // ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
//                 // ignore: avoid_unnecessary_containers
//                 child: Container(
//                   //height: double.infinity,
//                   //color: const Color(0xFFF3F3F3),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 20,
//                     ),
//                     child: Html(
//                       data: contentList[0]["Description"].toString(),
//                       // child: Text(
//                       //     "शोहर आम तौर पर ज़्यादा तकलीफ पहुँचाने वाले होते हैं। अगर सब्र ओर बर्दाश्त का एवार्ड दिया जाए तो हमारे यहाँ मेट्रिक, इन्टर के बोर्ड रिजल्ट की तरहबीवियाँ ही अकसर मेडेल्स ओर एवार्ड समेट कर ले जाएंगी, शोहर पीछे रह जाएंगे। ओरत के कई रूप हैं, उनमें से माँ का रूप एक ऐसा रूप हे जो एहतराम के साथ-साथ मोहब्बत, कुर्बानी, ईसार और बेहद खुलूस के जज़्बों से गुंधा हुआहै। शायद ही कोई ऐसा होगा जिसे अपनी माँ से शिकायत हो। हो सकता है कि बहुत सी माएं बीवी या बहू के रूप में शायद अच्छी न रही हों, मगर अपने बच्चों पर वह जान छिड़कती रहीं। बच्चा चाहे बड़ा हो जाए, जवान बल्कि अधेड़ उम्र का हो जाए, माँ की मोहब्बत में कोई कमी नहीं आती।इसी तरह बेटी का रिश्ता है, बीवी का रिश्ता है। सास, बहू, भाभी, चची, मुमानी, खाला, फूफ़ी और दूसरे रिश्ते हैं, नानी, दादी का रिश्ता है। यह सब ओरतें ही हैं। मर्दो को अकसर इनमें से ज़्यादा रिश्तों से कोई शिकवा-शिकायत नहीं होती बल्कि वह उनकी मोहब्बतों का शुक्रिया अदा करते हैं। हमारी दादी के कई रूप हैं!"),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }