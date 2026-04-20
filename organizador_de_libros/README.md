# Frontend Flutter Web - Organizador de Libros

## Ejecutar

```bash
flutter pub get
flutter run -d chrome
```

## Configuración de API

Editar `lib/core/constants.dart`:

```dart
static const String baseUrl = 'http://localhost:4000/api';
```

## Pantallas

- Login
- Registro
- Home/Dashboard con:
  - Lista de libros
  - Búsqueda por título o autor
  - Crear libro
  - Editar libro
  - Eliminar libro

## Validaciones

- Campos obligatorios en auth y libros
- Contraseña mínima de 6 caracteres
- Validación básica de correo
