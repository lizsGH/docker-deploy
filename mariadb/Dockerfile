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

COPY initdb.d $INIT_DIR/ 
# database backup directory
ENV BACKUP_DIR=/var/mysql/backups

