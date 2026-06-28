class Recommendation {
  final String filter;
  final double confidence;

  Recommendation({
    required this.filter,
    required this.confidence,
  });

  factory Recommendation.fromJson(
    Map<String, dynamic> json,
  ) {
    return Recommendation(
      filter: json['filter'] ?? '',
      confidence:
          (json['confidence'] ?? 0)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'confidence': confidence,
    };
  }
}