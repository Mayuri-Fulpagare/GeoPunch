"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
require("dotenv/config");
const client_1 = require("@prisma/client");
const pg_1 = require("pg");
const adapter_pg_1 = require("@prisma/adapter-pg");
const pool = new pg_1.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new adapter_pg_1.PrismaPg(pool);
const prisma = new client_1.PrismaClient({ adapter });
async function main() {
    const office = await prisma.officeLocation.create({
        data: {
            name: 'Headquarters',
            latitude: 37.7749,
            longitude: -122.4194,
            radius: 200,
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
//# sourceMappingURL=seed-office.js.map