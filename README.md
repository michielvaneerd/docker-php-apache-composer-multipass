# php-apache-composer-multipass

Docker image with the following properties:
- PHP
- Apache
- Composer
- Sets the user to the default Multipass user and group ubuntu:ubuntu (1000:1001)
- Uses ssmtp with port 25 and maildev host

# Setup

See example project with the following properties:
- Start apache with sudo, because we run this container as ubuntu user and otherwise we aren't allowed to use the port 80
- Installs Laravel if not present
- Does Laravel setup, like composer install, migrations, etc.