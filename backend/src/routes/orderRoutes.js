const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/authMiddleware');
const {
  getActiveOrder,
  createOrder,
  updateOrderStatus,
} = require('../controllers/orderController');

router.get('/active', authenticateToken, getActiveOrder);
router.post('/', authenticateToken, createOrder);
router.patch('/:id/status', authenticateToken, updateOrderStatus);

module.exports = router;