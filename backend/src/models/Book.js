const mongoose = require("mongoose");

const validStates = ["Pendiente", "Leyendo", "Terminado"];

const bookSchema = new mongoose.Schema(
  {
    titulo: {
      type: String,
      required: true,
      trim: true,
    },
    autor: {
      type: String,
      required: true,
      trim: true,
    },
    genero: {
      type: String,
      required: true,
      trim: true,
    },
    descripcion: {
      type: String,
      default: "",
      trim: true,
    },
    estadoLectura: {
      type: String,
      enum: validStates,
      default: "Pendiente",
    },
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
  },
  {
    timestamps: true,
    versionKey: false,
  }
);

module.exports = {
  Book: mongoose.model("Book", bookSchema),
  validStates,
};
