const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function getActiveOrder(req, res) {
  try {
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
}

async function createOrder(req, res) {
  try {
    const { deliveryAddress, totalPrice, items } = req.body;

    if (!totalPrice || !items || items.length === 0) {
      return res.status(400).json({ error: 'Please provide items and total price.' });
    }

    const orderIdString = `ORD-${Math.floor(1000 + Math.random() * 9000)}`;

    const newOrder = await prisma.order.create({
      data: {
        userId: req.user.userId,
        orderIdString,
        status: 'processing',
        estimatedTime: '25 min ETA',
        driverName: 'Marcus Vance',
        deliveryAddress: deliveryAddress || 'Default Address',
        totalPrice: parseFloat(totalPrice),
        items: {
          create: items.map((item) => ({
            name: item.name,
            quantity: item.quantity,
            price: parseFloat(item.price),
          })),
        },
      },
      include: { items: true },
    });

    return res.status(201).json({ message: 'Order created', order: newOrder });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

async function updateOrderStatus(req, res) {
  try {
    const { id } = req.params;
    const { status, estimatedTime } = req.body;

    const updatedOrder = await prisma.order.update({
      where: { id: parseInt(id) },
      data: {
        ...(status && { status }),
        ...(estimatedTime && { estimatedTime }),
      },
      include: { items: true },
    });

    return res.json({ message: 'Order status updated', order: updatedOrder });
  } catch (error) {
    return res.status(500).json({ error: 'Order update failed.' });
  }
}

module.exports = {
  getActiveOrder,
  createOrder,
  updateOrderStatus,
};