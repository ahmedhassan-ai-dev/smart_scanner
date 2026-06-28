import 'package:flutter/material.dart';
import 'package:smart_scenner/shared/document_manager.dart';
import '../features/pdf/data/pdf_service.dart';
import 'pdf_preview_screen.dart';
import '../features/history/data/history_service.dart';
import '../features/history/models/document_history.dart';

class PdfScreen extends StatefulWidget {
  final String pageId;
  final String filterName;

  const PdfScreen({super.key, required this.pageId, required this.filterName});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  static const baseUrl = 'http://192.168.1.106:8000';

  Future deletePage(int index) async {
    final confirm = await showDialog(
      context: context,
      // 12- تحسين الـ Confirmation Dialog
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Page'),
        content: const Text('Are you sure you want to delete this page?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        DocumentManager.removePage(index);
      });

      if (DocumentManager.pages.isEmpty && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1- تحديث الـ AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "PDF Pages",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: DocumentManager.pages.isEmpty
          // 11- شاشة Empty State في حال حذف جميع الصفحات
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No Pages Added",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // 2- رسالة السحب على شكل Card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.drag_indicator, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Drag pages to reorder them before generating the PDF.",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3- Apply Same Filter على شكل Card مع Switch
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_alt,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Use One Filter",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DocumentManager.useSingleFilter
                                  ? "One filter for all pages"
                                  : "Each page keeps its filter",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: DocumentManager.useSingleFilter,
                        onChanged: (v) {
                          setState(() {
                            DocumentManager.useSingleFilter = v;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: DocumentManager.pages.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex--;
                        }
                        final item = DocumentManager.pages.removeAt(oldIndex);
                        DocumentManager.pages.insert(newIndex, item);
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = DocumentManager.pages[index];
                      final variant = page.useCropped ? 'cropped' : 'original';
                      final imageUrl = page.scanResponse
                              .images[variant]?['filters']?[page.selectedFilter] ??
                          '';

                      // 4- تحسين شكل الـ Card
                      return Card(
                        key: ValueKey('${page.scanResponse.pageId}_$index'),
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            // 5- تكبير وتحسين الـ Thumbnail
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      '$baseUrl$imageUrl',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      size: 50),
                            ),

                            // 6- تنسيق عنوان الصفحة
                            title: Text(
                              "Page ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            // 7- الفلتر كـ Chip والنصوص المعدلة
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(
                                      page.selectedFilter,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    padding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    page.useCropped
                                        ? "Auto Cropped"
                                        : "Original",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 8- تحسين زر الحذف
                                GestureDetector(
                                  onTap: () => deletePage(index),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.red.shade50,
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 9- تغيير أيقونة السحب
                                const Icon(
                                  Icons.drag_indicator,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 10- تحسين زر الـ Generate PDF
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final currentContext = context;

                          try {
                            final pdfPath = await PdfService().generatePdf();
                            final firstPage = DocumentManager.pages.first;
                            final variant = firstPage.useCropped
                                ? 'cropped'
                                : 'original';
                            final thumbnailPath = firstPage
                                    .scanResponse
                                    .images[variant]?['filters']
                                        ?[firstPage.selectedFilter] ??
                                '';

                            await HistoryService.addDocument(
                              DocumentHistory(
                                fileName:
                                    'Document_${DateTime.now().millisecondsSinceEpoch}.pdf',
                                pdfUrl: pdfPath,
                                thumbnailUrl: thumbnailPath.isNotEmpty
                                    ? '$baseUrl$thumbnailPath'
                                    : '',
                                pagesCount: DocumentManager.pages.length,
                                createdAt: DateTime.now(),
                              ),
                            );

                            if (!mounted) return;

                            Navigator.pushReplacement(
                              currentContext,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PdfPreviewScreen(pdfPath: pdfPath),
                              ),
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                            if (!mounted) return;
                            ScaffoldMessenger.of(currentContext).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text(
                          "Generate PDF",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}