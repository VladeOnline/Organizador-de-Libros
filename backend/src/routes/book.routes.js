const express = require("express");
const authMiddleware = require("../middleware/auth");
const {
  listBooks,
  createBook,
  updateBook,
  deleteBook,
} = require("../controllers/book.controller");

const router = express.Router();

router.use(authMiddleware);
router.get("/", listBooks);
router.post("/", createBook);
router.put("/:id", updateBook);
router.delete("/:id", deleteBook);

module.exports = router;
