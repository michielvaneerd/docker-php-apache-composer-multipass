FROM php:8-apache
#FROM php:7.4-apache

# Image with PHP8, Apache, ssmtp configured for maildev, composer
# User has been set to ubuntu:ubuntu 1000:1001 (default user of Multipass machine)

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN apt-get -y update && \
    apt-get -y autoremove && \
    apt-get install --no-install-recommends -y ssmtp zip unzip git sudo && \
    install-php-extensions bcmath pdo_mysql && \
    a2enmod rewrite && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./ssmtp.conf /etc/ssmtp/ssmtp.conf
# COPY ./vhost.conf /etc/apache2/conf-enabled/myapp.conf

RUN echo 'sendmail_path = "/usr/sbin/ssmtp -t -i"' > /usr/local/etc/php/conf.d/mail.ini

RUN groupadd -g 1001 ubuntu && \
    useradd ubuntu -u 1000 -g ubuntu -m -s /bin/bash && \
    echo "%ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ubuntu:ubuntu

# Entrypoint not in Dockerfile, because then we can't edit it without building the image again.
# Maybe after it's completed (because now we can do chmod)
# For now we do this in the docker-compose.yaml file.
#COPY ./docker-entrypoint.sh /docker-entrypoint.sh
#RUN chmod +x /docker-entrypoint.sh
#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]