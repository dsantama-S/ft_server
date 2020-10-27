FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install nginx -y

RUN apt-get -y install mariadb-server mariadb-client

RUN apt-get -y install php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline

RUN rm -f /etc/nginx/sites-available/default && \
	rm -f /etc/nginx/sites-enabled/default

COPY ./srcs/my_default /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/my_default /etc/nginx/sites-enabled/

COPY ./srcs/index.html /var/www/html/

COPY ./srcs/phpmyadmin /var/www/html/phpmyadmin

COPY ./srcs/info.php /var/www/html/

COPY ./srcs/contenido_ind /var/www/html/contenido_ind

ENTRYPOINT service nginx start && service php7.3-fpm start && bash
