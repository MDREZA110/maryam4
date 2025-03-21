import 'package:flutter/material.dart';
import 'package:maryam/widgets/reusable_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => AboutusState();
}

class AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return const ReusableWebView(
      title: "About-Us",
      url: "https://emaryam.com/#/About-us",
    );
  }
}
