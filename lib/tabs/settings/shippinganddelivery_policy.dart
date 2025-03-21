import 'package:flutter/material.dart';
import 'package:maryam/widgets/reusable_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShippingAndDeliveryPolicy extends StatefulWidget {
  const ShippingAndDeliveryPolicy({super.key});

  @override
  State<ShippingAndDeliveryPolicy> createState() =>
      _ShippingAndDeliveryPolicyState();
}

class _ShippingAndDeliveryPolicyState extends State<ShippingAndDeliveryPolicy> {
  @override
  Widget build(BuildContext context) {
    return const ReusableWebView(
      title: "Shippng and Refund Policy",
      url: "https://emaryam.com/#/Shipping & Delivery Policy",
    );
  }
}
