import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider extends ChangeNotifier {
  final BookService _bookService;

  BookProvider([BookService? bookService])
    : _bookService = bookService ?? BookService();

  final List<Book> _books = [];
  bool _isLoading = false;
  String _searchTerm = '';

  List<Book> get books => List.unmodifiable(_books);
  bool get isLoading => _isLoading;
  String get searchTerm => _searchTerm;

  Future<void> loadBooks({
    required String token,
    String search = '',
  }) async {
    _isLoading = true;
    _searchTerm = search;
    notifyListeners();

    final result = await _bookService.listBooks(token: token, search: search);
    _books
      ..clear()
      ..addAll(result);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBook({
    required String token,
    required String titulo,
    required String autor,
    required String genero,
    required String descripcion,
    required String estadoLectura,
  }) async {
    await _bookService.createBook(
      token: token,
      titulo: titulo,
      autor: autor,
      genero: genero,
      descripcion: descripcion,
      estadoLectura: estadoLectura,
    );
    await loadBooks(token: token, search: _searchTerm);
  }

  Future<void> updateBook({
    required String token,
    required String bookId,
    required String titulo,
    required String autor,
    required String genero,
    required String descripcion,
    required String estadoLectura,
  }) async {
    await _bookService.updateBook(
      token: token,
      bookId: bookId,
      titulo: titulo,
      autor: autor,
      genero: genero,
      descripcion: descripcion,
      estadoLectura: estadoLectura,
    );
    await loadBooks(token: token, search: _searchTerm);
  }

  Future<void> deleteBook({
    required String token,
    required String bookId,
  }) async {
    await _bookService.deleteBook(token: token, bookId: bookId);
    await loadBooks(token: token, search: _searchTerm);
  }
}
