import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../features/history/data/history_service.dart';
import '../features/history/models/document_history.dart';
import '../shared/document_manager.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String pdfPath;

  const PdfPreviewScreen({super.key, required this.pdfPath});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  bool isDownloading = false;

  Future<void> downloadPdf() async {
    try {
      setState(() {
        isDownloading = true;
      });

      final status = await Permission.storage.request();

      if (!status.isGranted) {
        throw Exception('Storage permission denied');
      }

      final downloadPath =
          '/storage/emulated/0/Download/scan_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await Dio().download(widget.pdfPath, downloadPath);

      await HistoryService.addDocument(
        DocumentHistory(
          fileName: 'Document_${DateTime.now().millisecondsSinceEpoch}.pdf',
          pdfUrl: downloadPath,
          thumbnailUrl: '',
          pagesCount: DocumentManager.pages.length,
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) return;

      // 5 & 7- SnackBar النجاح المحسن
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text("PDF Saved Successfully"),
          action: SnackBarAction(
            label: "OPEN",
            onPressed: () {
              OpenFilex.open(downloadPath);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // 6- SnackBar الفشل المحسن
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text("Failed to save PDF"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1- الـ AppBar البسيط والحديث
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PDF Preview",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // 4- استخدام Stack لعمل الـ Loading Overlay
      body: Stack(
        children: [
          // 2- خلفية الصفحة والـ PDF بداخل Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                // 8- تحسين تجربة عرض الـ PDF
                child: SfPdfViewer.network(
                  widget.pdfPath,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  enableDoubleTapZooming: true,
                ),
              ),
            ),
          ),

          // 4- الـ Loading Overlay
          if (isDownloading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),

      // 3- الـ Floating Download Button بدلاً من زر الـ AppBar
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isDownloading ? null : downloadPdf,
        icon: isDownloading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.download),
        label: Text(
          isDownloading ? "Downloading..." : "Save PDF",
        ),
      ),
    );
  }
}