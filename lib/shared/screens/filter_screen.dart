import 'package:flutter/material.dart';

import '../models/scan_response.dart';
import '../widgets/filter_card.dart';
import '../document_manager.dart';
import '../models/document_page.dart';
import 'reorder_pages_screen.dart';
import '../../screens/home_screen.dart';

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
    selectedFilter = widget.scanResponse.images.keys.first;
  }

  void saveCurrentPage() {
    if (pageSaved) return;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Filter")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "$baseUrl${widget.scanResponse.images[selectedFilter]}",
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          Container(
            height: 150,
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.scanResponse.images.length,
              itemBuilder: (context, index) {
                final filterName = widget.scanResponse.images.keys.elementAt(
                  index,
                );

                final imageUrl =
                    "$baseUrl${widget.scanResponse.images[filterName]}";

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filterName;
                    });
                  },
                  child: FilterCard(
                    filterName: filterName,
                    imageUrl: imageUrl,
                    selected: selectedFilter == filterName,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedFilter);
                    },
                    child: const Text("Apply Filter"),
                  ),
                ),

                const SizedBox(height: 10),

                // زر Add Another Page
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      saveCurrentPage();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    child: const Text("Add Another Page"),
                  ),
                ),

                const SizedBox(height: 10),

                // زر Generate PDF (بعد التعديل)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      saveCurrentPage();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReorderPagesScreen(),
                        ),
                      );
                    },
                    child: const Text("Generate PDF"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}