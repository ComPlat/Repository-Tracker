TRACKER_DB_DATA_FOLDER=./postgres TRACKER_DB_USERNAME=postgres TRACKER_DB_PASSWORD=postgres TRACKER_SECRET_KEY_BASE=secret_key_base docker-compose -f docker-compose.production.yml up --remove-orphans
# --abort-on-container-exit
# For debugging append to first line: --force-recreate --build
