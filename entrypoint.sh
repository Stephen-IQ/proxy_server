#!/bin/sh

# Start Nginx in the background
nginx &

# Wait for Nginx to fully start
sleep 5

# Obtain or renew certificates
if [ ! -d "/etc/letsencrypt/live/iq-dist-4.com" ]; then
    certbot --nginx -d iq-dist-4.com --agree-tos --non-interactive --email stephen@incquery.com
else
    certbot renew --quiet
fi

# Bring Nginx to foreground
wait -n
