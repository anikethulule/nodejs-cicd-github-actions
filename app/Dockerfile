# Multi-stage build for Node.js static website
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

# Production stage
FROM node:22-alpine

WORKDIR /app

# Upgrade base OS packages to reduce vulnerabilities
RUN apk update && apk upgrade --no-cache

# Copy production dependencies
COPY --from=builder /app/node_modules ./node_modules

# Copy application files
COPY src ./src
COPY public ./public
COPY package*.json ./

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => { if (r.statusCode !== 200) process.exit(1); }).on('error', () => process.exit(1))"

CMD ["npm", "start"]