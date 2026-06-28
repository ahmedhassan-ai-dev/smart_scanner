import 'package:hive_flutter/hive_flutter.dart';

import '../models/document_history.dart';

class HistoryService {
  static const String boxName = 'documents_history';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static Box get box => Hive.box(boxName);

  static Future<void> addDocument(
    DocumentHistory document,
  ) async {
    await box.add(
      document.toJson(),
    );
  }

  static List<DocumentHistory> getDocuments() {
    return box.values
        .map(
          (e) => DocumentHistory.fromJson(e),
        )
        .toList();
  }

  static Future<void> updateDocument(
    int index,
    DocumentHistory document,
  ) async {
    await box.putAt(
      index,
      document.toJson(),
    );
  }

  static Future<void> deleteDocument(
    int index,
  ) async {
    await box.deleteAt(index);
  }

  static Future<void> clearHistory() async {
    await box.clear();
  }
}