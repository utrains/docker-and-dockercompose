FROM ubuntu:18.04
RUN apt-get update -y
RUN apt-get install -y nginx
VOLUME /var/www/html/
ENTRYPOINT ["nginx", "-g", "daemon off;"]