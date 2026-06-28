import 'package:dio/dio.dart';

import 'package:smart_scenner/core/api/api_client.dart';
import 'package:smart_scenner/shared/models/scan_response.dart';

class ScannerService {
  Future<ScanResponse> uploadImage(String imagePath) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imagePath, filename: "scan.jpg"),
    });

    final response = await ApiClient.dio.post("/scan/upload", data: formData);

    return ScanResponse.fromJson(response.data);
  }
}
