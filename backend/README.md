# Backend API - Organizador de Libros

## Tecnologías

- Node.js
- Express
- MongoDB Atlas (Mongoose)
- JWT

## Configuración

1. Instala dependencias:
```bash
npm install
```

2. Crea `.env` desde `.env.example`:
```env
PORT=4000
MONGODB_URI=...
JWT_SECRET=...
CORS_ORIGIN=http://localhost:3000
```

3. Inicia servidor:
```bash
npm run dev
```

## Endpoints

Base URL: `http://localhost:4000/api`

### Auth
- `POST /auth/register`
- `POST /auth/login`

### Books (requieren `Authorization: Bearer <token>`)
- `GET /books?search=texto`
- `POST /books`
- `PUT /books/:id`
- `DELETE /books/:id`

## Notas

- `estadoLectura` permitido: `Pendiente`, `Leyendo`, `Terminado`.
- Todas las operaciones de libros están filtradas por el `userId` autenticado.
