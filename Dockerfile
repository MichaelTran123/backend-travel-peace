# FROM node:16.3.0-alpine3.13
FROM node:20-alpine
# Set default environment (optional)
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
# Set the correct permissions for the working directory
RUN mkdir -p /usr/src/app/dist && chown -R node:node /usr/src/app

# Install dependencies (excluding dev dependencies for production)
RUN if [ "$NODE_ENV" = "production" ]; then \
        npm ci --omit=dev; \
    else \
        npm ci; \
    fi
COPY . .

# Build the application (only if not in development)
RUN if [ "$NODE_ENV" != "development" ]; then \
        npm run build; \
    fi

EXPOSE 3000

# Switch to non-root user
USER node

# Command to run the application
CMD if [ "$NODE_ENV" = "production" ]; then \
        npm run start:prod; \
    else \
        npm run start:dev; \
    fi
# CMD ["npm", "run", "start:prod"]
# CMD [ "npm", "run", "start:dev" ]

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