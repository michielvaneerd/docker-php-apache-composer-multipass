1. Copy .env.example to .env

2. Start with:

`docker compose up -d`

This will install Laravel if it isn't already.

3. Edit the following sections in htdocs/.env:

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

4. You can see your site at the multipass IP address, to see this IP:

multipass info $MY_MULTIPASS_INSTANCE