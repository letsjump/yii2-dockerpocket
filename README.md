# yii2-dockerpocket
A set of preconfigured Docker servers made to work with your Yii2 advanced application framework or other PHP frameworks.

It includes:
- A webserver (PHP7.1, Apache2.4, composer, xdebug)
- A Database server (Mysql 5.5)
- A Redis server
- A shared folder between servers

## How to use it

1. install docker
1. open `docker-compose.yml` and fill `GITHUB_API_TOKEN`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` with your own data
1. launch your server by `docker-composer up` (add `-d` to run it in the background)
1. copy / pull your yii2 application (o create a new one) inside `application` folder
1. launch the init script by entering in the web-server bash (see above)

## how to reach your servers

- access your website by browser here http://172.17.0.3
- access your webserver console by running `docker exec -it DKP_Web_Server bash`
- access your database console by running `docker exec -it DKP_Database_Server bash`
- access your redis console by running `docker exec -it DKP_Redis_Server bash`

## Configuration access

The `docker-data` folder contains a folder for each server. You can find some configuration files inside it:
- Apache2 virtualhosts: `./docker-data/web-server/etc/apache2/sites/available/000-default.config`
- MySql configuration: `./docker-data/db-server/etc/mysql/my.cnf`

## Access the database
The database connection is set on __IP address 172.17.0.2__, port 3306. The credentials are setted in `docker-compose.yml`
Since I prefer MySql Workbench to PhpMyAdmin, I haven't included it in the configuration.

You can include it by follow the instructions explained [here](https://hub.docker.com/r/phpmyadmin/phpmyadmin/), or by download a Mysql desktop client like [MySql Workbenck](https://dev.mysql.com/downloads/workbench/).

## Use the shared folder
Any file in `./docker-data/shared-folder/` will be visible in the `/root/backup/` folder of each instanced server.
