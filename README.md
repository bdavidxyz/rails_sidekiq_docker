# Rails 6, ActiveJob with Sidekiq

This repository is intended to be the simplest possible example of Rails 6 + sidekiq.

**You need only 4 basic command lines to get things work.**

Any job can be monitored at the "/sidekiq" URL.

Because multiple tools and services are needed for such a basic case, the demo uses docker and docker-compose to abstract complexity as much as possible.

It is intended to those who loves to learn by example. ❤️


## Steps to reproduce

### 0. Prerequisites

```
$> docker -v
Docker version 17.12.0-ce

$> docker-compose -v
docker-compose version 1.18.0
```

Any upper version should work.


### 1. Build images
Run :
```
docker-compose build
```

### 2. Build project

Run :
```
docker-compose run --rm --no-deps web rails new . --skip --database=postgresql
```

This will run the `rails new` command on our `web` service defined in docker-compose.yml.

Flag explanations:
* **--no-deps** - Tells `docker-compose run` not to start any of the services in `depends_on`.
* **--skip** - Tells rails NOT to overwrite existing files, such as README or .gitignore
* **--database=postgresql** - Tells Rails to default our db config to use postgres.
* **--rm** - Removes container after run

### 3. Add artefacts

The post-build script will  :

 - set check_yarn_integrity to false in config/webpacker.yml
 - add a blank welcome controller and a blank welcome page so that you have your own home page
 - change routes.rb to point to the welcome page
 - change routes.rb to add sidekiq routes
 - add sidekiq, awesome_print to the Gemfile
 - add config/initializers/sidekiq.rb so that sidekiq will run properly
 - change config/database.yml so that the host and username props will match the ones defined in Docker confs
 - adds config.active_job.queue_adapter = :sidekiq to config/application.rb

```bash
$> ./.dockerdev/post_build.sh
```


### 5. Start services

```
docker-compose up
```

See the docker-compose.yml file to see what happens when starting services.

### 6. Visit "hello world" page

 - go to http://localhost:3000/, The created welcome page should appear

 - go to http://localhost:3000/sidekiq, The created sidekiq monitoring should appear

### (optionnal) make it work on Heroku

Heroku : add redis extension, add a worker with 'heroku ps:scale web=1 worker=1', add a Procfile, check REDIS_URL env var

## Restart from scratch

removes all docker containers, images, and volumes. Warning, all data will be lost.
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q) -f
docker volume prune -f
```

remove all files generated by the "rails new" command
```
rm -rf -v !("Dockerfile"|".dockerenv"|".gitignore"|"README.md"|"docker-compose.yml") && rm .browserslistrc && rm .ruby-version
```

