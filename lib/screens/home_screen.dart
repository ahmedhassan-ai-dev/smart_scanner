import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_scenner/features/history/data/history_service.dart';
import 'package:smart_scenner/features/history/models/document_history.dart';
import 'package:smart_scenner/features/history/widgets/document_card.dart';
import 'package:smart_scenner/features/scanner/data/scanner_service.dart';
import 'package:smart_scenner/screens/filter_screen.dart';
import 'package:smart_scenner/features/scanner/camera_scanner_screen.dart';
import 'package:smart_scenner/screens/pdf_preview_screen.dart';
import 'package:smart_scenner/features/ocr/data/ocr_service.dart';
import 'package:smart_scenner/features/ocr/screens/ocr_result_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  Future<void> uploadImage(String imagePath) async {
    setState(() {
      loading = true;
    });

    try {
      final result = await ScannerService().uploadImage(imagePath);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FilterScreen(
            scanResponse: result,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    await uploadImage(image.path);
  }

  Future<void> openCamera() async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScannerScreen(),
      ),
    );

    if (imagePath == null) return;

    await uploadImage(imagePath);
  }

  Future<void> openOCR() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      loading = true;
    });

    try {
      final text = await OCRService().recognizeText(image.path);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OCRResultScreen(
            text: text,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> renameDocument(
    int hiveIndex,
    DocumentHistory document,
  ) async {
    final controller = TextEditingController(
      text: document.fileName,
    );

    final newName = await showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Rename"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Document name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  controller.text.trim(),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (newName == null || newName.isEmpty) return;

    await HistoryService.updateDocument(
      hiveIndex,
      DocumentHistory(
        fileName: newName,
        pdfUrl: document.pdfUrl,
        thumbnailUrl: document.thumbnailUrl,
        pagesCount: document.pagesCount,
        createdAt: document.createdAt,
      ),
    );
  }

  Future<void> deleteDocument(int hiveIndex) async {
    await HistoryService.deleteDocument(hiveIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. تغيير لون الخلفية وإزالة الـ AppBar
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. إضافة الهيدر الجديد
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Smart Scanner",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(Icons.notifications_none, color: Colors.black87),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsScreen(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(Icons.settings, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // 4. Hero Card للـ Scan Document
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff316BFF),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff316BFF).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.document_scanner_outlined,
                              color: Colors.white,
                              size: 70,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Ready to Scan?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tap to Capture",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 25),
                            ElevatedButton(
                              onPressed: openCamera,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xff316BFF),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Start Scanning",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // 5. استبدال الـ 3 Cards بـ Row
                      Row(
                        children: [
                          _buildActionCard(
                            "Scan",
                            Icons.camera_alt,
                            Colors.blue,
                            openCamera,
                          ),
                          const SizedBox(width: 12),
                          _buildActionCard(
                            "Gallery",
                            Icons.photo_library,
                            Colors.green,
                            openGallery,
                          ),
                          const SizedBox(width: 12),
                          _buildActionCard(
                            "OCR",
                            Icons.text_snippet,
                            Colors.orange,
                            openOCR,
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      // 6. ترك هذا الجزء كما هو (الـ Documents)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Recent Documents",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ValueListenableBuilder(
                        valueListenable: HistoryService.box.listenable(),
                        builder: (context, box, child) {
                          final documents =
                              HistoryService.getDocuments().reversed.toList();

                          if (documents.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                "No Documents Yet",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (_, index) {
                              final document = documents[index];
                              final hiveIndex =
                                  documents.length - 1 - index;

                              return DocumentCard(
                                document: document,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PdfPreviewScreen(
                                        pdfPath: document.pdfUrl,
                                      ),
                                    ),
                                  );
                                },
                                onRename: () async {
                                  await renameDocument(
                                    hiveIndex,
                                    document,
                                  );
                                },
                                onDelete: () async {
                                  await deleteDocument(
                                    hiveIndex,
                                  );
                                },
                                onShare: () async {
                                  // Share code
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء الأزرار الثلاثة (Scan, Gallery, OCR) لتنظيم الكود
  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}