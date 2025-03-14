# Stage 1: Prepare Nginx with dependencies
FROM nginx:alpine as stage1

RUN apk add --no-cache certbot certbot-nginx python3 py3-pip

COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-4.conf /etc/nginx/conf.d/iq-dist-4.conf

RUN mkdir -p /var/www/html /etc/letsencrypt/live/iq-dist-4.com

# Stage 2: Runtime Image
FROM nginx:alpine

COPY --from=stage1 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=stage1 /etc/nginx /etc/nginx
COPY --from=stage1 /var/www/html /var/www/html

EXPOSE 80 443

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
