const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/User");

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
  const { nombre, correo, password } = req.body;

  if (!nombre || !correo || !password) {
    return res
      .status(400)
      .json({ message: "Nombre, correo y contraseña son obligatorios" });
  }

  if (password.length < 6) {
    return res
      .status(400)
      .json({ message: "La contraseña debe tener al menos 6 caracteres" });
  }

  const correoNormalizado = correo.trim().toLowerCase();
  const existingUser = await User.findOne({ correo: correoNormalizado });
  if (existingUser) {
    return res.status(409).json({ message: "El correo ya está registrado" });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const newUser = await User.create({
    nombre: nombre.trim(),
    correo: correoNormalizado,
    passwordHash,
  });

  return res.status(201).json(buildAuthResponse(newUser));
};

const login = async (req, res) => {
  const { correo, password } = req.body;

  if (!correo || !password) {
    return res
      .status(400)
      .json({ message: "Correo y contraseña son obligatorios" });
  }

  const correoNormalizado = correo.trim().toLowerCase();
  const user = await User.findOne({ correo: correoNormalizado });
  if (!user) {
    return res.status(401).json({ message: "Credenciales inválidas" });
  }

  const passwordOk = await bcrypt.compare(password, user.passwordHash);
  if (!passwordOk) {
    return res.status(401).json({ message: "Credenciales inválidas" });
  }

  return res.json(buildAuthResponse(user));
};

module.exports = {
  register,
  login,
};
