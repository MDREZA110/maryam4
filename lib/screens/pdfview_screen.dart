// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:page_flip/page_flip.dart';
// import 'package:path_provider/path_provider.dart';
// //import 'package:pdf_render/pdf_render.dart';

// class FlipbookWidget extends StatelessWidget {
//   const FlipbookWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: PDFBookView(),
//     );
//   }
// }

// class PDFBookView extends StatefulWidget {
//   const PDFBookView({super.key});

//   @override
//   _PDFBookViewState createState() => _PDFBookViewState();
// }

// class _PDFBookViewState extends State<PDFBookView> {
//   List<Image> pages = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadPDF();
//   }

//   Future<void> _loadPDF() async {
//     final pdfPath = await _copyAssetPDF("assets/pdfs/sample.pdf");
//     final document = await PdfDocument.openFile(pdfPath);
//     final pageCount = document.pageCount;

//     List<Image> tempPages = [];
//     for (int i = 1; i <= pageCount; i++) {
//       final page = await document.getPage(i);
//       final image = await page.render();

//       tempPages.add(Image.memory(Uint8List.fromList(image.pixels)));

//       // No need for page.close()
//     }

//     await document.dispose(); // ✅ Dispose the entire document

//     setState(() {
//       pages = tempPages;
//     });
//   }

//   /// Copies PDF from assets to temporary directory
//   Future<String> _copyAssetPDF(String assetPath) async {
//     final bytes = await rootBundle.load(assetPath);
//     final dir = await getTemporaryDirectory();
//     final file = File("${dir.path}/sample.pdf");
//     await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//     return file.path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Flipbook PDF")),
//       body: pages.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : PageFlipWidget(
//               children: pages,
//             ),
//     );
//   }
// }
