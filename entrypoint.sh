#!/bin/sh

echo "[INFO] Starting Nginx..."
nginx -g "daemon off;" &

sleep 5

echo "[INFO] Checking if Let's Encrypt cert exists..."
if [ ! -d "/etc/letsencrypt/live/iq-dist-4.com" ]; then
    echo "[INFO] Obtaining new SSL certificate..."
    certbot --nginx -d iq-dist-4.com --agree-tos --non-interactive --email stephen@incquery.com
    if [ $? -ne 0 ]; then
        echo "[ERROR] Certbot failed!"
        exit 1
    fi
else
    echo "[INFO] Certificate already exists. Running renewal..."
    certbot renew --quiet
fi

echo "[INFO] Reloading Nginx to apply changes..."
nginx -s reload

echo "[INFO] Bringing Nginx to foreground..."
wait -n