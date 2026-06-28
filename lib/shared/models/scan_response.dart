
class ScanResponse {
  final String pageId;

  final Map<String, dynamic> images;

  final Map<String, dynamic> metrics;

  final String recommendedFilter;

  final double confidence;

  ScanResponse({
    required this.pageId,
    required this.images,
    required this.metrics,
    required this.recommendedFilter,
    required this.confidence,
  });

  factory ScanResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanResponse(
      pageId: json['page_id'] ?? '',

      images: Map<String, dynamic>.from(
        json['images'] ?? {},
      ),

      metrics: Map<String, dynamic>.from(
        json['metrics'] ?? {},
      ),

      recommendedFilter:
          json['recommended_filter'] ?? '',

      confidence:
          (json['confidence'] ?? 0)
              .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_id': pageId,
      'images': images,
      'metrics': metrics,
      'recommended_filter':
          recommendedFilter,
      'confidence': confidence,
    };
  }
}