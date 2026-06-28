import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smart_scenner/features/scanner/data/scanner_service.dart';
import 'package:smart_scenner/screens/filter_screen.dart';

class CameraScannerScreen extends StatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> {
  final ImagePicker picker = ImagePicker();

  final ScannerService scannerService = ScannerService();

  bool isLoading = false;

  Future<void> pickFromGallery() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) return;

    await uploadImage(image);
  }

  Future<void> captureImage() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) return;

    await uploadImage(image);
  }

  Future<void> uploadImage(XFile image) async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await scannerService.uploadImage(image.path);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FilterScreen(scanResponse: result)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC), // تناسق مع الخلفية في باقي التطبيق
      // 1. تحديث الـ AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        centerTitle: true,
        title: const Text(
          "Scan Document",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: isLoading
          // 5. شاشة التحميل الكاملة
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Uploading document...",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          // 2. استخدام SafeArea و ListView لجعل الصفحة Responsive
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 3. إضافة الـ Header Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.document_scanner_rounded,
                          size: 70,
                          color: Color(0xff2563EB),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Scan or Import",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Capture a new document or select one from your gallery.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 4. كارت التقاط صورة (Take Photo)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: captureImage,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Color(0xff2563EB),
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Take Photo",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Use your camera to scan a document",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 4. كارت اختيار من المعرض (Gallery)
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: pickFromGallery,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.green.shade50,
                            child: const Icon(
                              Icons.photo_library_rounded,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Choose From Gallery",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Import an existing photo",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}