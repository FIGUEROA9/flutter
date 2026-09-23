import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'productos_screen.dart';
import 'categorias_screen.dart';
import 'catalogo_screen.dart';
import 'nuevo_producto_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
  late Future<Usuario?> _futureUsuario;

  @override
  void initState() {
    super.initState();
    _futureUsuario = _authService.getPerfil();
  }

  void _cerrarSesion() async {
    await _authService.logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _abrirPantalla(Widget pantalla) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'StorePro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      drawer: FutureBuilder<Usuario?>(
        future: _futureUsuario,
        builder: (context, snapshot) {
          final usuario = snapshot.data;

          return Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      usuario != null && usuario.nombre.isNotEmpty
                          ? usuario.nombre[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  accountName: Text(
                    usuario?.nombre ?? 'Usuario',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    usuario?.email ?? '',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Mi perfil'),
                  selected: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: const Text('Productos'),
                  onTap: () {
                    Navigator.pop(context);
                    _abrirPantalla(const ProductosScreen());
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categorías'),
                  onTap: () {
                    Navigator.pop(context);
                    _abrirPantalla(const CategoriasScreen());
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.storefront),
                  title: const Text('Catálogo'),
                  onTap: () {
                    Navigator.pop(context);
                    _abrirPantalla(const CatalogoScreen());
                  },
                ),

                if (usuario?.role == 'admin')
                  ListTile(
                    leading: const Icon(Icons.add_box),
                    title: const Text('Nuevo producto'),
                    onTap: () {
                      Navigator.pop(context);
                      _abrirPantalla(const NuevoProductoScreen());
                    },
                  ),

                const Spacer(),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: _cerrarSesion,
                ),

                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),

      body: FutureBuilder<Usuario?>(
        future: _futureUsuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data == null) {
            return const Center(
              child: Text(
                'Error al cargar los datos del usuario',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final usuario = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                ),

                const SizedBox(height: 6),

                Text(
                  usuario.nombre,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.indigo,
                        Color(0xFF3949AB),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Text(
                          usuario.nombre.isNotEmpty
                              ? usuario.nombre[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              usuario.nombre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              usuario.email,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                usuario.role.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Accesos rápidos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _tarjetaMenu(
                        icono: Icons.inventory_2,
                        titulo: 'Productos',
                        color: Colors.blue,
                        onTap: () {
                          _abrirPantalla(const ProductosScreen());
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _tarjetaMenu(
                        icono: Icons.category,
                        titulo: 'Categorías',
                        color: Colors.orange,
                        onTap: () {
                          _abrirPantalla(const CategoriasScreen());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _tarjetaMenu(
                        icono: Icons.storefront,
                        titulo: 'Catálogo',
                        color: Colors.green,
                        onTap: () {
                          _abrirPantalla(const CatalogoScreen());
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _tarjetaMenu(
                        icono: Icons.add_box,
                        titulo: 'Nuevo producto',
                        color: Colors.purple,
                        onTap: usuario.role == 'admin'
                            ? () {
                                _abrirPantalla(
                                  const NuevoProductoScreen(),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.security,
                          color: Colors.indigo,
                          size: 32,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sesión segura',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tu sesión está protegida mediante autenticación JWT.',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _tarjetaMenu({
    required IconData icono,
    required String titulo,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 12,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  icono,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}