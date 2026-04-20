const mongoose = require('mongoose');

const READING_STATUS = ['Pendiente', 'Leyendo', 'Terminado'];

const bookSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true,
    },
    author: {
      type: String,
      required: true,
      trim: true,
    },
    genre: {
      type: String,
      trim: true,
      default: '',
    },
    description: {
      type: String,
      trim: true,
      default: '',
    },
    publishDate: {
      type: Date,
      default: null,
    },
    readingStatus: {
      type: String,
      enum: READING_STATUS,
      default: 'Pendiente',
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = {
  Book: mongoose.model('Book', bookSchema),
  READING_STATUS,
};
