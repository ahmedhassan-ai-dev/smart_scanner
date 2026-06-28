class SavedDocument {
  final String name;
  final String localPath;
  final DateTime createdAt;

  SavedDocument({
    required this.name,
    required this.localPath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'localPath': localPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SavedDocument.fromJson(
    Map<String, dynamic> json,
  ) {
    return SavedDocument(
      name: json['name'],
      localPath: json['localPath'],
      createdAt: DateTime.parse(
        json['createdAt'],
      ),
    );
  }
}