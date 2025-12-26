import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Set global prefix for API routes
  app.setGlobalPrefix('api');

  // Swagger Configuration
  const config = new DocumentBuilder()
    .setTitle('WhatsApp API')
    .setDescription('API for managing WhatsApp instances and messages')
    .setVersion('1.0')
    .addTag('instances')
    .addTag('messages')
    .addBearerAuth()
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
