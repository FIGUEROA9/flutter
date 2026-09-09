class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final bool estado;

  Categoria({required this.id, required this.nombre, required this.descripcion, required this.estado});

  factory Categoria.fromJson(Map json) => Categoria(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'] ?? '',
    estado: json['estado'] ?? true,
  );

  Map toJson() => {'nombre': nombre, 'descripcion': descripcion, 'estado': estado};
}
                    