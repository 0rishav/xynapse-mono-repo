FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/mcq-service/package.json ./apps/mcq-service/

RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

#RUN addgroup -S nodejs && adduser -S rishav -G nodejs
#USER rishav

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json

COPY packages/common ./packages/common
COPY apps/mcq-service ./apps/mcq-service

WORKDIR /app/apps/mcq-service

EXPOSE 8003
ENV NODE_ENV=production

CMD ["node", "src/index.js"]
