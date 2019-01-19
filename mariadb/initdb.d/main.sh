#!/bin/bash

# Official ENTRYPOINT["docker-entrypoint.sh"] will run the script in /docker-entrypoint-initdb.d, but unordered:
# for f in /docker-entrypoint-initdb.d/*; do
# 	case "$f" in
# 		*.sh)     echo "$0: running $f"; . "$f" ;;
# 		*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
# 		*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
# 		*)        echo "$0: ignoring $f" ;;
# 	esac
# 	echo
# done
#
# So this script will be run, and this script will run the scripts in $MAIN_DIR by order.
# The scripts ($MAIN_DIR/*.sh) will be run when the script have '# order=', e.g.
# $MAIN_DIR/cron.sh:
#   #!/bin/bash
#   # order=100
#   echo 'This is a crontab script'
#
# $MAIN_DIR/backup.sh:
#   #!/bin/bash
#   # order=0
#   echo 'This is a backup script'
#
# The large value of 'sort' the script will be run prior, so backup.sh will be run prior to cron.sh.
# If the scripts ($MAIN_DIR/*.sh) don't have '# order=', they will not be run. 

# set -e

MAIN_DIR=$INIT_DIR/main.d

# put docker environment to /etc/default/locale, so that the cron can use the ENV
sudo chmod 777 /etc/default
env >> /etc/default/locale

# sorting and running the shell scripts in the directory $MAIN_DIR
if [ -d $MAIN_DIR ]; then
	# sorting the scripts ($MAIN_DIR/*.sh) by 'sort' value 
	scripts=`find $MAIN_DIR -name "*.sh" | xargs grep "# order=" -H | sort -t= -k2nr - | cut -d: -f1 | uniq`;
	echo $scripts;
	# running the script
	for i in $scripts; do
		if [ -r $i ]; then
			echo $i;
			. $i
		fi
	done
	unset i
fi

