import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Enable CORS for Flutter web / frontend testing
  app.enableCors();
  
  // Global validation pipe for DTOs
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

  await app.listen(process.env.PORT ?? 3000);
  console.log(`Backend is running on: http://localhost:${process.env.PORT ?? 3000}`);
}
bootstrap();
