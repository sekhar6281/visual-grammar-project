# Step 1: Build the Flutter app using a pre-installed Flutter image
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release --web-renderer html

# Step 2: Use Nginx to serve the static files
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
# Fixes 404 errors on page refresh
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf
EXPOSE 80
