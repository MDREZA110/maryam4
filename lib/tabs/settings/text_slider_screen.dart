// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:maryam/models/sharedpref.dart';
// import 'package:maryam/providers/text_size_provider.dart';

// class TextSizeScreen extends StatelessWidget {
//   const TextSizeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => TextSizeProvider(),
//       child: _TextSizeScreenContent(),
//     );
//   }
// }

// class _TextSizeScreenContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final textSizeProvider = Provider.of<TextSizeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: Text('Adjust Text Size')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Adjustable text size preview',
//               style: TextStyle(fontSize: textSizeProvider.textSize),
//             ),

//             SizedBox( height:  40),

//              Text(
//               'टेक्स्ट प्रीव्यू',
//               style: TextStyle(fontSize: textSizeProvider.textSize),
//             ),

//             //
//             SizedBox(height: 80),
//             Slider(
//               value: textSizeProvider.textSize,
//               min: 12.0,
//               max: 30.0,
//               divisions: 18,
//               label: textSizeProvider.textSize.toStringAsFixed(1),
//               onChanged: (value) {
//                 textSizeProvider.setTextSize(value);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//^-------------

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:maryam/models/sharedpref.dart';
// import 'package:maryam/providers/text_size_provider.dart';

// class TextSizeScreen extends StatelessWidget {
//   const TextSizeScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => TextSizeProvider(),
//       child: _TextSizeScreenContent(),
//     );
//   }
// }

// class _TextSizeScreenContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final textSizeProvider = Provider.of<TextSizeProvider>(context);
//     return Scaffold(
//       appBar: AppBar(title: Text('Adjust Text Size')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Top space
//             SizedBox(height: MediaQuery.of(context).size.height * 0.15),

//             // Text preview section
//             Text(
//               'Adjustable text size preview',
//               style: TextStyle(fontSize: textSizeProvider.textSize),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'टेक्स्ट प्रीव्यू',
//               style: TextStyle(fontSize: textSizeProvider.textSize),
//               textAlign: TextAlign.center,
//             ),

//             // Flexible space that pushes slider to be slightly below center
//             Spacer(flex: 1),

//             // Slider slightly below center
//             Slider(
//               value: textSizeProvider.textSize,
//               min: 12.0,
//               max: 30.0,
//               divisions: 18,
//               label: textSizeProvider.textSize.toStringAsFixed(1),
//               onChanged: (value) {
//                 textSizeProvider.setTextSize(value);
//               },
//             ),

//             // Bottom space to balance the layout
//             Spacer(flex: 1),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maryam/models/sharedpref.dart';
import 'package:maryam/providers/text_size_provider.dart';

// class TextSizeScreen extends StatelessWidget {
//   const TextSizeScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => TextSizeProvider(),
//       child: _TextSizeScreenContent(),
//     );
//   }

// }

class TextSizeScreen extends StatelessWidget {
  const TextSizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TextSizeScreenContent(); // ✅ Uses the existing provider
  }
}

class _TextSizeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Adjust Text Size')),
      body: Stack(
        children: [
          // Text content positioned at the top
          Positioned(
            top: screenHeight * 0.2, // Position at 20% from the top
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    'Adjustable text size preview',
                    style: TextStyle(fontSize: textSizeProvider.textSize),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'टेक्स्ट प्रीव्यू',
                    style: TextStyle(fontSize: textSizeProvider.textSize),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Slider positioned at a fixed location slightly below center
          Positioned(
            top: screenHeight *
                0.5, // Position at 60% from the top (slightly below center)
            left: 16,
            right: 16,
            child: Slider(
              value: textSizeProvider.textSize,
              min: 12.0,
              max: 30.0,
              divisions: 18,
              label: textSizeProvider.textSize.toStringAsFixed(1),
              onChanged: (value) {
                textSizeProvider.setTextSize(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
