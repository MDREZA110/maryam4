import 'package:flutter/material.dart';
import 'package:maryam/widgets/suscribe/subscribe_screen.dart';

class HomeAppBar extends StatefulWidget {
  final VoidCallback toggleSearching;
  //final Function(String) search;
  // final VoidCallback search;

  //final bool hideSearchIcon;
  const HomeAppBar({
    super.key,
    required this.toggleSearching,
    // required this.search
    /*required this.hideSearchIcon*/
  });

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  //bool _isSearching = false;
  // final TextEditingController _searchController = TextEditingController();

  // ignore: unused_element
  void _showSubscribeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SubscribeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFCD3864),
      title: Image.asset(
        'assets/images/logo.png',
        height: 24,
      ),
      actions: [
        // if (!   widget.hideSearchIcon)
        IconButton(
          icon: Image.asset(
            'assets/images/icon_search.png',
            height: 20,
          ),
          onPressed: () {
            widget.toggleSearching();
          },
        ),
        IconButton(
          icon: Image.asset(
            'assets/images/icon_subscribe.png',
            height: 20,
          ),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SubscribeScreen(),
          )),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}



























//^--------------------------------------------  worining ----------------------
// import 'package:flutter/material.dart';
// import 'package:maryam/widgets/suscribe/subscribe_screen.dart';

// class HomeAppBar extends StatefulWidget {
//   const HomeAppBar({super.key});

//   @override
//   _HomeAppBarState createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends State<HomeAppBar> {
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();

//   // ignore: unused_element
//   void _showSubscribeModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => const SubscribeScreen(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFCD3864),
//         title: Image.asset(
//           'assets/images/logo.png',
//           height: 24,
//         ),
//         actions: [
//           IconButton(
//             icon: Image.asset(
//               'assets/images/icon_search.png',
//               height: 20,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//               });
//             },
//           ),
//           IconButton(
//               icon: Image.asset(
//                 'assets/images/icon_subscribe.png',
//                 height: 20,
//               ),
//               onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => SubscribeScreen(),
//                   ))
//               // _showSubscribeModal(context),
//               ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (_isSearching) // Search bar appears below AppBar when toggled
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: TextField(
//                 controller: _searchController,
//                 autofocus: true,
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   prefixIcon: const Icon(Icons.search, color: Colors.black54),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                 ),
//               ),
//             ),
//           const Expanded(
//             child: Center(
//               child: Text(
//                 "Your Main Content Here",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//^_______________________________________
// class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const HomeAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   _HomeAppBarState createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends State<HomeAppBar> {
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFFCD3864),
//       toolbarHeight: kToolbarHeight,
//       title: _isSearching
//           ? TextField(
//               controller: _searchController,
//               autofocus: true,
//               decoration: const InputDecoration(
//                 hintText: 'Search...',
//                 hintStyle: TextStyle(color: Colors.white70),
//                 border: InputBorder.none,
//               ),
//               style: const TextStyle(color: Colors.white),
//             )
//           : Image.asset(
//               'assets/images/logo.png',
//               height: 24,
//             ),
//       actions: [
//         IconButton(
//           icon: Image.asset(
//             'assets/images/icon_search.png',
//             height: 20,
//           ),
//           onPressed: () {
//             setState(() {
//               _isSearching = !_isSearching;
//             });
//           },
//         ),
//         IconButton(
//           icon: Image.asset(
//             'assets/images/icon_subscribe.png',
//             height: 20,
//           ),
//           onPressed: () {
//             // Add your onPressed code here!
//           },
//         ),
//         const SizedBox(width: 10),
//       ],
//       bottom: _isSearching
//           ? PreferredSize(
//               preferredSize: const Size.fromHeight(60.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     prefixIcon: const Icon(Icons.search, color: Colors.white70),
//                     hintStyle: const TextStyle(color: Colors.white70),
//                     filled: true,
//                     fillColor: Colors.white24,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }


//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^!

// import 'package:flutter/material.dart';

// class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const HomeAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   _HomeAppBarState createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends State<HomeAppBar> {
//   bool _isSearching = false;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFFCD3864),
//       toolbarHeight: kToolbarHeight,
//       actions: [
//         Padding(
//           padding: EdgeInsets.only(bottom: _isSearching ? 80 : 0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Image.asset(
//                     'assets/images/logo.png',
//                     height: 24,
//                   ),
//                   const SizedBox(
//                     width: 80,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                         icon: Image.asset(
//                           'assets/images/icon_search.png',
//                           height: 20,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _isSearching = !_isSearching;
//                           });
//                         },
//                       ),
//                       IconButton(
//                         icon: Image.asset(
//                           'assets/images/icon_subscribe.png',
//                           height: 20,
//                         ),
//                         onPressed: () {
//                           // Add your onPressed code here!
//                         },
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               if (_isSearching)
//                 const TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(color: Colors.white),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



// ^---------------------------

// import 'package:flutter/material.dart';

// class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const HomeAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   _HomeAppBarState createState() => _HomeAppBarState();
// }

// class _HomeAppBarState extends State<HomeAppBar> {
//   bool _isSearching = false;

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFFCD3864),
//       toolbarHeight: 40,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 16),
//         child: Image.asset(
//           'assets/images/logo.png',
//           height: 44,
//         ),
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           IconButton(
//             icon: Image.asset(
//               'assets/images/icon_search.png',
//               height: 20,
//             ),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//               });
//             },
//           ),
//           IconButton(
//             icon: Image.asset(
//               'assets/images/icon_subscribe.png',
//               height: 20,
//             ),
//             onPressed: () {
//               // Add your onPressed code here!
//             },
//           ),
//           const SizedBox(width: 10),
//         ],
//       ),
//       bottom: _isSearching
//           ? const PreferredSize(
//               preferredSize: Size.fromHeight(10.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   hintStyle: TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Color(0xFFCD3864),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(0.0)),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 ),
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//           : null,
//     );
//   }
// }
