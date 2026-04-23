import 'dart:math' as math;

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBooks());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final books = context.watch<BookProvider>();
    final userName = _displayName(auth.user?.nombre, auth.user?.correo);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Mi Biblioteca Personal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 20),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 130,
                    child: Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesion',
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          _AnimatedBackground(controller: _bgController),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 96, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu coleccion de libros',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Gestiona, busca y organiza tus lecturas',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Buscar por titulo o autor',
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
                            'Aun no tienes libros. Agrega uno con el boton +',
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _displayName(String? nombre, String? correo) {
    final normalizedName = (nombre ?? '').trim();
    if (normalizedName.isNotEmpty) {
      return normalizedName;
    }

    final email = (correo ?? '').trim();
    if (email.contains('@')) {
      return email.split('@').first;
    }

    return 'Usuario';
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
        content: Text('Seguro que deseas eliminar "${book.titulo}"?'),
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

class _AnimatedBackground extends StatelessWidget {
  final Animation<double> controller;

  const _AnimatedBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value * 2 * math.pi;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDCE9FF), Color(0xFFF5F9FF), Color(0xFFEAF2FF)],
            ),
          ),
          child: Stack(
            children: [
              _Bubble(
                diameter: 260,
                left: -50 + math.sin(t) * 24,
                top: -70 + math.cos(t * 0.8) * 18,
                color: const Color(0xFF7CA6FF).withOpacity(0.18),
              ),
              _Bubble(
                diameter: 210,
                right: -40 + math.cos(t * 1.2) * 20,
                top: 90 + math.sin(t) * 22,
                color: const Color(0xFF4E79D9).withOpacity(0.16),
              ),
              _Bubble(
                diameter: 300,
                right: -120 + math.sin(t * 0.9) * 26,
                bottom: -120 + math.cos(t) * 20,
                color: const Color(0xFF95B6FF).withOpacity(0.16),
              ),
              _Bubble(
                diameter: 120,
                left: 180 + math.cos(t * 1.6) * 22,
                top: 60 + math.sin(t * 1.1) * 18,
                color: const Color(0xFF5A86E8).withOpacity(0.12),
              ),
              _Bubble(
                diameter: 160,
                left: 420 + math.sin(t * 1.3) * 20,
                top: 240 + math.cos(t * 0.9) * 18,
                color: const Color(0xFF7EA4F7).withOpacity(0.11),
              ),
              _Bubble(
                diameter: 100,
                right: 300 + math.cos(t * 1.4) * 18,
                top: -20 + math.sin(t * 1.2) * 16,
                color: const Color(0xFF4E79D9).withOpacity(0.12),
              ),
              _Bubble(
                diameter: 140,
                right: 200 + math.sin(t * 1.7) * 20,
                bottom: 100 + math.cos(t * 1.05) * 20,
                color: const Color(0xFF89AFFF).withOpacity(0.13),
              ),
              _Bubble(
                diameter: 90,
                left: 60 + math.cos(t * 1.9) * 16,
                bottom: 130 + math.sin(t * 1.3) * 14,
                color: const Color(0xFF4C76D4).withOpacity(0.10),
              ),
              _Bubble(
                diameter: 190,
                right: -70 + math.sin(t * 0.7) * 18,
                top: 320 + math.cos(t * 1.1) * 18,
                color: const Color(0xFFA3C0FF).withOpacity(0.12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final double diameter;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Color color;

  const _Bubble({
    required this.diameter,
    required this.color,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
