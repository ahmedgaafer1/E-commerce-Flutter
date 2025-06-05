import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static Future<List<String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://ib.jamalmoallart.com/api/v1/all/categories'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
