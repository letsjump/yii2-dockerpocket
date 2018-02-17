# Dockerfile
FROM php:7.1-apache

MAINTAINER letsjump <letsjump@gmail.com>

WORKDIR /

COPY ./docker-data/web-server /

EXPOSE 80
EXPOSE 443 

# RUN useradd -ms /dev/null dbmaker
# RUN chown -R dbmaker:dbmaker /home/dbmaker

# define build dependency lists
# inherited from PHP base image:
# PHPIZE_DEPS=autoconf 	dpkg-dev file g++ gcc libc-dev libpcre3-dev make pkg-config re2c
ENV CUSTOM_BUILD_DEPS \
            unzip \
            libmemcached-dev \
            libicu-dev \
            libfreetype6-dev \
            libjpeg-dev \
            libjpeg62-turbo-dev \
            libxml2-dev \
            zlib1g-dev

            
# list of other packages which could be deinstalled at the end
ENV CUSTOM_REMOVE_LIST cpp \
             cpp-4.9 \
             g++-4.9 \
             gcc-4.9 \
             libgcc-4.9-dev \
             libhashkit-dev \
             libsasl2-dev \
             libstdc++-4.9-dev
             
RUN apt-get update && apt-get install -my gnupg

# Install system packages for PHP extensions recommended for Yii 2.0 Framework
# Install PHP extensions required for Yii 2.0 Framework
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-key update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" install \
            $CUSTOM_BUILD_DEPS \
            $PHPIZE_DEPS \
            git \
            mysql-client \
            openssh-client \
            nano \
            linkchecker \
            nodejs \

            build-essential \

            libz-dev \
        --no-install-recommends && \
        npm -g install npm@latest && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
        docker-php-ext-configure bcmath && \
        docker-php-ext-install gd \
                               intl \
                               pdo_mysql \
                               mbstring \
                               opcache \
                               zip \
                               bcmath \
                               soap && \
        pecl install memcached-3.0.4 && \
        echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini && \
        printf "\n" | pecl install xdebug-stable
        # apt-get remove -y $PHPIZE_DEPS $CUSTOM_BUILD_DEPS $CUSTOM_REMOVE_LIST && \
        # dpkg --purge $(dpkg -l | awk '/^rc/ { print $2 }') && \
        # apt-get clean && \
        # rm -rf /usr/src/php* \
        # rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

        #set -x \
        #    && cd /usr/src/php/ext/odbc \
        #    && phpize \
        #    && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
        
# odbc
# docker-php-ext-configure odbc --with-unixODBC=/usr --with-dbmaker=/home/dbmaker/5.2 && \
        # docker-php-ext-configure odbc --with-unixODBC=/usr --with-dbmaker=/home/dbmaker/5.2 --with-adabas=no && \

# Install less-compiler
RUN npm install -g \
        less \
        lesshint \
        uglify-js \
        uglifycss

ENV PHP_USER_ID=33 \
    PHP_ENABLE_XDEBUG=1 \
    VERSION_COMPOSER_ASSET_PLUGIN=^1.4.2 \
    VERSION_PRESTISSIMO_PLUGIN=^0.3.7 \
    PATH=/var/www/:/root/.composer/vendor/bin:$PATH \
    TERM=linux \
    COMPOSER_ALLOW_SUPERUSER=1 \
    GITHUB_API_TOKEN=${GITHUB_API_TOKEN}

# Add configuration files
COPY ./docker-data/web-server /

# Add GITHUB_API_TOKEN support for composer
RUN chmod 700 \
        /usr/local/bin/docker-entrypoint.sh \
        /usr/local/bin/docker-run.sh \
        /usr/local/bin/composer

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer && \
        composer global require --optimize-autoloader \
        "fxp/composer-asset-plugin:1.4.2" \
        "hirak/prestissimo:${VERSION_PRESTISSIMO_PLUGIN}" && \
        composer global dumpautoload --optimize && \
        composer clear-cache
        
# enabling specific apache2 modules
RUN a2enmod rewrite && \
    service apache2 restart

WORKDIR /var/www

# Startup script for FPM
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
#CMD ["docker-run.sh"]
