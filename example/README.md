# Example Docker project

This will create a Docker container suitable for Laravel development.

## Steps

### The root env file

Copy `.env.example` to `.env` and change some settings if necessary.

### The htdocs/.env file

If you already have a Laravel installation in the `htdocs` directory, make sure you edit the `htdocs/.env` file accordingly. If it doesn't exist, the container will create it for you. *But you have to make sure to edit the values!*

```
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=mydb
DB_USERNAME=root
DB_PASSWORD=secret

MAIL_MAILER=smtp
MAIL_HOST=maildev
MAIL_PORT=25
MAIL_FROM_ADDRESS=somename@example.com
```

### Start the container

```
docker-compose up -d
```

If Laravel isn't present in the `htdocs` directory, the container will install an empty Laravel project.
Then it will run `composer install`.

Migrations will only run if the `vendor` directory exists before starting the container. This is because the database container isn't completed otherwise, and the migration will fail. You have to stop and start the container a second time to run the migrations. This is only the first time you run the container.

## Multipass

You can see your site at the multipass IP address. To see this IP:

```
multipass list
```

You can also edit your `hosts` file and create a hostname for this IP address.