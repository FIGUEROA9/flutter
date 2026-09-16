import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Asegúrate de importar tu provider

class RoleGuardWidget extends StatelessWidget {
  final List<String> allowedRoles; // Recomendado tipar también la lista como <String>
  final Widget child;
  final Widget fallback;

  const RoleGuardWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    // ✅ CORRECCIÓN: Especificar explícitamente <AuthProvider>
    final authProvider = Provider.of<AuthProvider>(context);
    
    // O alternativamente usando context.watch (es exactamente lo mismo):
    // final authProvider = context.watch<AuthProvider>();

    final userRole = authProvider.usuario?.role ?? '';

    if (allowedRoles.contains(userRole)) {
      return child;
    }
    
    return fallback;
  }
}