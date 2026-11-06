  const express = require('express');
  const cors = require('cors');
  const bcrypt = require('bcryptjs');
  const jwt = require('jsonwebtoken');
  const { PrismaClient } = require('@prisma/client');

  const prisma = new PrismaClient();
  const app = express();

  const JWT_SECRET = process.env.JWT_SECRET || 'super_secret_key_change_me';
  const PORT = process.env.PORT || 5000;

  app.use(cors());
  app.use(express.json());

  // ==================== AUTHENTICATION MIDDLEWARE ====================
  function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Expected: "Bearer <token>"

    if (!token) {
      return res.status(401).json({ error: 'Access denied. No token provided.' });
    }

    jwt.verify(token, JWT_SECRET, (err, decodedUser) => {
      if (err) {
        return res.status(403).json({ error: 'Invalid or expired token.' });
      }
      req.user = decodedUser; // Attaches { userId, email } to request
      next();
    });
  }

  // ==================== PUBLIC ROUTES ====================

  // Health check
  app.get('/api/health', (req, res) => {
    res.json({ status: 'online', service: 'Delivery Tracker API' });
  });

  // Mount Routes
  app.use('/api/auth', authRoutes);
  app.use('/api/orders', orderRoutes);
  app.use('/api/user', userRoutes);

  // Register Endpoint
  app.post('/api/auth/register', async (req, res) => {
    try {
      const { name, email, password, phone } = req.body;

      if (!name || !email || !password) {
        return res.status(400).json({ error: 'Please provide name, email, and password.' });
      }

      const existingUser = await prisma.user.findUnique({ where: { email } });
      if (existingUser) {
        return res.status(400).json({ error: 'Email is already registered.' });
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      const newUser = await prisma.user.create({
        data: {
          name,
          email,
          password: hashedPassword,
          phone: phone || '',
          tier: 'Standard Member',
          points: 100,
        },
      });

      return res.status(201).json({
        message: 'User registered successfully',
        userId: newUser.id,
        email: newUser.email,
      });
    } catch (error) {
      console.error('Registration error:', error);
      return res.status(500).json({ error: error.message });
    }
  });

  // Login Endpoint
  app.post('/api/auth/login', async (req, res) => {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({ error: 'Please provide email and password.' });
      }

      const user = await prisma.user.findUnique({ where: { email } });
      if (!user) {
        return res.status(400).json({ error: 'Invalid email or password.' });
      }

      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        return res.status(400).json({ error: 'Invalid email or password.' });
      }

      const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, {
        expiresIn: '7d',
      });

      return res.status(200).json({
        message: 'Login successful',
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          tier: user.tier,
        },
      });
    } catch (error) {
      console.error('Login error:', error);
      return res.status(500).json({ error: error.message });
    }
  });

  // ==================== PROTECTED ROUTES (Require Bearer Token) ====================

  // Get Active Order for the logged-in user
  app.get('/api/orders/active', authenticateToken, async (req, res) => {
    try {
      // Find active order linked to the authenticated user
      const order = await prisma.order.findFirst({
        where: { 
          userId: req.user.userId, 
          status: { not: 'delivered' } 
        },
        include: { items: true },
      });

      if (!order) {
        return res.status(404).json({ error: 'No active orders found for this user' });
      }
      
      res.json(order);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

  // Get User Profile for the logged-in user
  app.get('/api/user/profile', authenticateToken, async (req, res) => {
    try {
      const user = await prisma.user.findUnique({
        where: { id: req.user.userId },
        include: { addresses: true },
      });

      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }

      // Strip out the password hash before sending response
      const { password, ...userProfile } = user;
      res.json(userProfile);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  });

  app.listen(PORT, () => {
    console.log(`🚀 Backend running on port ${PORT}`);
  });