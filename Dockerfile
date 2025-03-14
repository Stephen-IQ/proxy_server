# Use a single-stage build (no unnecessary certbot installation in stage1)
FROM nginx:alpine

# Install Certbot and dependencies
RUN apk add --no-cache certbot certbot-nginx python3 py3-pip

# Copy Nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-4.conf /etc/nginx/conf.d/iq-dist-4.conf

# Create necessary directories
RUN mkdir -p /var/www/html /etc/letsencrypt/live/iq-dist-4.com && \
    chmod -R 755 /var/www/html /etc/letsencrypt

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]