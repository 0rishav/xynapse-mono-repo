FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/gateway-service/package.json ./apps/gateway-service/

RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

#RUN addgroup -S nodejs && adduser -S rishav -G nodejs
#USER rishav

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json

COPY packages/common ./packages/common
COPY apps/gateway-service ./apps/gateway-service

WORKDIR /app/apps/gateway-service

EXPOSE 8000
ENV NODE_ENV=production

CMD ["node", "src/index.js"]
