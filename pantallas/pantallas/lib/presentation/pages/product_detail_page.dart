import 'package:flutter/material.dart';
import 'package:pantallas/core/api/api_service_product.dart';
import 'package:pantallas/services/api_service_product.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ApiServiceProduct api = ApiServiceProduct();

  final _formKey = GlobalKey<FormState>();
  late Product product;
  late TextEditingController nameController;
  late TextEditingController dataController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Product;
    product = args;
    nameController = TextEditingController(text: product.name);
    dataController = TextEditingController(
      text: product.data != null ? product.data.toString() : '',
    );
  }

  void guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = Product(
        id: product.id,
        name: nameController.text,
        data: {}, // Aquí puedes mejorar si quieres parsear los datos desde texto
      );

      await api.updateProduct(product.id, updatedProduct);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dataController,
                decoration:
                    const InputDecoration(labelText: 'Data (no editable aún)'),
                readOnly: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: guardarCambios,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
