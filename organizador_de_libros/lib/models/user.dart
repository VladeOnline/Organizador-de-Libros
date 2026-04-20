class User {
  final String id;
  final String nombre;
  final String correo;

  const User({
    required this.id,
    required this.nombre,
    required this.correo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
    );
  }
}
