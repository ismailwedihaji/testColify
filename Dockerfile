# # Use Node.js 18 Alpine for smaller image size
# FROM node:18-alpine AS base

# # Install dependencies only when needed
# FROM base AS deps
# RUN apk add --no-cache libc6-compat
# WORKDIR /app

# # Copy package files and install dependencies
# COPY package.json package-lock.json* ./
# RUN npm ci --only=production && npm cache clean --force

# # Build stage
# FROM base AS builder
# WORKDIR /app

# # Copy node_modules from deps stage
# COPY --from=deps /app/node_modules ./node_modules
# COPY . .

# # Set environment variables for build
# ENV NEXT_TELEMETRY_DISABLED=1
# ENV NODE_ENV=production

# # Build the application
# RUN npm run build

# # Production stage
# FROM base AS runner
# WORKDIR /app

# # Set production environment
# ENV NODE_ENV=production
# ENV NEXT_TELEMETRY_DISABLED=1
# ENV PORT=3000
# ENV HOSTNAME="0.0.0.0"

# # Create system user
# RUN addgroup --system --gid 1001 nodejs && \
#     adduser --system --uid 1001 nextjs

# # Copy public files (create empty public dir first to avoid errors)
# RUN mkdir -p ./public
# COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# # Create .next directory with correct permissions
# RUN mkdir .next && chown nextjs:nodejs .next

# # Copy built application
# COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# # Switch to non-root user
# USER nextjs

# # Expose port
# EXPOSE 3000

# # Start the application
# CMD ["node", "server.js"]


# Use Node.js 18 Alpine for smaller image size
FROM node:18-alpine AS base

# Common setup
RUN apk add --no-cache libc6-compat
WORKDIR /app

# ---------------------
# Dependencies stage
# ---------------------
FROM base AS deps

# Copy only package files first (so Docker can cache npm install)
COPY package.json package-lock.json* ./

# Install all dependencies (not only production) for build step
RUN npm ci && npm cache clean --force

# ---------------------
# Build stage
# ---------------------
FROM base AS builder

# Copy node_modules from deps
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Set environment variables for build
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Build the application
RUN npm run build

# ---------------------
# Production stage
# ---------------------
FROM base AS runner

# Set production environment
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Create system user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy only what’s needed for runtime
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
