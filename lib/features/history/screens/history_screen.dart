import 'package:flutter/material.dart';

import '../data/history_service.dart';
import '../widgets/document_card.dart';
import '../../../screens/pdf_preview_screen.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = HistoryService.getDocuments();

    return Scaffold(
      appBar: AppBar(title: const Text('Recent Documents')),

      body: documents.isEmpty
          ? const Center(child: Text('No Documents Yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];

                return DocumentCard(
  document: doc,

  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          pdfPath: doc.pdfUrl,
        ),
      ),
    );
  },

  onShare: () {
    // سيتم تنفيذ المشاركة هنا
  },

  onRename: () {
    // سيتم تنفيذ إعادة التسمية هنا
  },

  onDelete: () async {
    await HistoryService.deleteDocument(index);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Document deleted"),
        ),
      );

      // إعادة تحميل الشاشة
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
        ),
      );
    }
  },
);
              },
            ),
    );
  }
}
