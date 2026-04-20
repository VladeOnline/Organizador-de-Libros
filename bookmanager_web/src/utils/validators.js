const { READING_STATUS } = require('../models/Book');

function validateRegister({ name, email, password }) {
  const errors = [];

  if (!name || !name.trim()) errors.push('El nombre es obligatorio.');
  if (!email || !email.trim()) errors.push('El correo es obligatorio.');
  if (!password || !password.trim()) errors.push('La contraseña es obligatoria.');
  if (password && password.length < 6) {
    errors.push('La contraseña debe tener al menos 6 caracteres.');
  }

  return errors;
}

function validateBook({ title, author, readingStatus }) {
  const errors = [];

  if (!title || !title.trim()) errors.push('El titulo es obligatorio.');
  if (!author || !author.trim()) errors.push('El autor es obligatorio.');

  if (!readingStatus || !READING_STATUS.includes(readingStatus)) {
    errors.push('El estado de lectura no es valido.');
  }

  return errors;
}

module.exports = {
  validateRegister,
  validateBook,
};
