# Stage 1: Build the Nginx image with config files
FROM nginx:alpine as stage1

RUN apk add certbot certbot-nginx
RUN apk add python3 python3-dev py3-pip build-base libressl-dev musl-dev libffi-dev rust cargo

# Create a virtual environment
WORKDIR /app
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:$PATH"
ENV TOKEN="$TOKEN"

# Activate the virtual environment and install dependencies
RUN . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install certbot-nginx && \ 
    pip install pip certbot-dns-digitalocean

COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-4.conf /etc/nginx/conf.d/iq-dist-4.conf

#Make directory to store certs
RUN mkdir -p /var/www/html

# Obtain Let's Encrypt certificate
RUN certbot certonly --dns-digitalocean --dns-digitalocean-credentials "$TOKEN" -d iq-dist-4.com --agree-tos --non-interactive --email stephen@incquery.com

# Stage 2: Create a minimal image with the compiled Nginx binary
FROM nginx:alpine

COPY --from=stage1 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=stage1 /etc/nginx /etc/nginx
COPY --from=stage1 /app/venv /app/venv
COPY --from=stage1 /etc/letsencrypt /etc/letsencrypt

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]