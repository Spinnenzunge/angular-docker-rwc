#
# Stage 1: Build angular project
#
FROM node:14 as build-stage

# Create app directory
WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json /app/

# If you are building your code for production
RUN npm ci

# Bundle app source
COPY ./ /app/

# Build project
RUN npm run build -- --output-path=./dist/out --prod

#
# Stage 2: Start nginx proxy
#
FROM nginx

# Copy compiled angular app to nginx
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html

# Overwrite default nginx.conf
COPY --from=build-stage /app/nginx-custom.conf /etc/nginx/conf.d/default.conf
