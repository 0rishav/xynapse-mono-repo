FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
# Copy necessary packages
COPY packages/common/package.json ./packages/common/
COPY apps/course-service/package.json ./apps/course-service/
RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

# 1. Non-root user setup for Alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S rishav -u 1001 -G nodejs

# 2. Permissions fix: Runner ko files ka owner banao
COPY --from=deps /app/node_modules ./node_modules
COPY packages/common ./packages/common
COPY apps/course-service ./apps/course-service

# Files ka ownership switch karo
RUN chown -R rishav:nodejs /app

# 3. Security audit ke liye mandatory USER instruction
USER rishav

EXPOSE 8002
ENV NODE_ENV=production

WORKDIR /app/apps/course-service
CMD ["node", "src/index.js"]