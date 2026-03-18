# 1. Use a specialized Flutter build image
FROM ghcr.io/cirruslabs/flutter:stable AS build

# 2. Set working directory
WORKDIR /app

# 3. Copy project files
COPY . .

# 4. Get dependencies and build web
RUN flutter pub get
RUN flutter build web --release --web-renderer html

# 5. Use Nginx to serve the build files
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# 6. Fix for refreshing pages (404 fix)
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

EXPOSE 80
