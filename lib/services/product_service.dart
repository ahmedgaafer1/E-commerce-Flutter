import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://ib.jamalmoallart.com/api/v1/all/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      return productList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
static Future<List<Product>> fetchProductsByCategory(String category) async {
  final response = await http.get(
    Uri.parse('https://ib.jamalmoallart.com/api/v1/products/category/$category'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load category products");
  }
}



}
