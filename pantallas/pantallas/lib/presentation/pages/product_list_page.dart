import 'package:flutter/material.dart';
import 'package:pantallas/core/api/api_service_product.dart';
import 'package:pantallas/services/api_service_product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiServiceProduct api = ApiServiceProduct();
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = api.fetchProducts();
  }

  void refresh() {
    setState(() {
      productsFuture = api.fetchProducts();
    });
  }

  void crearProducto() async {
    final producto =
        Product(id: 'o', name: 'Nuevo Producto', data: {'color': 'Negro'});
    print("Efectivo");
    await api.createProduct(producto);
    refresh();
  }

  void actualizarProducto(String id) async {
    final producto =
        Product(id: id, name: 'Producto Editado', data: {'color': 'Rojo'});
    await api.updateProduct(id, producto);
    refresh();
  }

  void eliminarProducto(String id) async {
    await api.deleteProduct(id);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text(p.data?.toString() ?? 'Sin datos'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => actualizarProducto(p.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearProducto,
        child: const Icon(Icons.add),
      ),
    );
  }
}
