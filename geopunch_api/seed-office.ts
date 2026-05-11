/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL! });
// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const office = await prisma.officeLocation.create({
    data: {
      name: 'Headquarters',
      latitude: 37.7749,
      longitude: -122.4194,
      radius: 200, // 200 meters allowed check-in radius
    },
  });
  console.log(`\n\n✅ Office Created Successfully!`);
  console.log(`📍 Your NEW officeId is: ${office.id}\n\n`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
