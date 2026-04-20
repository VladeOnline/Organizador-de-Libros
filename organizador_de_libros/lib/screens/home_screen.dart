import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../widgets/book_form_dialog.dart';
import '../widgets/book_tile.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBooks());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final books = context.watch<BookProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizador Personal de Libros'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null)
              Text(
                'Bienvenido, ${user.nombre}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Buscar por título o autor',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _loadBooks(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _loadBooks,
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (books.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (books.books.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aún no tienes libros. Agrega uno con el botón +',
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: books.books.length,
                    itemBuilder: (_, index) {
                      final book = books.books[index];
                      return BookTile(
                        book: book,
                        onEdit: () => _openEditDialog(book),
                        onDelete: () => _deleteBook(book),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _loadBooks() async {
    final auth = context.read<AuthProvider>();
    final token = auth.token;
    if (token == null) return;

    try {
      await context.read<BookProvider>().loadBooks(
        token: token,
        search: _searchCtrl.text.trim(),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openCreateDialog() async {
    final form = await showDialog<BookFormData>(
      context: context,
      builder: (_) => const BookFormDialog(),
    );
    if (form == null) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      await context.read<BookProvider>().createBook(
        token: token,
        titulo: form.titulo,
        autor: form.autor,
        genero: form.genero,
        descripcion: form.descripcion,
        estadoLectura: form.estadoLectura,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openEditDialog(Book book) async {
    final form = await showDialog<BookFormData>(
      context: context,
      builder: (_) => BookFormDialog(initialBook: book),
    );
    if (form == null) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      await context.read<BookProvider>().updateBook(
        token: token,
        bookId: book.id,
        titulo: form.titulo,
        autor: form.autor,
        genero: form.genero,
        descripcion: form.descripcion,
        estadoLectura: form.estadoLectura,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _deleteBook(Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar libro'),
        content: Text('¿Seguro que deseas eliminar "${book.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      await context.read<BookProvider>().deleteBook(
        token: token,
        bookId: book.id,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
