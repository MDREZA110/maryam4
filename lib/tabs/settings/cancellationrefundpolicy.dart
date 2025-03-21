// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class CancellationRefundPolicyScreen extends StatefulWidget {
//   const CancellationRefundPolicyScreen({super.key});

//   @override
//   State<CancellationRefundPolicyScreen> createState() =>
//       _CancellationRefundPolicyScreenState();
// }

// class _CancellationRefundPolicyScreenState
//     extends State<CancellationRefundPolicyScreen> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(
//           Uri.parse("https://emaryam.com/#/Refund%20&%20cancellation"));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("WebView Example")),
//       body: SafeArea(
//         child: WebViewWidget(controller: controller),
//       ),
//     );
//   }
// }

//^^^^^^^^^^^^^^^^^^^^^^^^^^^

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class CancellationRefundPolicyScreen extends StatefulWidget {
//   const CancellationRefundPolicyScreen({super.key});

//   @override
//   State<CancellationRefundPolicyScreen> createState() =>
//       _CancellationRefundPolicyScreenState();
// }

// class _CancellationRefundPolicyScreenState
//     extends State<CancellationRefundPolicyScreen> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageFinished: (url) {
//           _removeHeaderFooter();
//         },
//       ))
//       ..loadRequest(
//           Uri.parse("https://emaryam.com/#/Refund%20&%20cancellation"));
//   }

//   void _removeHeaderFooter() {
//     controller.runJavaScript("""
//       document.querySelector('header')?.remove();
//       document.querySelector('footer')?.remove();
//       document.querySelector('.navbar')?.remove();
//       document.querySelector('.top-bar')?.remove();
//       document.querySelector('.site-footer')?.remove();
//     """);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cancellation & Refund Policy")),
//       body: SafeArea(
//         child: WebViewWidget(controller: controller),
//       ),
//     );
//   }
// }

//^  -------- old working code ------------

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ShippingAndRefundPolicy extends StatefulWidget {
//   const ShippingAndRefundPolicy({super.key});

//   @override
//   State<ShippingAndRefundPolicy> createState() =>
//       _ShippingAndRefundPolicyState();
// }

// class _ShippingAndRefundPolicyState
//     extends State<ShippingAndRefundPolicy> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(NavigationDelegate(
//         onPageFinished: (url) {
//           _removeHeaderFooter();
//         },
//       ))
//       // ..loadRequest(Uri.parse("https://www.oversimplifiedcoding.com"));
//       ..loadRequest(
//           Uri.parse("https://emaryam.com/#/Shipping%20&%20Delivery%20Policy"));
//   }

//   // document.querySelector('footer')?.remove();
//   //  document.querySelector('.bg-dark')?.remove();    .bg-dark  is class (stat with '.')  (if start with '#' it is id)
//   void _removeHeaderFooter() {
//     controller.runJavaScript('''
//       document.querySelector('header')?.remove();

//     ''');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Cancellation & Refund Policy"),
//         // actions: <Widget>[
//         //   InkWell(
//         //     child: const Icon(Icons.refresh),
//         //     onTap: () {
//         //       controller.reload();
//         //     },
//         //   ),
//         // ],
//       ),
//       body: SafeArea(
//         child: WebViewWidget(controller: controller),
//       ),
//     );
//   }
// }
//^    -----------------  end  ------------------

import 'package:flutter/material.dart';
import 'package:maryam/widgets/reusable_webview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CancellationRefundPolicyScreen extends StatefulWidget {
  const CancellationRefundPolicyScreen({super.key});

  @override
  State<CancellationRefundPolicyScreen> createState() =>
      _CancellationRefundPolicyScreenState();
}

class _CancellationRefundPolicyScreenState
    extends State<CancellationRefundPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return const ReusableWebView(
        title: "Cancellation & Refund Policy",
        url: "https://emaryam.com/#/Shipping & Delivery Policy");
  }
}
