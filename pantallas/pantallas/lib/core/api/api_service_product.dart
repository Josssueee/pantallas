import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  Product({
    required this.id,
    required this.name,
    this.data,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}

class ApiServiceProduct {
  final String baseUrl = 'https://api.restful-api.dev/objects';

  /// Obtener todos los productos
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar productos: ${response.statusCode}');
    }
  }

  /// Insertar nuevo producto (POST)
  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear producto: ${response.statusCode}');
    }
  }

  /// Modificar producto existente (PUT)
  Future<Product> updateProduct(String id, Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar producto: ${response.statusCode}');
    }
  }

  /// Eliminar producto (DELETE)
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto: ${response.statusCode}');
    }
  }
}
