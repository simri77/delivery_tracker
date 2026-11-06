const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/authMiddleware');
const { getUserProfile, updateUserProfile } = require('../controllers/userController');

// All user routes require authentication
router.get('/profile', authenticateToken, getUserProfile);
router.patch('/profile', authenticateToken, updateUserProfile);

module.exports = router;