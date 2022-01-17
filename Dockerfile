FROM ubuntu:16.04
RUN apt-get -y update
RUN apt-get -y install apache2
ADD index.html .
#ADD /var/lib/jenkins/workspace/Web_app index.html
RUN cat index.html > /var/www/html/index.html
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
EXPOSE 80
