SMTP_HOST=mail.smtp2go.com\
  SMTP_PORT=2525\
  SMTP_AUTHENTICATION=plain\
  SMTP_USERNAME=smtp_username\
  SMTP_PASSWORD=smtp_password\
  TRACKER_MAIL_SENDER=sender@replace-me.de\
  TRACKER_DB_DATA_FOLDER=./postgres\
  TRACKER_DB_USERNAME=postgres \
  TRACKER_DB_PASSWORD=postgres \
  TRACKER_SECRET_KEY_BASE=secret_key_base \
  docker compose -f docker_compose.production.yml up -d --remove-orphans
# For debugging append to first line: --force-recreate --build
