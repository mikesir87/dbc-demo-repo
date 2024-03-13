FROM node:lts AS base
WORKDIR /usr/local/app

FROM base AS dev
ENV NODE_ENV=development
CMD ["yarn", "dev"]

FROM base AS build
COPY package.json yarn.lock ./
RUN yarn install
COPY .eslintrc.cjs index.html vite.config.js ./
COPY public ./public
COPY src ./src
RUN yarn build

FROM nginx:alpine AS final
COPY --from=build /usr/local/app/dist /usr/share/nginx/html