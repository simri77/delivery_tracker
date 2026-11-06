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

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ status: 'online', service: 'Delivery Tracker API' });
});

// ==================== AUTHENTICATION ROUTES ====================

// 1. Register Endpoint
app.post('/api/auth/register', async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ error: 'Please provide name, email, and password.' });
    }

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ error: 'Email is already registered.' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
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

// 2. Login Endpoint
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Please provide email and password.' });
    }

    // Find user by email
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      return res.status(400).json({ error: 'Invalid email or password.' });
    }

    // Compare hashed passwords
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ error: 'Invalid email or password.' });
    }

    // Generate JWT token (expires in 7 days)
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

// ==================== EXISTING APP ROUTES ====================

// Get Active Order (for HomeScreen & DeliveryScreen)
app.get('/api/orders/active', async (req, res) => {
  try {
    const order = await prisma.order.findFirst({
      where: { status: { not: 'delivered' } },
      include: { items: true },
    });
    if (!order) return res.status(404).json({ error: 'No active orders found' });
    res.json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get User Profile (for ProfileScreen)
app.get('/api/user/profile', async (req, res) => {
  try {
    const user = await prisma.user.findFirst({
      include: { addresses: true },
    });
    res.json(user || { name: 'Alexandria Rivera', email: 'alex.rivera@deliverymail.com' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Backend running on port ${PORT}`);
});