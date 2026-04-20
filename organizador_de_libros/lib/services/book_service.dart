import '../models/book.dart';
import 'api_client.dart';

class BookService {
  final ApiClient _apiClient;

  BookService([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  Future<List<Book>> listBooks({
    required String token,
    String search = '',
  }) async {
    final query = search.trim().isEmpty ? '' : '?search=${Uri.encodeQueryComponent(search)}';
    final data = await _apiClient.getList('/books$query', token: token);
    return data
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList();
  }

  Future<Book> createBook({
    required String token,
    required String titulo,
    required String autor,
    required String genero,
    required String descripcion,
    required String estadoLectura,
  }) async {
    final data = await _apiClient.post(
      '/books',
      token: token,
      body: {
        'titulo': titulo,
        'autor': autor,
        'genero': genero,
        'descripcion': descripcion,
        'estadoLectura': estadoLectura,
      },
    );
    return Book.fromJson(data);
  }

  Future<Book> updateBook({
    required String token,
    required String bookId,
    required String titulo,
    required String autor,
    required String genero,
    required String descripcion,
    required String estadoLectura,
  }) async {
    final data = await _apiClient.put(
      '/books/$bookId',
      token: token,
      body: {
        'titulo': titulo,
        'autor': autor,
        'genero': genero,
        'descripcion': descripcion,
        'estadoLectura': estadoLectura,
      },
    );
    return Book.fromJson(data);
  }

  Future<void> deleteBook({
    required String token,
    required String bookId,
  }) async {
    await _apiClient.delete('/books/$bookId', token: token);
  }
}
