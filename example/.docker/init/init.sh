#!/bin/sh

laravel_exists=0
vendor_exists=0
env_exists=0

if [ -d /var/www/html/vendor ]; then
  vendor_exists=1
fi

if [ -d /var/www/html/app ]; then
  laravel_exists=1
fi

if [ ! -f .env ]; then
  env_exists=1
fi

if [ $laravel_exists -eq 0 ]; then

    echo 'Create default Laravel project...'
    composer create-project laravel/laravel .

    echo 'Handling permissions of storage directory...'
    mkdir -p -m 777 /var/www/html/storage \
        && mkdir -p -m 777 /var/www/html/storage/framework \
        && mkdir -p -m 777 /var/www/html/storage/framework/cache \
        && mkdir -p -m 777 /var/www/html/storage/framework/cache/data \
        && mkdir -p -m 777 /var/www/html/storage/framework/sessions \
        && mkdir -p -m 777 /var/www/html/storage/framework/testing \
        && mkdir -p -m 777 /var/www/html/storage/framework/views \
        && mkdir -p -m 777 /var/www/html/storage/app \
        && mkdir -p -m 777 /var/www/html/storage/app/public \
        && mkdir -p -m 777 /var/www/html/storage/views \
        && mkdir -p -m 777 /var/www/html/storage/logs \
        && chmod -R 777 /var/www/html/storage
    chmod -R 777 /var/www/html/storage \
        && chmod -R 777 /var/www/html/bootstrap/cache

    if [ $env_exists -eq 0 ]; then
        echo 'Copy .env.example to .env'
        cp -p .env.example .env
    fi

fi

echo 'Running composer install...'
composer install

# Do this after composer install, because vendor directory must exist
if [ $env_exists -eq 0 ]; then
  if [ ! `grep "^APP_KEY=base64:.*=$" .env` ]; then
    echo 'Generate key'
    php artisan key:generate
  fi
fi

# If this is the first time, we get an error here because at this point the mysql database hasn't been setup yet.
# Maybe don't run this the first time, for example if the folder "vendor" doesn't exist yet?
if [ $vendor_exists -eq 1 ]; then
  # We need to make sure the Laravel .env file has the correct database and maildev values!
  echo 'Running migrations...'
  php artisan migrate
  if [ $? = 1 ]; then
    echo "*** MIGRATION FAILED! MAYBE YOU DIDN'T SET THE CORRECT HTDOCS/.env VALUES?  ***"
  fi
  echo 'Clearing views...'
  php artisan view:clear
else
  # Good to skip migrations the first time, because Laravel creates default migrations
  # that we maybe don't want to run.
  echo '*** First time running this container, no migrations, please run a second time to migrate! ***'
fi

echo 'Starting apache'
sudo apache2-foreground