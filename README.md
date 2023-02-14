# Repository Tracker

## Production
### Setup
1. Install current version of docker and docker-compose.
2. Change environment variables in run_docker-compose.production.sh. 
   HINT: App will start if you change nothing, but all the values are not secure. 
   Save those values securely, you will need them to access and run your app later. Loosing or exposing these values will be insecure and dangerous!
   You can create secure values with RAILS_ENV=production bundle exec rake secret inside container.
   Do not forget to find a backup solution for your TRACKER_DB_DATA_FOLDER, otherwise complete data loss is a possibility!
3. Edit APP_HOST and APP_PORT in .env.production. 
   These two values refer to how the app is reachable from Internet. 
   If they are not correctly set, features like email conformation, password reset, etc. will not work.
4. Execute run_docker-compose.production.sh. 
   If it is your first run replace db:migrate with db:setup, but do not forget to change it back later, otherwise app will not boot, because it would destroy existing database. 

## Development

### Setup

#### macOS

##### General

1. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
2. `brew bundle`
3. `open -a Postgres`
4. Initialize database with version 14 in GUI

##### Native

1. `asdf plugin add ruby`
2. `asdf plugin add nodejs`
3. `asdf plugin add yarn`
4. `asdf install`
5. `asdf reshim`
6. `gem update --system`
7. `asdf reshim`
8. `bundle install`
9. `yarn install`
10. `asdf reshim`

###### Testing

1. `bin/rake`

###### Starting

1. `bin/dev`

##### Containerized

1. `open -a Docker`

###### Testing

1. `./run_ci_tests.sh`

#### Editors

##### RubyMine

1. Enable options for 'Before Commit':
   1. Reformat code
   2. Rearrange code
   3. Optimize Imports
   4. Analyze code
   5. Check TODO
   6. Cleanup
   7. Run 'spec: Repository-Tracker'
