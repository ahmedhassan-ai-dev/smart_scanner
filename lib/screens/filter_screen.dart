import 'package:flutter/material.dart';

import 'package:smart_scenner/shared/models/scan_response.dart';
import 'package:smart_scenner/shared/widgets/filter_card.dart';
import 'package:smart_scenner/screens/pdf_screen.dart';
import 'package:smart_scenner/screens/home_screen.dart';

import '../shared/document_manager.dart';
import '../shared/models/document_page.dart';

class FilterScreen extends StatefulWidget {
  final ScanResponse scanResponse;

  const FilterScreen({super.key, required this.scanResponse});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedFilter = '';
  bool pageSaved = false;
  bool useCropped = true;

  static const baseUrl = 'http://192.168.1.106:8000';

  @override
  void initState() {
    super.initState();

    final croppedFilters = widget.scanResponse.images['cropped']['filters']
        as Map<String, dynamic>;

    selectedFilter = croppedFilters.keys.first;
  }

  void saveCurrentPage() {
    if (pageSaved) return;

    DocumentManager.globalFilter = selectedFilter;
    DocumentManager.globalUseCropped = useCropped;

    DocumentManager.addPage(
      DocumentPage(
        scanResponse: widget.scanResponse,
        selectedFilter: selectedFilter,
        useCropped: useCropped,
      ),
    );

    pageSaved = true;
  }

  @override
  Widget build(BuildContext context) {
    final imageSet = useCropped
        ? widget.scanResponse.images['cropped']
        : widget.scanResponse.images['original'];

    final filters = Map<String, dynamic>.from(imageSet['filters']);
    final recommended = widget.scanResponse.recommendedFilter;
    final filterEntries = filters.entries.toList();

    filterEntries.sort((a, b) {
      if (a.key == recommended) return -1;
      if (b.key == recommended) return 1;
      return 0;
    });

    return Scaffold(
      // 1- تعديل الـ AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Choose Filter",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // 2- تبديل CheckboxListTile بـ Card أنيق لـ Auto Crop
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.crop,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Auto Crop",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          useCropped
                              ? "Using Cropped Image"
                              : "Using Original Image",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: useCropped,
                    onChanged: (v) {
                      setState(() {
                        useCropped = v;
                      });
                    },
                  )
                ],
              ),
            ),
          ),

          // 3 & 8- وضع صورة المعاينة داخل Card مع إضافة AnimatedSwitcher
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(22),
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Image.network(
                    "$baseUrl${filters[selectedFilter]}",
                    key: ValueKey(selectedFilter),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // 4- إضافة عنوان الفلاتر
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 10,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Filters",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterEntries.length,
              itemBuilder: (context, index) {
                final filterName = filterEntries[index].key;
                final imageUrl = filterEntries[index].value;
                final isRecommended = filterName == recommended;

                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      // 5- تغيير لون الإطار للون الأزرق ليتناسق مع التطبيق
                      color: isRecommended ? Colors.blue : Colors.transparent,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filterName;
                      });
                    },
                    child: Stack(
                      children: [
                        FilterCard(
                          filterName: filterName,
                          imageUrl: "$baseUrl$imageUrl",
                          selected: selectedFilter == filterName,
                        ),
                        if (isRecommended)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                // 5- تغيير لون الـ Badge للأزرق
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "BEST",
                                style: TextStyle(
                                  // 5- تغيير لون الخط للأبيض
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 6 & 7- تعديل الأزرار واستخدام SafeArea للـ Padding السفلي
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        saveCurrentPage();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Page"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        saveCurrentPage();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfScreen(
                              pageId: widget.scanResponse.pageId,
                              filterName: selectedFilter,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Generate PDF"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}