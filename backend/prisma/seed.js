const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // Create a sample user matching your profile screen
  const user = await prisma.user.upsert({
    where: { email: 'alex.rivera@deliverymail.com' },
    update: {},
    create: {
      name: 'Alexandria Rivera',
      email: 'alex.rivera@deliverymail.com',
      tier: 'Gold Member',
    },
  });

  // Create a sample active delivery order matching your home/delivery screens
  await prisma.order.create({
    data: {
      orderIdString: 'ORD-8921',
      userId: user.id,
      status: 'out_for_delivery',
      estimatedTime: '18 min ETA',
      driverName: 'Marcus Vance',
      deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
      deliveryFee: 3.99,
      totalPrice: 42.50,
      items: {
        create: [
          { name: 'Artisan Sourdough', price: 14.50, quantity: 1 },
          { name: 'Fresh Patisserie Box', price: 28.00, quantity: 2 },
        ],
      },
    },
  });
  // Create or update a sample active delivery order safely
  await prisma.order.upsert({
    where: { orderIdString: 'ORD-8921' },
    update: {},
    create: {
      orderIdString: 'ORD-8921',
      userId: user.id,
      status: 'out_for_delivery',
      estimatedTime: '18 min ETA',
      driverName: 'Marcus Vance',
      deliveryAddress: 'Apt 4B, 742 Evergreen Terr',
      deliveryFee: 3.99,
      totalPrice: 42.50,
      items: {
        create: [
          { name: 'Artisan Sourdough', price: 14.50, quantity: 1 },
          { name: 'Fresh Patisserie Box', price: 28.00, quantity: 2 },
        ],
      },
    },
  });

  console.log('🌱 Database has been seeded with initial tracking data!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });