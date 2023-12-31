FROM node:18-alpine AS development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci 

COPY . .

RUN npm run build

FROM node:18-alpine As production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm ci --only=prod && npm cache clean --force

COPY . .

COPY --from=development /usr/src/app/dist ./dist

CMD [ "node", "dist/main.js" ]