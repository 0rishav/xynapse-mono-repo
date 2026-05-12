FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json ./
COPY packages/common/package.json ./packages/common/
COPY apps/course-service/package.json ./apps/course-service/

RUN npm install --omit=dev

FROM node:20-alpine AS runner
WORKDIR /app

#RUN addgroup -S nodejs && adduser -S rishav -G nodejs
#USER rishav

# Identity ki tarah abhi root pe hi rakhte hain testing ke liye
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json

COPY packages/common ./packages/common
COPY apps/course-service ./apps/course-service

WORKDIR /app/apps/course-service

EXPOSE 8002
ENV NODE_ENV=production

CMD ["node", "src/index.js"]
