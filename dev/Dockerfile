# PHP 7.4 is end-of-life. Use this image for isolated legacy migration ONLY.
FROM php:7.4-apache
# Avoid abandoned Debian image package repositories during the first boot smoke test.
RUN docker-php-ext-install mysqli pdo_mysql \
    && a2enmod rewrite
RUN mkdir -p /tmp/schoolerp-sessions && chown www-data:www-data /tmp/schoolerp-sessions && chmod 700 /tmp/schoolerp-sessions
ENV SCHOOLERP_SESSION_PATH=/tmp/schoolerp-sessions
WORKDIR /var/www/html/SchoolERP
COPY dev/apache-security.conf /etc/apache2/conf-available/schoolerp-security.conf
RUN a2enconf schoolerp-security && echo 'ServerName localhost' >> /etc/apache2/apache2.conf
