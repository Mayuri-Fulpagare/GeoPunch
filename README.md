# 📍 GeoPunch

![GeoPunch](https://img.shields.io/badge/Status-Active-success)
![NestJS](https://img.shields.io/badge/Backend-NestJS-E0234E?logo=nestjs)
![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791?logo=postgresql)
![Flutter](https://img.shields.io/badge/Frontend-Flutter-02569B?logo=flutter)

**GeoPunch** is a production-ready, highly accurate geo-fenced attendance system. It ensures data integrity and prevents buddy-punching by strictly enforcing location-based check-ins and check-outs using robust server-side validation.

## 🚀 Features

- **Geo-fenced Attendance:** Employees can only check in and out when they are within the designated office radius.
- **Advanced Location Validation:** Utilizes the Haversine formula for precise distance calculations between the user's GPS coordinates and the office location.
- **Anti-Spoofing & Accuracy Filtering:** Rejects attendance attempts with poor GPS accuracy or suspected mock locations to ensure high data integrity.
- **Device Binding:** Associates users with specific devices (`deviceId`) to prevent unauthorized check-ins from secondary devices.
- **Role-Based Access Control:** Differentiates between `ADMIN` (managing office locations, viewing reports) and `EMPLOYEE` (checking in/out, viewing personal history).
- **Automated Work Hours Tracking:** Automatically calculates and logs total daily working hours based on check-in and check-out times.

## 🛠️ Tech Stack

**Backend**
- [NestJS](https://nestjs.com/) (Node.js framework)
- [TypeScript](https://www.typescriptlang.org/)
- [Prisma ORM](https://www.prisma.io/)
- [PostgreSQL](https://www.postgresql.org/)

**Frontend** *(Planned / In Progress)*
- [Flutter](https://flutter.dev/)
- GetX (State Management)
- Firebase (Push Notifications)

## 📂 Project Structure

```
GeoPunch/
├── backend/               # NestJS API, Prisma schema, and business logic
│   ├── src/               # Application source code (Controllers, Services, Modules)
│   ├── prisma/            # Database schema and migrations
│   └── ...
└── README.md              # Project documentation
```

## ⚙️ Backend Setup & Installation

### Prerequisites

- [Node.js](https://nodejs.org/en/) (v16 or higher)
- [PostgreSQL](https://www.postgresql.org/) database
- npm or yarn

### 1. Clone the repository

```bash
git clone https://github.com/your-username/GeoPunch.git
cd GeoPunch/backend
```

### 2. Install dependencies

```bash
npm install
```

### 3. Environment Variables

Create a `.env` file in the `backend` directory (you can use `.env.example` as a reference) and add the necessary environment variables, primarily your database connection URL:

```env
DATABASE_URL="postgresql://USER:PASSWORD@HOST:PORT/DATABASE_NAME?schema=public"
```

### 4. Database Setup

Push the Prisma schema to your PostgreSQL database to create the required tables:

```bash
npx prisma db push
```

*(Optional)* Seed the database with initial admin and office location data if you have a seed script set up.

### 5. Running the Application

**Development Mode:**
```bash
npm run start:dev
```

**Production Mode:**
```bash
npm run build
npm run start:prod
```

## 🗄️ Database Schema Overview

- **User:** Stores user credentials, role (`EMPLOYEE` or `ADMIN`), and an optional `deviceId` for binding.
- **OfficeLocation:** Defines the center point (`latitude`, `longitude`) and acceptable `radius` (in meters) for valid check-ins.
- **Attendance:** Logs `checkInTime`, `checkOutTime`, coordinates, GPS `accuracy`, `status` (`PRESENT`, `LATE`, `ABSENT`), and calculated `workingHours`.

## 🛡️ Security

- Passwords are securely hashed using bcrypt before being stored in the database.
- Future enhancements include JWT-based authentication for securing API endpoints.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/your-username/GeoPunch/issues).

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
