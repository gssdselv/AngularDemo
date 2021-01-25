FROM node:latest as node
WORKDIR  /app
COPY . .
RUN npm install
RUN npm run build --dev

FROM nginx:alpine
COPY --from=node /app/dist/APT-UI /usr/share/nginx/html

