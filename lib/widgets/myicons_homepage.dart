import 'package:flutter/material.dart';
import 'package:maryam/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MyIcons extends StatefulWidget {
  final String imagePath;
  final String text;
  final double avatarRadius;
  final double iconSize;
  final VoidCallback? onClick;
  final double boxHeight;
  final bool? changecolor;

  const MyIcons(
      {super.key,
      required this.imagePath,
      required this.text,
      this.avatarRadius = 27.0,
      this.iconSize = 45.0,
      this.boxHeight = 0,
      this.onClick,
      this.changecolor = false});

  @override
  State<MyIcons> createState() => _MyIconsState();
}

class _MyIconsState extends State<MyIcons> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    bool isDarkMode = themeProvider.isDarkMode; // Get dark mode from Provider

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onClick,
      child: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: widget.changecolor == true
                    ? const Color(0xFF11A9B2)
                    : const Color(0xFFCD3864),
                radius: widget.avatarRadius,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: widget.boxHeight,
                      ),
                      Image.asset(
                        widget.imagePath,
                        height: widget.iconSize,
                        width: widget.iconSize,
                      ),
                      SizedBox(
                        height:
                            widget.boxHeight == 0 ? 7 : widget.boxHeight - 2,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.text,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 11),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//^  gpt wala  niche
// import 'package:flutter/material.dart';

// class MyIcons extends StatefulWidget {
//   final String imagePath;
//   final String text;
//   final double avatarRadius;
//   final double iconSize;
//   final VoidCallback? onClick;
//   final double boxHeight;
//   final bool? changecolor;

//   const MyIcons({
//     super.key,
//     required this.imagePath,
//     required this.text,
//     this.avatarRadius = 27.0,
//     this.iconSize = 45.0,
//     this.boxHeight = 10.0,
//     this.onClick,
//     this.changecolor = false,
//   });

//   @override
//   State<MyIcons> createState() => _MyIconsState();
// }

// class _MyIconsState extends State<MyIcons> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: widget.onClick,
//       child: Container(
//         width: 100, // Ensure a defined width
//         constraints: const BoxConstraints(
//             minHeight: 80, maxHeight: 150), // Prevents infinite expansion
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               backgroundColor: widget.changecolor == true
//                   ? const Color(0xFF11A9B2)
//                   : const Color(0xFFCD3864),
//               radius: widget.avatarRadius,
//               child: SizedBox(
//                 width: widget.avatarRadius * 1.8,
//                 height: widget.avatarRadius * 1.8,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: widget.boxHeight),
//                     Image.asset(
//                       widget.imagePath,
//                       height: widget.iconSize,
//                       width: widget.iconSize,
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(
//                         height:
//                             widget.boxHeight == 0 ? 7 : widget.boxHeight - 2),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               widget.text,
//               style: const TextStyle(color: Colors.black, fontSize: 11),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
