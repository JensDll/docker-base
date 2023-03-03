ARG NGINX_VERSION

FROM --platform=$BUILDPLATFORM nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine as ngx_brotli

USER root

ARG NGINX_VERSION
WORKDIR /compile

RUN apk -U upgrade && apk add git g++ pcre-dev zlib-dev make
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar xzf nginx-${NGINX_VERSION}.tar.gz
RUN git clone https://github.com/google/ngx_brotli --recursive --depth 1

WORKDIR /compile/nginx-${NGINX_VERSION}

RUN ./configure --with-compat --add-dynamic-module=../ngx_brotli
RUN make modules

# Final image
FROM --platform=$BUILDPLATFORM nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine

ARG NGINX_VERSION

COPY --from=ngx_brotli /compile/nginx-${NGINX_VERSION}/objs/ngx_http_brotli*.so /usr/lib/nginx/modules/
