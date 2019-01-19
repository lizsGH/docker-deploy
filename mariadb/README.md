# docker-mariadb/mysql

> I want my databases (MySQL/Mariadb) automatic backup, that's all. 

In order to realize it, I can create my Dockerfile and use `CMD` or `ENTRYPOINT` directive to do it. But the official have used them.

Fortunately, the official Dockerfile (mysql/mariadb) have a convinience for us.
The official Dockerfile `ENTRYPOINT ["docker-entrypoint.sh"]` will run the script in /docker-entrypoint-initdb.d
``` bash
for f in /docker-entrypoint-initdb.d/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
        *.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done
```

## Dockerfile
``` bash
FROM mariadb:latest
MAINTAINER lizs

RUN apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
RUN apt-get install -y --no-install-recommends vim cron sudo
# setting the default editor, timezone, and permission to mysql group 
RUN echo "export EDITOR=vim" >> ~/.bashrc && \
    cat /usr/share/zoneinfo/Asia/Shanghai > /etc/localtime && \
    echo "%mysql ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/mysql && \
    chmod 440 /etc/sudoers.d/mysql

ENV INIT_DIR=/docker-entrypoint-initdb.d
# database backup directory
ENV BACKUP_DIR=/var/mysql/backups
```

## docker-compose
``` bash
version: '3'

services:
  mariadb:
    image: lizsdocker/mariadb:1.0
    # restart: always
    ports: 
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    volumes:
      - /var/docker/mariadb/initdb.d:/docker-entrypoint-initdb.d
      - /var/docker/mariadb/backups:/var/mysql/backups
```
