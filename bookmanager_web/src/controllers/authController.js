const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { validateRegister } = require('../utils/validators');

function signToken(user) {
  return jwt.sign(
    {
      id: user._id,
      name: user.name,
      email: user.email,
    },
    process.env.JWT_SECRET,
    { expiresIn: '1d' }
  );
}

function renderRegister(req, res) {
  return res.render('auth/register', {
    title: 'Registro',
    errors: [],
    form: {},
  });
}

function renderLogin(req, res) {
  return res.render('auth/login', {
    title: 'Iniciar sesion',
    errors: [],
    form: {},
  });
}

async function register(req, res) {
  const { name = '', email = '', password = '' } = req.body;
  const form = { name, email };

  const errors = validateRegister({ name, email, password });

  if (errors.length > 0) {
    return res.status(400).render('auth/register', {
      title: 'Registro',
      errors,
      form,
    });
  }

  const existingUser = await User.findOne({ email: email.toLowerCase().trim() });

  if (existingUser) {
    return res.status(400).render('auth/register', {
      title: 'Registro',
      errors: ['Ya existe una cuenta con ese correo.'],
      form,
    });
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await User.create({
    name: name.trim(),
    email: email.toLowerCase().trim(),
    password: hashedPassword,
  });

  const token = signToken(user);

  res.cookie('token', token, {
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000,
  });

  return res.redirect('/dashboard');
}

async function login(req, res) {
  const { email = '', password = '' } = req.body;
  const form = { email };

  if (!email.trim() || !password.trim()) {
    return res.status(400).render('auth/login', {
      title: 'Iniciar sesion',
      errors: ['Correo y contraseña son obligatorios.'],
      form,
    });
  }

  const user = await User.findOne({ email: email.toLowerCase().trim() });

  if (!user) {
    return res.status(400).render('auth/login', {
      title: 'Iniciar sesion',
      errors: ['Credenciales invalidas.'],
      form,
    });
  }

  const isValidPassword = await bcrypt.compare(password, user.password);

  if (!isValidPassword) {
    return res.status(400).render('auth/login', {
      title: 'Iniciar sesion',
      errors: ['Credenciales invalidas.'],
      form,
    });
  }

  const token = signToken(user);

  res.cookie('token', token, {
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000,
  });

  return res.redirect('/dashboard');
}

function logout(req, res) {
  res.clearCookie('token');
  return res.redirect('/login');
}

module.exports = {
  renderRegister,
  renderLogin,
  register,
  login,
  logout,
};
