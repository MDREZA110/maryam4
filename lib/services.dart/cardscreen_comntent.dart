import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://xyz.aa"; // Replace with actual API

  Future<List<String>> fetchCoverPageImages() async {
    try {
      final response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Extract "CoverPageFullImage" from each item
        List<String> images =
            data.map((item) => item["CoverPageFullImage"] as String).toList();

        return images;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
