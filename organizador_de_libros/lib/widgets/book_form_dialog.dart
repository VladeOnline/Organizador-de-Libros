import 'package:flutter/material.dart';

import '../models/book.dart';

const readingStates = ['Pendiente', 'Leyendo', 'Terminado'];

class BookFormData {
  final String titulo;
  final String autor;
  final String genero;
  final String descripcion;
  final String estadoLectura;

  const BookFormData({
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.descripcion,
    required this.estadoLectura,
  });
}

class BookFormDialog extends StatefulWidget {
  final Book? initialBook;

  const BookFormDialog({
    super.key,
    this.initialBook,
  });

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _autorCtrl;
  late final TextEditingController _generoCtrl;
  late final TextEditingController _descripcionCtrl;
  late String _estado;

  @override
  void initState() {
    super.initState();
    final book = widget.initialBook;
    _tituloCtrl = TextEditingController(text: book?.titulo ?? '');
    _autorCtrl = TextEditingController(text: book?.autor ?? '');
    _generoCtrl = TextEditingController(text: book?.genero ?? '');
    _descripcionCtrl = TextEditingController(text: book?.descripcion ?? '');
    _estado = book?.estadoLectura ?? readingStates.first;
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _autorCtrl.dispose();
    _generoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialBook == null ? 'Agregar libro' : 'Editar libro'),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tituloCtrl,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: _requiredValidator,
                ),
                TextFormField(
                  controller: _autorCtrl,
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: _requiredValidator,
                ),
                TextFormField(
                  controller: _generoCtrl,
                  decoration: const InputDecoration(labelText: 'Género'),
                  validator: _requiredValidator,
                ),
                TextFormField(
                  controller: _descripcionCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _estado,
                  items: readingStates
                      .map(
                        (state) =>
                            DropdownMenuItem(value: state, child: Text(state)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _estado = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Estado de lectura'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.pop(
              context,
              BookFormData(
                titulo: _tituloCtrl.text.trim(),
                autor: _autorCtrl.text.trim(),
                genero: _generoCtrl.text.trim(),
                descripcion: _descripcionCtrl.text.trim(),
                estadoLectura: _estado,
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }
}
