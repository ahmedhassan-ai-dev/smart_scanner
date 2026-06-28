class SavedDocument {
  final String name;
  final String pdfPath;
  final DateTime createdAt;
  final int pageCount;

  SavedDocument({
    required this.name,
    required this.pdfPath,
    required this.createdAt,
    required this.pageCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pdfPath': pdfPath,
      'createdAt': createdAt.toIso8601String(),
      'pageCount': pageCount,
    };
  }

  factory SavedDocument.fromJson(
    Map<dynamic, dynamic> json,
  ) {
    return SavedDocument(
      name: json['name'],
      pdfPath: json['pdfPath'],
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
      pageCount: json['pageCount'],
    );
  }
}