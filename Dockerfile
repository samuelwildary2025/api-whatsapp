# Stage 1: Build Frontend
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Build Backend
FROM node:18-alpine AS backend-builder
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci
COPY backend/ .
RUN npm run build

# Stage 3: Production
FROM node:18-alpine
WORKDIR /app

# Copy backend dependencies
COPY backend/package*.json ./
RUN npm ci --only=production

# Copy backend build
COPY --from=backend-builder /app/backend/dist ./dist

# Copy frontend build
COPY --from=frontend-builder /app/frontend/dist ./client

# Expose port
EXPOSE 3000

# Start command
CMD ["node", "dist/main"]
