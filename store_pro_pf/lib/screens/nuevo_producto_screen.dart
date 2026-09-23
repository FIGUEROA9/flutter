import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';

class NuevoProductoScreen extends StatefulWidget {
const NuevoProductoScreen({super.key});

@override
State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
final _formKey = GlobalKey<FormState>();

final _nombreCtrl = TextEditingController();
final _precioCtrl = TextEditingController();
final _stockCtrl = TextEditingController();

final ProductoService _productoService = ProductoService();
final CategoriaService _categoriaService = CategoriaService();

late Future<List<Categoria>> _futureCategorias;

int? _categoriaSeleccionada;
bool _guardando = false;

@override
void initState() {
super.initState();
_futureCategorias = _categoriaService.getCategorias();
}

Future<void> _guardar() async {
if (!_formKey.currentState!.validate()) {
return;
}

if (_categoriaSeleccionada == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Selecciona una categoría'),
    ),
  );
  return;
}

setState(() {
  _guardando = true;
});

try {
  final nombre = _nombreCtrl.text.trim();
  final precio = double.parse(_precioCtrl.text.trim());
  final stock = int.parse(_stockCtrl.text.trim());

  final creado = await _productoService.crearProducto(
    nombre,
    precio,
    stock,
    _categoriaSeleccionada!,
  );

  if (!mounted) return;

  if (creado) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto creado correctamente'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo crear el producto'),
        backgroundColor: Colors.red,
      ),
    );
  }
} catch (e) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: $e'),
      backgroundColor: Colors.red,
    ),
  );
} finally {
  if (mounted) {
    setState(() {
      _guardando = false;
    });
  }
}


}

@override
void dispose() {
_nombreCtrl.dispose();
_precioCtrl.dispose();
_stockCtrl.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Nuevo Producto'),
),
body: FutureBuilder<List<Categoria>>(
future: _futureCategorias,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Error al cargar categorías: ${snapshot.error}',
          ),
        );
      }

      final categorias = snapshot.data ?? [];

      if (categorias.isEmpty) {
        return const Center(
          child: Text('No hay categorías disponibles'),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _precioCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }

                  final precio = double.tryParse(value);

                  if (precio == null || precio <= 0) {
                    return 'Ingresa un precio válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El stock es obligatorio';
                  }

                  final stock = int.tryParse(value);

                  if (stock == null || stock < 0) {
                    return 'Ingresa un stock válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: categorias
                    .where((categoria) => categoria.estado)
                    .map(
                      (categoria) => DropdownMenuItem<int>(
                        value: categoria.id,
                        child: Text(categoria.nombre),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const CircularProgressIndicator()
                      : const Text('GUARDAR PRODUCTO'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);


}
}