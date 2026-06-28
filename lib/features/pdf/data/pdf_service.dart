import 'package:dio/dio.dart';

import '../../../shared/document_manager.dart';

class PdfService {
  final Dio dio = Dio();

  static const String baseUrl =
      'http://192.168.1.106:8000';

  Future<String> generatePdf() async {
    final pages = DocumentManager.pages.map((page) {
      return {
        "page_id": page.scanResponse.pageId,
        "filter_name": page.selectedFilter,
        "variant":
            page.useCropped
                ? "cropped"
                : "original",
      };
    }).toList();

    final body = {
      "use_single_filter":
          DocumentManager.useSingleFilter,

      "filter_name":
          DocumentManager.globalFilter,

      "variant":
          DocumentManager.globalUseCropped
              ? "cropped"
              : "original",

      "pages": pages,
    };

    final response = await dio.post(
      '$baseUrl/scan/pdf',
      data: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to generate PDF',
      );
    }

    final pdfUrl =
        response.data['pdf_url'];

    if (pdfUrl == null) {
      throw Exception(
        'pdf_url not found in response',
      );
    }

    return '$baseUrl$pdfUrl';
  }
}