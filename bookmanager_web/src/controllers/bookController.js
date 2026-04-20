const mongoose = require('mongoose');
const { Book, READING_STATUS } = require('../models/Book');
const { validateBook } = require('../utils/validators');

function baseFormValues() {
  return {
    title: '',
    author: '',
    genre: '',
    description: '',
    publishDate: '',
    readingStatus: 'Pendiente',
  };
}

function toDateInputValue(dateValue) {
  if (!dateValue) return '';
  return new Date(dateValue).toISOString().split('T')[0];
}

async function renderDashboard(req, res) {
  const booksCount = await Book.countDocuments({ userId: req.user.id });
  return res.render('books/dashboard', {
    title: 'Dashboard',
    booksCount,
  });
}

async function listBooks(req, res) {
  const { q = '' } = req.query;
  const query = {
    userId: req.user.id,
  };

  if (q.trim()) {
    query.$or = [
      { title: { $regex: q.trim(), $options: 'i' } },
      { author: { $regex: q.trim(), $options: 'i' } },
    ];
  }

  const books = await Book.find(query).sort({ createdAt: -1 });

  return res.render('books/list', {
    title: 'Mis libros',
    books,
    search: q,
  });
}

function renderCreateForm(req, res) {
  return res.render('books/create', {
    title: 'Agregar libro',
    errors: [],
    form: baseFormValues(),
    statuses: READING_STATUS,
  });
}

async function createBook(req, res) {
  const form = {
    title: req.body.title || '',
    author: req.body.author || '',
    genre: req.body.genre || '',
    description: req.body.description || '',
    publishDate: req.body.publishDate || '',
    readingStatus: req.body.readingStatus || 'Pendiente',
  };

  const errors = validateBook(form);

  if (errors.length > 0) {
    return res.status(400).render('books/create', {
      title: 'Agregar libro',
      errors,
      form,
      statuses: READING_STATUS,
    });
  }

  await Book.create({
    ...form,
    userId: req.user.id,
    publishDate: form.publishDate ? new Date(form.publishDate) : null,
  });

  return res.redirect('/libros');
}

async function viewBook(req, res) {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).send('Libro no encontrado');
  }

  const book = await Book.findOne({ _id: id, userId: req.user.id });

  if (!book) {
    return res.status(404).send('Libro no encontrado');
  }

  return res.render('books/detail', {
    title: 'Detalle del libro',
    book,
  });
}

async function renderEditForm(req, res) {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).send('Libro no encontrado');
  }

  const book = await Book.findOne({ _id: id, userId: req.user.id });

  if (!book) {
    return res.status(404).send('Libro no encontrado');
  }

  return res.render('books/edit', {
    title: 'Editar libro',
    errors: [],
    statuses: READING_STATUS,
    form: {
      title: book.title,
      author: book.author,
      genre: book.genre,
      description: book.description,
      publishDate: toDateInputValue(book.publishDate),
      readingStatus: book.readingStatus,
    },
    bookId: book._id,
  });
}

async function updateBook(req, res) {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).send('Libro no encontrado');
  }

  const form = {
    title: req.body.title || '',
    author: req.body.author || '',
    genre: req.body.genre || '',
    description: req.body.description || '',
    publishDate: req.body.publishDate || '',
    readingStatus: req.body.readingStatus || 'Pendiente',
  };

  const errors = validateBook(form);

  if (errors.length > 0) {
    return res.status(400).render('books/edit', {
      title: 'Editar libro',
      errors,
      statuses: READING_STATUS,
      form,
      bookId: id,
    });
  }

  const updated = await Book.findOneAndUpdate(
    { _id: id, userId: req.user.id },
    {
      ...form,
      publishDate: form.publishDate ? new Date(form.publishDate) : null,
    },
    { new: true }
  );

  if (!updated) {
    return res.status(404).send('Libro no encontrado');
  }

  return res.redirect('/libros');
}

async function deleteBook(req, res) {
  const { id } = req.params;

  if (mongoose.Types.ObjectId.isValid(id)) {
    await Book.deleteOne({ _id: id, userId: req.user.id });
  }

  return res.redirect('/libros');
}

module.exports = {
  renderDashboard,
  listBooks,
  renderCreateForm,
  createBook,
  viewBook,
  renderEditForm,
  updateBook,
  deleteBook,
};
