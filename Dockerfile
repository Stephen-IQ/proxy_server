# Stage 1: Build the Nginx image with config files
FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-3.conf /etc/nginx/conf.d/iq-dist-3.conf
ADD lets-encrypt /usr/nginx/ssl/let-encrypt

# Stage 2: Create a minimal image with the compiled Nginx binary
FROM nginx:alpine

COPY --from=stage1 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=stage1 /etc/nginx /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]