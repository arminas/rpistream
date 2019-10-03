FROM nginx:alpine

# nginx:alpine contains NGINX_VERSION environment variable, like so:
ENV NGINX_VERSION 1.17.4

# Install git and update cache
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# Download sources
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz

RUN git clone https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git

# For latest build deps, see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
RUN apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Reuse same cli arguments as the nginx:alpine image used to build
RUN CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
	mkdir /usr/src && tar -zxC /usr/src -f nginx.tar.gz && \
  RTMPDIR="$(pwd)/nginx-rtmp-module" && \
  cd /usr/src/nginx-$NGINX_VERSION && \
  ./configure --with-http_ssl_module --with-compat $CONFARGS --add-module=$RTMPDIR && \
  make && make install

COPY site/* /tmp/html/

RUN rm /etc/nginx/conf.d/default.conf /etc/nginx/nginx.conf && cp $(pwd)/nginx-rtmp-module/stat.xsl /tmp/stat.xsl

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

