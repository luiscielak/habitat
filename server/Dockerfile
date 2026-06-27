FROM node:22-alpine

ENV NODE_ENV=production
WORKDIR /app

# Install only production dependencies first for better layer caching.
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm install --omit=dev

COPY src ./src

EXPOSE 8080

# Run as the non-root user that the node image provides.
USER node

CMD ["node", "src/index.js"]
