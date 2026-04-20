# Organizador Personal de Libros

Aplicación web con `Flutter Web` + `API Node/Express` + `MongoDB Atlas`.

## Alcance implementado

- Registro de usuario
- Inicio/cierre de sesión
- CRUD de libros
- Búsqueda por título o autor
- Aislamiento por usuario (`userId`): cada usuario solo ve sus propios libros
- Validaciones básicas de formularios y backend

## Estructura del repositorio

- `organizador_de_libros/` → frontend Flutter Web
- `backend/` → API REST (Express + MongoDB)

## Ramas sugeridas de trabajo

Ramas remotas disponibles:
- `feature/autenticacion`
- `feature/base-datos`
- `feature/crud-libros`
- `feature/busqueda-libros`
- `feature/interfaz-web`
- `feature/validaciones`
- `develop`

Rama de integración creada para este avance:
- `mvp-fullstack`

Sugerencia de flujo:
1. Trabajar por módulo en ramas feature.
2. Integrar en `develop`.
3. Pasar a `main` cuando esté estable.

## Backend (Node + MongoDB Atlas)

1. Ir a `backend/`
2. Instalar dependencias: `npm install`
3. Copiar `.env.example` a `.env`
4. Configurar variables:
   - `MONGODB_URI`
   - `JWT_SECRET`
   - `CORS_ORIGIN`
5. Ejecutar:
   - desarrollo: `npm run dev`
   - producción local: `npm start`

API base: `http://localhost:4000/api`

## Frontend (Flutter Web)

1. Ir a `organizador_de_libros/`
2. Instalar paquetes: `flutter pub get`
3. Ejecutar web: `flutter run -d chrome`

Por defecto consume: `http://localhost:4000/api` (configurable en `lib/core/constants.dart`).

## Requerimientos funcionales cubiertos

- RF-01 a RF-10: cubiertos en esta versión MVP.

## Requerimientos no funcionales cubiertos

- RNF-01 a RNF-06: cubiertos con una arquitectura modular simple y autenticación JWT.
