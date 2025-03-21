import 'dart:convert';
import 'package:http/http.dart' as http;

class SubmenuApi {
  static const String baseUrl =
      "https://api.emaryam.com/WebService.asmx/BindSubMenu";

  Future<List<Map<String, dynamic>>> fetchMenuData(int menuId) async {
    final url = Uri.parse(baseUrl); // Adjust endpoint if needed

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"MenuId": menuId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["d"]["status"] == "success") {
          return List<Map<String, dynamic>>.from(responseData["d"]["data"]);
        } else {
          throw Exception("API Error: ${responseData["d"]["status"]}");
        }
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
