# Stage 1: Build the Nginx image with config files
FROM nginx:alpine as stage1

RUN apk add certbot certbot-nginx
RUN apk add python3 python3-dev py3-pip build-base libressl-dev musl-dev libffi-dev rust cargo
RUN pip3 install pip --upgrade
RUN pip3 install certbot-nginx
RUN mkdir /etc/letsencrypt

COPY nginx.conf /etc/nginx/nginx.conf
COPY iq-dist-3.conf /etc/nginx/conf.d/iq-dist-3.conf


# Stage 2: Create a minimal image with the compiled Nginx binary
FROM nginx:alpine

COPY --from=stage1 /usr/sbin/nginx /usr/sbin/nginx
COPY --from=stage1 /etc/nginx /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]