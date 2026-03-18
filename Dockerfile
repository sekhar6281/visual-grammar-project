# Use micromamba as the base to keep the image small and fast
FROM mambaorg/micromamba:latest AS build

# Switch to root to install system dependencies
USER root
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

# Install Flutter inside the micromamba environment
WORKDIR /app
RUN git clone https://github.com/flutter/flutter.git -b stable /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Ensure Flutter is ready
RUN flutter doctor
RUN flutter config --enable-web

# Copy your project and build
COPY . .
RUN flutter pub get
RUN flutter build web --release --web-renderer html

# Final Stage: Use Nginx to serve the static files
FROM nginx:stable-alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Custom redirect to prevent 404 on refresh (Essential for Flutter Web)
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
