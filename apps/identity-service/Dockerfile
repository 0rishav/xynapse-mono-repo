FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/identity-service/package.json ./apps/identity-service/
RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

# Alpine ka default 'node' user already hota hai, usey hi use karlo
# Isse user create karne ka jhanjhat hi khatam ho jayega
RUN chown -R node:node /app

# Switch to the existing 'node' user
USER node

COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json
COPY packages/common ./packages/common
COPY apps/identity-service ./apps/identity-service

WORKDIR /app/apps/identity-service

EXPOSE 8001
ENV NODE_ENV=production

CMD ["node", "src/index.js"]