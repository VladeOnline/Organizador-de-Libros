# BookManager - Organizador de Libros

Aplicacion web con autenticacion y CRUD completo de libros usando Node.js, Express y MongoDB Atlas.

## Funcionalidades

- Registro de usuario
- Inicio y cierre de sesion
- Rutas privadas protegidas
- Crear, listar, ver detalle, editar y eliminar libros
- Busqueda por titulo o autor
- Relacion de libros por usuario (`userId`)
- Validaciones basicas de formularios

## Tecnologias

- Node.js
- Express
- EJS
- MongoDB Atlas con Mongoose
- JWT en cookie HTTP-only

## Configuracion

1. Instalar dependencias:

```bash
npm install
```

2. Crear archivo `.env` basado en `.env.example`:

```env
PORT=3000
MONGODB_URI=mongodb+srv://<usuario>:<password>@<cluster>.mongodb.net/organizador_de_libros?retryWrites=true&w=majority
JWT_SECRET=coloca_un_secreto_largo_y_seguro
```

3. Ejecutar en desarrollo:

```bash
npm run dev
```

4. Abrir en navegador:

```text
http://localhost:3000
```

## Estructura

- `src/models`: modelos `User` y `Book`
- `src/controllers`: logica de autenticacion y libros
- `src/routes`: rutas del sistema
- `src/middlewares`: middleware de autenticacion
- `src/views`: interfaz web
- `public/css`: estilos

## Nota sobre Mongo Atlas

Tu URI actual apunta a la base `Sistema-Educativo`. Para este proyecto usa otra base, por ejemplo `organizador_de_libros`, reemplazando solo el nombre de base al final de la URI.
