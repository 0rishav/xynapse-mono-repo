FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/identity-service/package.json ./apps/identity-service/

RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

# Yahan se USER aur addgroup wala part temporarily hata de testing ke liye
# RUN addgroup -S nodejs && adduser -S nextjs -G nodejs
# USER nextjs

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json

COPY packages/common ./packages/common
COPY apps/identity-service ./apps/identity-service

WORKDIR /app/apps/identity-service

EXPOSE 8001
ENV NODE_ENV=production

CMD ["node", "src/index.js"]
