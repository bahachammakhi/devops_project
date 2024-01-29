# build environment
FROM node:18 as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY ./client/package.json ./
COPY client/ ./
COPY nginx.conf ./
RUN yarn install
RUN yarn build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]