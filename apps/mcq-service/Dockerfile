FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/mcq-service/package.json ./apps/mcq-service/

RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

# 1. System user 'node' ka ownership lo
RUN chown -R node:node /app

# 2. Files copy karo (root ke context mein)
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json
COPY packages/common ./packages/common
COPY apps/mcq-service ./apps/mcq-service

# 3. Yahan switch karo taaki security audit pass ho
USER node

WORKDIR /app/apps/mcq-service

EXPOSE 8003
ENV NODE_ENV=production

CMD ["node", "src/index.js"]