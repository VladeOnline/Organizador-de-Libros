class Book {
  final String id;
  final String titulo;
  final String autor;
  final String genero;
  final String descripcion;
  final String estadoLectura;
  final String userId;

  const Book({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.descripcion,
    required this.estadoLectura,
    required this.userId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: (json['_id'] ?? json['id']) as String,
      titulo: json['titulo'] as String,
      autor: json['autor'] as String,
      genero: json['genero'] as String,
      descripcion: (json['descripcion'] ?? '') as String,
      estadoLectura: json['estadoLectura'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'descripcion': descripcion,
      'estadoLectura': estadoLectura,
    };
  }

  Book copyWith({
    String? titulo,
    String? autor,
    String? genero,
    String? descripcion,
    String? estadoLectura,
  }) {
    return Book(
      id: id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      genero: genero ?? this.genero,
      descripcion: descripcion ?? this.descripcion,
      estadoLectura: estadoLectura ?? this.estadoLectura,
      userId: userId,
    );
  }
}
