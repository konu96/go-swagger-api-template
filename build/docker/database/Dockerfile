FROM mysql:5.7

EXPOSE 3306

ENV MYSQL_DATABASE=atplace
ENV MYSQL_ROOT_PASSWORD=atplace
ENV MYSQL_USER=atplace
ENV MYSQL_PASSWORD=atplace

COPY migrations/* /docker-entrypoint-initdb.d/
COPY my.cnf /etc/my.cnf

CMD ["mysqld"]
