# yii2-dockerpocket
A set of preconfigure docker servers to work with your Yii2 advanced application framework.

It includes:
- A webserver (PHP7.1, Apache2.4, composer, xdebug)
- A Database server (Mysql 5.5)
- A redis server
- A shared folder between servers

## How to use it

- install docker
- open "docker-compose.yml" and fill "GITHUB_API_TOCKEN", "MYSQL_DATABASE", "MYSQL_USER", "MYSQL_PASSWORD" with your own data
- copy your yii2 application (o create a new one) inside `application` folder
- launch your server by `docker-composer up` (add `-d` to run it in background)

## how to reach your servers

- access your website by browser here http://172.17.0.3
- access your webserver console by running `docker exec -it DKP_Web_Server bash`
- access your database console by running `docker exec -it DKP_Database_Server bash`
- access your redis console by running `docker exec -it DKP_Redis_Server bash`
