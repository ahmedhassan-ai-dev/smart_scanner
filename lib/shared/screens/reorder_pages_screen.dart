import 'package:flutter/material.dart';

import '../document_manager.dart';
import '../../screens/pdf_screen.dart';

class ReorderPagesScreen extends StatefulWidget {
  const ReorderPagesScreen({super.key});

  @override
  State<ReorderPagesScreen> createState() => _ReorderPagesScreenState();
}

class _ReorderPagesScreenState extends State<ReorderPagesScreen> {
  static const baseUrl = 'http://192.168.1.106:8000';



  @override
void initState() {
  super.initState();

  debugPrint(
    'Pages Count = ${DocumentManager.pages.length}',
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder Pages')),

      body: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              itemCount: DocumentManager.pages.length,

              onReorder: (oldIndex, newIndex) {
                setState(() {
                  DocumentManager.reorder(oldIndex, newIndex);
                });
              },

              itemBuilder: (context, index) {
                final page = DocumentManager.pages[index];

                final imageUrl = page.scanResponse.images[page.selectedFilter];

                return Card(
                  key: ValueKey(page.scanResponse.pageId),

                  child: ListTile(
                    leading: Image.network(
                      '$baseUrl$imageUrl',
                      width: 60,
                      fit: BoxFit.cover,
                    ),

                    title: Text('Page ${index + 1}'),

                    subtitle: Text(page.selectedFilter),

                    trailing: const Icon(Icons.drag_handle),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PdfScreen(pageId: '', filterName: ''),
                    ),
                  );
                },

                child: const Text('Continue To PDF'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
