const express = require('express');
const bookController = require('../controllers/bookController');

const router = express.Router();

router.get('/dashboard', bookController.renderDashboard);

router.get('/libros', bookController.listBooks);
router.get('/libros/nuevo', bookController.renderCreateForm);
router.post('/libros', bookController.createBook);
router.get('/libros/:id', bookController.viewBook);
router.get('/libros/:id/editar', bookController.renderEditForm);
router.post('/libros/:id/editar', bookController.updateBook);
router.post('/libros/:id/eliminar', bookController.deleteBook);

module.exports = router;
