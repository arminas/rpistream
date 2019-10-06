FROM raspbian/stretch

ENV NGINX_VERSION=1.17.4 \
    NGINX_SOURCE_DIR=/tmp/nginx-source \
    RTMP_MODULE_DIR=/tmp/rtmp-module

# os update & ffmpeg
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
    locales \
    ffmpeg \
    curl \
    build-essential \
    make \
    gcc \
    libpcre3 \
    libpcre3-dev \
    libpcre++-dev \
    zlib1g-dev \
    libbz2-dev \
    libxslt1-dev \
    libxml2-dev \
    libgd2-xpm-dev \
    libgeoip-dev \
    libgoogle-perftools-dev \
    libperl-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# nginx
RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && mkdir $NGINX_SOURCE_DIR \
    && tar -zxC $NGINX_SOURCE_DIR -f nginx.tar.gz \
    && mv ${NGINX_SOURCE_DIR}/*/* ${NGINX_SOURCE_DIR}/ \
    && rm nginx.tar.gz

RUN wget "https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/tarball/dev" -O rtmp.tar.gz \
    && mkdir $RTMP_MODULE_DIR \
    && tar -zxC $RTMP_MODULE_DIR -f rtmp.tar.gz \
    && mv ${RTMP_MODULE_DIR}/*/* ${RTMP_MODULE_DIR}/ \
    && rm rtmp.tar.gz

RUN set -x \
  && cd $NGINX_SOURCE_DIR \
  && ./configure \
  --prefix=/usr/share/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --pid-path=/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --with-threads \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_stub_status_module \
  --with-http_geoip_module \
  --http-log-path=/var/log/nginx/access.log \
  --http-client-body-temp-path=/var/lib/nginx/body \
  --http-proxy-temp-path=/var/lib/nginx/proxy \
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
  --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
  --http-scgi-temp-path=/var/lib/nginx/scgi \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-pcre-jit \
  --with-cc-opt='-O2 -fstack-protector-strong -Wformat -Werror=format-security -fPIC -D_FORTIFY_SOURCE=2' \
  --with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -fPIC' \
  --add-module=$RTMP_MODULE_DIR \
  && make -j$(nproc) \
  && make install

COPY ./entrypoint.sh /

ENV NGINX_USER=www-data \
    NGINX_LOG_DIR=/var/log/nginx \
    NGINX_TEMP_DIR=/var/lib/nginx

COPY site/* /tmp/html/

RUN mkdir videos/ && chmod 777 /videos/

COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/nginx"]
