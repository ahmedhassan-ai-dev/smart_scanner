import 'scan_response.dart';

class DocumentPage {
  final ScanResponse scanResponse;

  String selectedFilter;

  bool useCropped;

  DocumentPage({
    required this.scanResponse,
    required this.selectedFilter,
    required this.useCropped,
  });
}