const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const authRoutes = require('./routes/authRoutes');
const bookRoutes = require('./routes/bookRoutes');
const { setUserFromToken, requireAuth } = require('./middlewares/authMiddleware');

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, '..', 'public')));

app.use(setUserFromToken);

app.get('/', (req, res) => {
  if (res.locals.currentUser) {
    return res.redirect('/dashboard');
  }
  return res.redirect('/login');
});

app.use(authRoutes);
app.use(requireAuth, bookRoutes);

app.use((err, req, res, next) => {
  console.error(err);
  return res.status(500).send('Ocurrio un error interno en el servidor.');
});

module.exports = app;
