FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/gateway-service/package.json ./apps/gateway-service/
RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

# 1. Build time par user banao
RUN addgroup -g 1001 -S nodejs && \
    adduser -S rishav -u 1001 -G nodejs

# 2. Files COPY karte waqt root ka access rahega, build fail nahi hoga
COPY --from=deps /app/node_modules ./node_modules
COPY packages/common ./packages/common
COPY apps/gateway-service ./apps/gateway-service

# 3. Yahan pe permissions set karo (root access use karke)
RUN chown -R rishav:nodejs /app

# 4. Ab USER switch karo - sirf runtime ke liye
USER rishav

WORKDIR /app/apps/gateway-service

EXPOSE 8000
ENV NODE_ENV=production

CMD ["node", "src/index.js"]