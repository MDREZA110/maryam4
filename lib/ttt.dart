// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:page_flip/page_flip.dart';

// class FlipBookScreen extends StatefulWidget {
//   const FlipBookScreen({super.key, required this.pdfUrl});
//   final String pdfUrl;

//   @override
//   _FlipBookScreenState createState() => _FlipBookScreenState();
// }

// class _FlipBookScreenState extends State<FlipBookScreen> {
//   late PdfDocument _document;
//   List<PdfPageImage?> _pages = [];
//   int _loadedPages = 0;
//   final int _initialBatch = 12;

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialPages();
//   }

//   Future<void> _loadInitialPages() async {
//     _document = await PdfDocument.openData(
//         (await NetworkAssetBundle(Uri.parse(widget.pdfUrl)).load(widget.pdfUrl))
//             .buffer
//             .asUint8List());
//     int totalPages = _document.pagesCount;
//     int pagesToLoad = _initialBatch < totalPages ? _initialBatch : totalPages;
//     List<Future<PdfPageImage?>> pageFutures = [];

//     for (int i = 0; i < pagesToLoad; i++) {
//       pageFutures.add(_loadPage(i + 1));
//     }

//     List<PdfPageImage?> tempPages = await Future.wait(pageFutures);

//     setState(() {
//       _pages = tempPages;
//       _loadedPages = pagesToLoad;
//     });

//     // Load remaining pages in background if any exist.
//     if (_loadedPages < totalPages) {
//       _loadMorePages(totalPages);
//     }
//   }

//   Future<PdfPageImage?> _loadPage(int pageNumber) async {
//     final pdfPage = await _document.getPage(pageNumber);
//     final pageImage = await pdfPage.render(
//       width: pdfPage.width,
//       height: pdfPage.height,
//       format: PdfPageImageFormat.png,
//     );
//     await pdfPage.close();
//     return pageImage;
//   }

//   Future<void> _loadMorePages(int totalPages) async {
//     List<Future<PdfPageImage?>> pageFutures = [];

//     for (int i = _loadedPages; i < totalPages; i++) {
//       pageFutures.add(_loadPage(i + 1));
//     }

//     List<PdfPageImage?> tempPages = await Future.wait(pageFutures);

//     setState(() {
//       _pages.addAll(tempPages);
//       _loadedPages = totalPages;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//         child: _pages.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : PageFlipWidget(
//                 // By giving a key based on the number of pages,
//                 // the widget rebuilds whenever _pages changes.
//                 key: ValueKey(_pages.length),
//                 backgroundColor: Colors.white,
//                 // Note: We do not use the lastPage attribute here.
//                 children: _pages.map((pageImage) {
//                   return pageImage != null
//                       ? Image.memory(pageImage.bytes)
//                       : const Center(child: Text('Page not available'));
//                 }).toList(),
//               ),
//       ),
//     );
//   }
// }





































// // ^import 'package:flutter/material.dart';   Actual code
// // import 'package:pdfx/pdfx.dart';
// // import 'package:page_flip/page_flip.dart';

// // class FlipBookScreen extends StatefulWidget {
// //   const FlipBookScreen({super.key, required this.pdfPath});
// //   final String pdfPath;

// //   @override
// //   _FlipBookScreenState createState() => _FlipBookScreenState();
// // }

// // class _FlipBookScreenState extends State<FlipBookScreen> {
// //   late PdfDocument _document;
// //   List<PdfPageImage?> _pages = [];
// //   int _loadedPages = 0;
// //   final int _initialBatch = 12;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadInitialPages();
// //   }

// //   Future<void> _loadInitialPages() async {
// //     _document = await PdfDocument.openAsset(widget.pdfPath);
// //     int totalPages = _document.pagesCount;
// //     int pagesToLoad = _initialBatch < totalPages ? _initialBatch : totalPages;
// //     List<PdfPageImage?> tempPages = [];

// //     for (int i = 0; i < pagesToLoad; i++) {
// //       final pdfPage = await _document.getPage(i + 1);
// //       final pageImage = await pdfPage.render(
// //         width: pdfPage.width,
// //         height: pdfPage.height,
// //         format: PdfPageImageFormat.png,
// //       );
// //       await pdfPage.close();
// //       tempPages.add(pageImage);
// //     }

// //     setState(() {
// //       _pages = tempPages;
// //       _loadedPages = pagesToLoad;
// //     });

// //     // Load remaining pages in background if any exist.
// //     if (_loadedPages < totalPages) {
// //       _loadMorePages(totalPages);
// //     }
// //   }

// //   Future<void> _loadMorePages(int totalPages) async {
// //     List<PdfPageImage?> tempPages = List.from(_pages);

// //     for (int i = _loadedPages; i < totalPages; i++) {
// //       final pdfPage = await _document.getPage(i + 1);
// //       final pageImage = await pdfPage.render(
// //         width: pdfPage.width,
// //         height: pdfPage.height,
// //         format: PdfPageImageFormat.png,
// //       );
// //       await pdfPage.close();
// //       tempPages.add(pageImage);
// //     }

// //     setState(() {
// //       _pages = tempPages;
// //       _loadedPages = totalPages;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
// //         child: _pages.isEmpty
// //             ? const Center(child: CircularProgressIndicator())
// //             : PageFlipWidget(
// //                 // By giving a key based on the number of pages,
// //                 // the widget rebuilds whenever _pages changes.
// //                 key: ValueKey(_pages.length),
// //                 backgroundColor: Colors.white,
// //                 // Note: We do not use the lastPage attribute here.
// //                 children: _pages.map((pageImage) {
// //                   return pageImage != null
// //                       ? Image.memory(pageImage.bytes)
// //                       : const Center(child: Text('Page not available'));
// //                 }).toList(),
// //               ),
// //       ),
// //     );
// //   }
// // }







// //*------------------------- my code

// // import 'package:flutter/material.dart';
// // import 'package:pdfx/pdfx.dart';
// // import 'package:page_flip/page_flip.dart';

// // class FlipBookScreen extends StatefulWidget {
// //   const FlipBookScreen({super.key, required this.pdfPath});

// //   final String pdfPath;

// //   @override
// //   _FlipBookScreenState createState() => _FlipBookScreenState();
// // }

// // class _FlipBookScreenState extends State<FlipBookScreen> {
// //   int page = 0;
// //   final _controller = GlobalKey<PageFlipWidgetState>();
// //   late PdfDocument _document;
// //   List<PdfPageImage?> _pages = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initialLoadDocument();
// //   }

// //   Future<void> _initialLoadDocument() async {
// //     page = 12;
// //     _document = await PdfDocument.openAsset(widget.pdfPath);
// //     const pageCount = 12;
// //     List<PdfPageImage?> tempPages = List.filled(pageCount, null);

// //     for (int i = 0; i < pageCount; i++) {
// //       final page = await _document.getPage(i + 1);
// //       final pageImage = await page.render(
// //         width: page.width,
// //         height: page.height,
// //         format: PdfPageImageFormat.png,
// //       );
// //       await page.close();
// //       tempPages[i] = pageImage;
// //     }

// //     setState(() {
// //       _pages += tempPages;
// //     });
// //   }

// //   Future<void> _loadDocument() async {
// //     _document = await PdfDocument.openAsset(widget.pdfPath);
// //     final pageCount = _document.pagesCount;
// //     List<PdfPageImage?> tempPages = List.filled(pageCount, null);

// //     for (int i = page - 1; i < pageCount; i++) {
// //       final page = await _document.getPage(i + 1);
// //       final pageImage = await page.render(
// //         width: page.width,
// //         height: page.height,
// //         format: PdfPageImageFormat.png,
// //       );
// //       await page.close();
// //       tempPages[i] = pageImage;
// //     }

// //     setState(() {
// //       _pages = tempPages;
// //       page++;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(title: Text("Flipbook PDF")),
// //         body: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 5),
// //           child: _pages.isEmpty
// //               ? Center(child: CircularProgressIndicator())
// //               : PageFlipWidget(
// //                   key: _controller,
// //                   backgroundColor: Colors.white,
// //                   lastPage: Center(child: Text('End of Document')),
// //                   children: _pages
// //                       .map((pageImage) => pageImage != null
// //                           ? Image.memory(pageImage.bytes)
// //                           : Center(child: Text('Page not available')))
// //                       .toList(),
// //                 ),
// //         ));
// //   }
// // }



// //!---------------   WORKING CODE  (below)---------------
// // import 'package:flutter/material.dart';
// // import 'package:pdfx/pdfx.dart';
// // import 'package:page_flip/page_flip.dart';

// // class FlipBookScreen extends StatefulWidget {
// //   const FlipBookScreen({super.key, required this.pdfPath});

// //   final String pdfPath;
// //   @override
// //   _FlipBookScreenState createState() => _FlipBookScreenState();
// // }

// // class _FlipBookScreenState extends State<FlipBookScreen> {
// //   final _controller = GlobalKey<PageFlipWidgetState>();
// //   late PdfDocument _document;
// //   List<PdfPageImage?> _pages = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadDocument();
// //   }

// //   Future<void> _loadDocument() async {
// //     _document = await PdfDocument.openAsset(widget.pdfPath);
// //     final pageCount = _document.pagesCount;
// //     List<PdfPageImage?> tempPages = List.filled(pageCount, null);

// //     for (int i = 0; i < pageCount; i++) {
// //       final page = await _document.getPage(i + 1);
// //       final pageImage = await page.render(
// //         width: page.width,
// //         height: page.height,
// //         format: PdfPageImageFormat.png,
// //       );
// //       await page.close();
// //       tempPages[i] = pageImage;
// //     }

// //     setState(() {
// //       _pages = tempPages;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         appBar: AppBar(title: Text("Flipbook PDF")),
// //         body: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 5),
// //           child: _pages.isEmpty
// //               ? Center(child: CircularProgressIndicator())
// //               : PageFlipWidget(
// //                   key: _controller,
// //                   backgroundColor: Colors.white,
// //                   lastPage: Center(child: Text('End of Document')),
// //                   children: _pages
// //                       .map((pageImage) => pageImage != null
// //                           ? Image.memory(pageImage.bytes)
// //                           : Center(child: Text('Page not available')))
// //                       .toList(),
// //                 ),
// //         ));
// //   }
// // }


// //^----------------
// // class PDFScreen extends StatefulWidget {
// //   const PDFScreen({super.key, required this.pdfPath});
// //   final String pdfPath;

// //   @override
// //   _PDFScreenState createState() => _PDFScreenState();
// // }

// // class _PDFScreenState extends State<PDFScreen> {
// //   late PdfController _pdfController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pdfController = PdfController(
// //       document: PdfDocument.openAsset('assets/pdfs/TheNowHabit.pdf'),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _pdfController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("PDF Viewer")),
// //       body: PdfView(controller: _pdfController),
// //     );
// //   }
// // }
