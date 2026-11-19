# PHP 7.4 is end-of-life. Use this image for isolated legacy migration ONLY.
FROM php:7.4-apache
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpng-dev libzip-dev libonig-dev \
    && docker-php-ext-install mysqli pdo_mysql mbstring gd zip \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*
COPY dev/apache-security.conf /etc/apache2/conf-available/schoolerp-security.conf
RUN a2enconf schoolerp-security && echo 'ServerName localhost' >> /etc/apache2/apache2.conf
