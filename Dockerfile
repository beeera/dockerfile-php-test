# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM php:7.0-fpm

MAINTAINER Anders Berre <anders.berre@gmail.com>

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    nginx

ADD docker/nginx.conf /etc/nginx/
ADD docker/web.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/web.conf /etc/nginx/sites-enabled/web
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /var/www/

COPY /app /var/www

RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data *

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN "date"

RUN chmod +x ./start.sh

EXPOSE 1337

ENTRYPOINT ["./start.sh"]
