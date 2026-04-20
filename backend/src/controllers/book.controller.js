const { Book, validStates } = require("../models/Book");

const validateBookPayload = (payload) => {
  const { titulo, autor, genero, estadoLectura } = payload;

  if (!titulo || !autor || !genero) {
    return "Título, autor y género son obligatorios";
  }

  if (estadoLectura && !validStates.includes(estadoLectura)) {
    return "Estado de lectura inválido";
  }

  return null;
};

const listBooks = async (req, res) => {
  const search = (req.query.search || "").trim();
  const baseFilter = { userId: req.auth.userId };

  const filter =
    search.length > 0
      ? {
          ...baseFilter,
          $or: [
            { titulo: { $regex: search, $options: "i" } },
            { autor: { $regex: search, $options: "i" } },
          ],
        }
      : baseFilter;

  const books = await Book.find(filter).sort({ createdAt: -1 });
  return res.json(books);
};

const createBook = async (req, res) => {
  const error = validateBookPayload(req.body);
  if (error) {
    return res.status(400).json({ message: error });
  }

  const newBook = await Book.create({
    titulo: req.body.titulo.trim(),
    autor: req.body.autor.trim(),
    genero: req.body.genero.trim(),
    descripcion: (req.body.descripcion || "").trim(),
    estadoLectura: req.body.estadoLectura || "Pendiente",
    userId: req.auth.userId,
  });

  return res.status(201).json(newBook);
};

const updateBook = async (req, res) => {
  const error = validateBookPayload(req.body);
  if (error) {
    return res.status(400).json({ message: error });
  }

  const updated = await Book.findOneAndUpdate(
    {
      _id: req.params.id,
      userId: req.auth.userId,
    },
    {
      titulo: req.body.titulo.trim(),
      autor: req.body.autor.trim(),
      genero: req.body.genero.trim(),
      descripcion: (req.body.descripcion || "").trim(),
      estadoLectura: req.body.estadoLectura || "Pendiente",
    },
    { new: true }
  );

  if (!updated) {
    return res.status(404).json({ message: "Libro no encontrado" });
  }

  return res.json(updated);
};

const deleteBook = async (req, res) => {
  const deleted = await Book.findOneAndDelete({
    _id: req.params.id,
    userId: req.auth.userId,
  });

  if (!deleted) {
    return res.status(404).json({ message: "Libro no encontrado" });
  }

  return res.json({ message: "Libro eliminado correctamente" });
};

module.exports = {
  listBooks,
  createBook,
  updateBook,
  deleteBook,
};
