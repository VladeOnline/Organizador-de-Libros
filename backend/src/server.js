const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const authRoutes = require("./routes/auth.routes");
const bookRoutes = require("./routes/book.routes");

dotenv.config();

const app = express();
const port = process.env.PORT || 4000;

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true);

      const allowedOrigin = process.env.CORS_ORIGIN;
      if (allowedOrigin && origin === allowedOrigin) {
        return callback(null, true);
      }

      const isLocalhost =
        /^http:\/\/localhost:\d+$/.test(origin) ||
        /^http:\/\/127\.0\.0\.1:\d+$/.test(origin);

      if (isLocalhost) {
        return callback(null, true);
      }

      return callback(new Error("Origen no permitido por CORS"));
    },
  })
);
app.use(express.json());

app.get("/api/health", (_req, res) => {
  res.json({ ok: true, message: "API funcionando" });
});

app.use("/api/auth", authRoutes);
app.use("/api/books", bookRoutes);

app.use((err, _req, res, _next) => {
  console.error(err);
  return res.status(500).json({ message: "Error interno del servidor" });
});

connectDB()
  .then(() => {
    app.listen(port, () => {
      console.log(`API corriendo en http://localhost:${port}`);
    });
  })
  .catch((error) => {
    console.error("No se pudo iniciar la API:", error.message);
    process.exit(1);
  });
