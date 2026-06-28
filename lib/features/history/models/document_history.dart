class DocumentHistory {
  final String fileName;
  final String pdfUrl;
  final String thumbnailUrl;
  final int pagesCount;
  final DateTime createdAt;

  DocumentHistory({
    required this.fileName,
    required this.pdfUrl,
    required this.thumbnailUrl,
    required this.pagesCount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'pdfUrl': pdfUrl,
      'thumbnailUrl': thumbnailUrl,
      'pagesCount': pagesCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DocumentHistory.fromJson(
    Map<dynamic, dynamic> json,
  ) {
    return DocumentHistory(
      fileName: json['fileName'],
      pdfUrl: json['pdfUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      pagesCount: json['pagesCount'],
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
    );
  }
}