const express = require('express');
const cors = require('cors');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();
const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

// Health Check
app.get('/api/health', (req, res) => {
  res.json({ status: 'online', service: 'Delivery Tracker API' });
});

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