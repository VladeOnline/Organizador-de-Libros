const mongoose = require("mongoose");

const connectDB = async () => {
  const uri = process.env.MONGODB_URI;
  if (!uri) {
    throw new Error("Falta MONGODB_URI en variables de entorno");
  }

  await mongoose.connect(uri);
  console.log("MongoDB conectado");
};

module.exports = connectDB;
