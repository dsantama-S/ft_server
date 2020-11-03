FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install nginx -y

RUN apt-get -y install mariadb-server mariadb-client

RUN apt-get -y install php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline

RUN apt-get -y install openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" -keyout /etc/ssl/private/dsantama.key -out /etc/ssl/certs/dsantama.crt && \
	chmod 700 /etc/ssl/private && \
	openssl dhparam -out /etc/nginx/dhparam.pem 1000
  
RUN rm -f /etc/nginx/sites-available/default && \
	rm -f /etc/nginx/sites-enabled/default

COPY ./srcs/my_default /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/my_default /etc/nginx/sites-enabled/

COPY ./srcs/index.html /var/www/html/

COPY ./srcs/wordpress /var/www/html/wordpress

COPY ./srcs/phpmyadmin /var/www/html/phpmyadmin

COPY ./srcs/info.php /var/www/html/

COPY ./srcs/contenido_ind /var/www/html/contenido_ind

RUN chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www/html

RUN service mysql start && \
	echo "CREATE DATABASE wordpress;" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';" | mysql -u root && \
	echo "FLUSH PRIVILEGES;" | mysql -u root && \
	echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -u root

ENTRYPOINT service nginx start && service php7.3-fpm start && service mysql start && bash
