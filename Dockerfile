FROM httpd:2.4
COPY Barack_Obama.html /usr/local/apache2/htdocs/
COPY conf/ /usr/local/apache2/conf/
