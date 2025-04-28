import 'package:flutter/material.dart';
import 'package:pantallas/domain/models/product.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  final List<Product> products = [
    Product(
      id: '1',
      name: 'Laptop',
      description: 'Laptop de última generación',
    ),
    Product(
      id: '2',
      name: 'Teléfono',
      description: 'Smartphone con cámara profesional',
    ),
    Product(id: '3', name: 'Tablet', description: 'Tablet con pantalla HD'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.description ?? ''),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-detail',
                arguments: product,
              );
            },
          );
        },
      ),
    );
  }
}
