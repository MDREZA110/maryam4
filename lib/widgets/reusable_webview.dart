// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ReusableWebView extends StatefulWidget {
//   final String title;
//   final String url;

//   const ReusableWebView({
//     super.key,
//     required this.title,
//     required this.url,
//   });

//   @override
//   State<ReusableWebView> createState() => _ReusableWebViewState();
// }

// class _ReusableWebViewState extends State<ReusableWebView> {
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
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   void _removeHeaderFooter() {
//     controller.runJavaScript('''
//          document.querySelector('header')?.remove();
//     ''');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SafeArea(
//         child: WebViewWidget(controller: controller),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReusableWebView extends StatefulWidget {
  final String title;
  final String url;

  const ReusableWebView({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ReusableWebView> createState() => _ReusableWebViewState();
}

class _ReusableWebViewState extends State<ReusableWebView> {
  late final WebViewController controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          _removeHeaderFooter();
        },
      ))
      ..loadRequest(Uri.parse(widget.url));

    // Show loading indicator for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _removeHeaderFooter() {
    Future.delayed(const Duration(seconds: 1), () {
      controller.runJavaScript('''
        document.querySelector('header')?.remove();
      ''');
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_rounded,
              color: isDarkMode ? Colors.white : Colors.black,
            )),
        title: Text(
          widget.title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: controller),
      ),
    );
  }
}












//^-------------   start  [ working code ]   delay 1 sec to remove header  -------------
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class ReusableWebView extends StatefulWidget {
//   final String title;
//   final String url;

//   const ReusableWebView({
//     super.key,
//     required this.title,
//     required this.url,
//   });

//   @override
//   State<ReusableWebView> createState() => _ReusableWebViewState();
// }

// class _ReusableWebViewState extends State<ReusableWebView> {
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
//       ..loadRequest(Uri.parse(widget.url));
//   }


//   void _removeHeaderFooter() {
//     Future.delayed(const Duration(seconds: 1), () {
//       controller.runJavaScript('''
//         document.querySelector('header')?.remove();
//       ''');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: SafeArea(
//         child: WebViewWidget(controller: controller),
//       ),
//     );
//   }
// }

//^-------------  [end]  ------------

