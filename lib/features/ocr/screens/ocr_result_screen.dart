import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OCRResultScreen extends StatefulWidget {
  final String text;

  const OCRResultScreen({
    super.key,
    required this.text,
  });

  @override
  State<OCRResultScreen> createState() =>
      _OCRResultScreenState();
}

class _OCRResultScreenState
    extends State<OCRResultScreen> {
  Future<void> copyText() async {
    await Clipboard.setData(
      ClipboardData(text: widget.text),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Text copied"),
      ),
    );
  }

  Future<void> shareText() async {
    await SharePlus.instance.share(
      ShareParams(
        text: widget.text,
      ),
    );
  }

  Future<void> saveAsTxt() async {
    try {
      final dir =
          await getApplicationDocumentsDirectory();

      final file = File(
        "${dir.path}/OCR_${DateTime.now().millisecondsSinceEpoch}.txt",
      );

      await file.writeAsString(widget.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Saved to\n${file.path}",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recognized Text",
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: SingleChildScrollView(
                child: SelectableText(
                  widget.text.isEmpty
                      ? "No text detected"
                      : widget.text,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: copyText,
                    icon: const Icon(Icons.copy),
                    label: const Text("Copy"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: shareText,
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saveAsTxt,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
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