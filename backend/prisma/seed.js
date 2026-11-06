const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function main() {
  const hashedPassword = await bcrypt.hash('password123', 10);

  // Create or update the test user matching your Flutter profile screen
  const user = await prisma.user.upsert({
    where: { email: 'alex.rivera@deliverymail.com' },
    update: {},
    create: {
      name: 'Alexandria Rivera',
      email: 'alex.rivera@deliverymail.com',
      password: hashedPassword,
      phone: '+1 (555) 382-9102',
      tier: 'Gold Tier Member',
      points: 4820,
    },
  });

  console.log('Seeded user:', user.email);

  // Create a sample active order matching your Flutter home/delivery screens
  const order = await prisma.order.upsert({
    where: { orderIdString: 'ORD-8921' },
    update: {},
    create: {
      orderIdString: 'ORD-8921',
      status: 'out_for_delivery',
      estimatedTime: '18 min ETA',
      driverName: 'Marcus Vance',
      deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
      totalPrice: 42.50,
      userId: user.id,
    },
  });

  console.log('Seeded active order:', order.orderIdString);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });