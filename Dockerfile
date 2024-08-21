# FROM node:16.3.0-alpine3.13
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
CMD [ "npm", "run", "start:dev" ]

# FROM node:20-alpine AS development
# WORKDIR /usr/src/app
# COPY --chown=node:node package*.json ./
# RUN npm ci -f
# COPY --chown=node:node . .
# USER node

# FROM node:20-alpine AS build
# WORKDIR /usr/src/app
# COPY --chown=node:node package*.json ./
# COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules
# COPY --chown=node:node . .
# RUN npm run build
# RUN npm ci -f --only=production && npm cache clean --force
# USER node


# Production Stage
# FROM node:20-alpine AS production
# ENV NODE_ENV production
# COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
# COPY --chown=node:node --from=build /usr/src/app/dist ./dist
# CMD [ "node", "dist/main.js" ]