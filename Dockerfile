# Use a lightweight Nginx image
FROM nginx:alpine

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-4.conf /etc/nginx/conf.d/iq-dist-4.conf

# Ensure necessary directories exist
RUN mkdir -p /var/www/html && \
    chmod -R 755 /var/www/html

# Expose only HTTP since DigitalOcean will handle HTTPS
EXPOSE 80

# Use default Nginx command
CMD ["nginx", "-g", "daemon off;"]
