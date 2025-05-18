# Stage 1: Base image
FROM node:21-alpine3.18 AS base

# Stage 2: Install dependencies
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./
RUN npm ci

# Stage 3: Build the application
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules

# Copy the rest of the application code
COPY . .

# Build the NestJS application
RUN npm run build

# Stage 4: Production image
FROM base AS runner
WORKDIR /app
ENV NODE_ENV production

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs

# Copy built files from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Set permissions
RUN chown -R nestjs:nodejs /app

# Switch to the non-root user
USER nestjs

# Expose the port
EXPOSE 3000

# Start the application
CMD ["node", "dist/main.js"]
