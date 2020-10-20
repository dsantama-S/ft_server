FROM debian:buster

RUN apt-get update && apt-get upgrade -y

RUN apt-get install nginx -y

RUN rm -f /etc/nginx/sites-available/default && \
	rm -f /etc/nginx/sites-enabled/default

COPY ./srcs/my_default /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/my_default /etc/nginx/sites-enabled/

COPY ./srcs/index.html /var/www/html/

COPY ./srcs/contenido_ind /var/www/html/contenido_ind

ENTRYPOINT service nginx start && bash
