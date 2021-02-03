FROM tiangolo/node-frontend:10 as bld-stg

WORKDIR /app

COPY my-app/package*.json /app/
RUN npm install
COPY my-app/ /app/
RUN npm run build

FROM nginx:1.15
COPY --from=build-stage /app/build/ /usr/share/nginx/html

COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf
