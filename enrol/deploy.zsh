# ENROLZSH - SCRIPT BOILERPLATE v1
# ################################

PROJECT.project() { ABSOLUTE_LOCAL_PATH }
PROJECT.theme() { ABSOLUTE_LOCAL_PATH_TO_THEME }

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

	    echo "Cool, it's live (LIVE_DOMAIN)"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then
	    echo "To staging (DEV_DOMAIN)"

	    # TODO: Add SSH forwarding and add some more parameter to rsync
	    rsync -r ABSOLUTE_LOCAL_PATH/* SSH_USERNAME@SERVER_DOMAIN:SERVER_ABSOLUTE_DIR
	fi

}

# Sync down files
PROJECT.files-pull() {

	if [ "$1" = "live" ]; then

	    echo "Sync down from live to local"
	fi

	if [ "$1" = "dev" ] || [ -z $1 ]; then
	    echo "From staging"

	    rsync -r SSH_USERNAME@SERVER_DOMAIN:SERVER_ABSOLUTE_DIR ABSOLUTE_LOCAL_PATH
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