import 'package:flutter/material.dart';
import 'package:maryam/widgets/reusable_webview.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return const ReusableWebView(
        title: "Privacy Policy", url: "https://emaryam.com/#/PrivacyPolicy");
  }
}
