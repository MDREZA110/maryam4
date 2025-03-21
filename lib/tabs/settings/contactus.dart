import 'package:flutter/material.dart';
import 'package:maryam/widgets/reusable_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return const ReusableWebView(
      title: "Contact-Us",
      url: "https://emaryam.com/#/contact-us",
    );
  }
}
