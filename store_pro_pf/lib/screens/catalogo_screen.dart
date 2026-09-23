import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import 'nuevo_producto_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final ProductoService _productoService = ProductoService();

  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    _futureProductos = _productoService.getProductos();
  }

  Future<void> _nuevoProducto() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NuevoProductoScreen(),
      ),
    );

    if (resultado == true && mounted) {
      setState(() {
        _cargarProductos();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        backgroundColor: const Color.fromARGB(255, 16, 150, 121),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar productos: ${snapshot.error}',
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }

          final productos = snapshot.data!;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final prod = productos[index];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.shopping_bag),
                ),
                title: Text(prod.nombre),
                subtitle: Text(
                  '${prod.categoria} - \$${prod.precio.toStringAsFixed(2)}',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevoProducto,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }
}
