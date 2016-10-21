# ENROLZSH - SCRIPT BOILERPLATE v1
# ################################

PROJECT.project() { eval ABSOLUTE_LOCAL_PATH }
PROJECT.theme() { eval ABSOLUTE_LOCAL_PATH_TO_THEME }

PROJECT.bower() { PROJECT.theme && bower install & bower update }
PROJECT.npm() { PROJECT.theme && npm install && npm update }

PROJECT.gulp() { PROJECT.theme && gulp }
PROJECT.gw() { PROJECT.theme && gulp watch }

# Git pull
PROJECT.deploy() {

	if ! [ -x "$(command -v git)" ]; then
	  echo 'git is not installed.' >&2

	  # do it via rsync - just theme dir
	  return
	fi

	echo 'We can do something with git'

}

# Sync files from local to dev or live
PROJECT.files-push() {

	if [ "$1" = "live" ]; then
		read "?Confirm changes to production (live) by pressing ↵, abort with ⌃C"

	    echo "Cool, it's live"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then
	    echo "Uploading to staging..."

	    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude 'enrol/' --exclude 'wp-config.php' --exclude '.htaccess' --delete --progress ABSOLUTE_LOCAL_PATH/* SSH_USERNAME@SERVER_DOMAIN:SERVER_ABSOLUTE_DIR

	    echo "Nice, everything's copied to staging"
	fi

}

# Sync down files
PROJECT.files-pull() {

	if [ "$1" = "live" ]; then

	    echo "Sync down from live to local"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then
	    echo "Syncing from staging..."

	    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude 'enrol/' --exclude 'wp-config.php' --exclude '.htaccess' --delete --progress SSH_USERNAME@SERVER_DOMAIN:SERVER_ABSOLUTE_DIR ABSOLUTE_LOCAL_PATH

	    echo "Local and staging are in sync"
	fi

}

# Sync database from local to dev or live
PROJECT.db-push() {

	if [ "$1" = "live" ]; then
		read "?Confirm database changes on production (live) by pressing ↵, abort with ⌃C"

	    echo "Cool, your database is updated"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then
	    echo "Preparing local database..."

	    # Make db backup on staging

	    # Don't throw this into a one liner - add some feedback inside the command line
		ssh vagrant@LOCAL_DOMAIN "mysqldump -u LOCAL_DB_USER --password='LOCAL_DB_PASSWORD' --add-drop-table LOCAL_DOMAIN | sed 's/LOCAL_SEARCHREPLACE/STAGING_SEARCHREPLACE/g' | gzip -c" | ssh SSH_USERNAME@SERVER_DOMAIN "gunzip | mysql -u STAGING_USER --password='STAGING_PASSWORD' STAGING_DB_NAME"

	    echo "Magic, database imported on staging"
	fi

}

# Sync down database
PROJECT.db-pull() {

	if [ "$1" = "live" ]; then

	    echo "Sync database down from live to local"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then

		# Create a local backup
		echo "Create a local backup - have a look inside enrol/database"
		ssh vagrant@LOCAL_DOMAIN "mysqldump -u LOCAL_DB_USER --password='LOCAL_DB_PASSWORD' STAGING_DB_NAME > SERVER_ABSOLUTE_DIR/enrol/database/dump.sql"

		# Prepare and sync db
		echo "Preparing staging database..."
		ssh SSH_USERNAME@STAGING_DOMAIN "mysqldump -u STAGING_DB_USER --password='STAGING_DB_PASSWORD' --add-drop-table STAGING_DB_NAME | sed -e 's/STAGING_SEARCHREPLACE/LOCAL_SEARCHREPLACE/g' | gzip -c" | ssh vagrant@LOCAL_DOMAIN "gunzip | mysql -u LOCAL_DB_USER --password='LOCAL_DB_PASSWORD' LOCAL_DB_NAME"

		echo "Staging databse was imported inside local one."
	fi

}

# SYNC Uploads & DB
# import local db into remote + move local uploads to remote
PROJECT.push() {
	PROJECT.uploads-push $1 && PROJECT.db-push $1
}
# import remote db into local + move remote uploads to local
PROJECT.pull() {
	PROJECT.uploads-pull $1 && PROJECT.db-pull $1
}

# Create .htpassword user and password
PROJECT.htpassword-user() {
	ssh SSH_USERNAME@SERVER_DOMAIN "htpasswd /home/www/htpasswd/.htpasswd HTPASSED_USER"
}

# Activate htpasswd on staging
PROJECT.htpassword-activate() {
	ssh SSH_USERNAME@SERVER_DOMAIN "
	cd SERVER_ABSOLUTE_DIR

cat >> .htaccess <<EOF

<RequireAny>
Require group HTPASSED_GROUP
Require user HTPASSED_USER
Require ip 213.200.220.31
</RequireAny>
EOF"
}