# Repository Tracker

## Routes

- `/` -> Single-Page application with SmartTable
- `/swagger` -> Swagger UI with authorization

## Production

### Setup

1. Install current version of [docker](https://docs.docker.com/get-docker/)
   and [docker compose](https://docs.docker.com/compose/install/).
2. Change environment variables in `run_docker_compose.production.sh`. \
   **HINT**: App will start if you change nothing, but all the values are not secure and mailing will not work.
   Save those values securely, you will need them to access and run your app later. Loosing or exposing these values
   will be insecure and dangerous!
   You can create secure values with `RAILS_ENV=production bundle exec rake secret` inside container.
   Do not forget to find a backup solution for your `TRACKER_DB_DATA_FOLDER`, otherwise complete data loss is a
   possibility!
3. Change environment variables in `.env.production`.
   These two values refer to how the app is reachable from internet.
   If they are not correctly set, features like email confirmation, password reset, etc. will not work. \
   It is recommended to change the `DOORKEEPER_CLIENT_ID` with a generated hash value. In rails console, use the
   command `Doorkeeper::OAuth::Helpers::UniqueToken.generate` to generate a new and secure `client_id`.
4. Execute `run_docker_compose.production.sh`.
   If it is your first run, replace `db:migrate` with `db:setup` but do not forget to change it back later. Otherwise,
   app will not boot because it would destroy existing database.

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
11. `bundle exec rails db:setup`

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
   7. Run `spec: Repository-Tracker`


## Acknowledgments

This project has been funded by the **[DFG]**.

[![DFG Logo]][DFG]


Funded by the [Deutsche Forschungsgemeinschaft (DFG, German Research Foundation)](https://www.dfg.de/) under the [National Research Data Infrastructure – NFDI4Chem](https://nfdi4chem.de/) – Projektnummer **441958208** since 2020.


[DFG]: https://www.dfg.de/en/
[DFG Logo]: https://www.dfg.de/zentralablage/bilder/service/logos_corporate_design/logo_negativ_267.png

