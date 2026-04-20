const jwt = require('jsonwebtoken');

function getTokenFromRequest(req) {
  return req.cookies.token || null;
}

function setUserFromToken(req, res, next) {
  const token = getTokenFromRequest(req);

  if (!token) {
    res.locals.currentUser = null;
    return next();
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = payload;
    res.locals.currentUser = payload;
  } catch (error) {
    res.clearCookie('token');
    res.locals.currentUser = null;
  }

  return next();
}

function requireAuth(req, res, next) {
  const token = getTokenFromRequest(req);

  if (!token) {
    return res.redirect('/login');
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = payload;
    res.locals.currentUser = payload;
    return next();
  } catch (error) {
    res.clearCookie('token');
    return res.redirect('/login');
  }
}

module.exports = {
  setUserFromToken,
  requireAuth,
};
