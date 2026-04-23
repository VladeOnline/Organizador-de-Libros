const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

const isValidEmail = (value) => {
  const email = (value || "").trim();
  return email.includes("@");
};

const buildAuthResponse = (user) => {
  const token = jwt.sign(
    { userId: user._id.toString(), correo: user.correo },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  return {
    token,
    user: {
      id: user._id,
      nombre: user.nombre,
      correo: user.correo,
    },
  };
};

const register = async (req, res) => {
  try {
    const { nombre, correo, password } = req.body;

    if (!nombre || !correo || !password) {
      return res
        .status(400)
        .json({ message: "Nombre, correo y contrasena son obligatorios" });
    }

    if (!isValidEmail(correo)) {
      return res
        .status(400)
        .json({ message: "El correo debe contener @" });
    }

    if (password.length < 6) {
      return res
        .status(400)
        .json({ message: "La contrasena debe tener al menos 6 caracteres" });
    }

    const correoNormalizado = correo.trim().toLowerCase();
    const existingUser = await User.findOne({ correo: correoNormalizado });
    if (existingUser) {
      return res.status(409).json({ message: "El correo ya esta registrado" });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const newUser = await User.create({
      nombre: nombre.trim(),
      correo: correoNormalizado,
      passwordHash,
    });

    return res.status(201).json(buildAuthResponse(newUser));
  } catch (error) {
    if (error?.code === 11000 && error?.keyPattern?.correo) {
      return res.status(409).json({ message: "El correo ya esta registrado" });
    }
    throw error;
  }
};

const login = async (req, res) => {
  const { correo, password } = req.body;

  if (!correo || !password) {
    return res
      .status(400)
      .json({ message: "Correo y contrasena son obligatorios" });
  }

  if (!isValidEmail(correo)) {
    return res
      .status(400)
      .json({ message: "El correo debe contener @" });
  }

  const correoNormalizado = correo.trim().toLowerCase();
  const user = await User.findOne({ correo: correoNormalizado });
  if (!user) {
    return res.status(401).json({ message: "Credenciales invalidas" });
  }

  const passwordOk = await bcrypt.compare(password, user.passwordHash);
  if (!passwordOk) {
    return res.status(401).json({ message: "Credenciales invalidas" });
  }

  return res.json(buildAuthResponse(user));
};

module.exports = {
  register,
  login,
};

