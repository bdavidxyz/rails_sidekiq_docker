# Simplest possible Rails 6 + docker-compose project

This repository is intended to be the simplest possible Rails 6 + docker-compose demo.

It builds and runs a simple "hello" page locally.

Rails, Database and Webpacker are the 3 mandatory services to get things works.

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
docker-compose run --rm --no-deps web-srv rails new . --skip --database=postgresql
```

This will run the `rails new` command on our `web-srv` service defined in docker-compose.yml.

Flag explanations:
* **--no-deps** - Tells `docker-compose run` not to start any of the services in `depends_on`.
* **--skip** - Tells rails NOT to overwrite existing files, such as README or .gitignore
* **--database=postgresql** - Tells Rails to default our db config to use postgres.
* **--rm** - Removes container after run

### 3. Add artefacts

The post-build script will  :

 - add a blank welcome controller and a blank welcome page so that you have your own home page
 - change routes.rb to point to the welcome page
 - change routes.rb to add sidekiq routes
 - add sidekiq, awesome_print and run bundle install
 - add config/initializers/sidekiq.rb so that sidekiq will run properly
 - change config/database.yml so that the host prop will point to the one defined by docker
 - run db:setup db:migrate so that the development database will run properly
 - yarn add chokidar to allow a live-reload of erb files
 - set check_yarn_integrity to false if needed

```bash
$> ./dockerdev/post_build.sh
```

### 5. Start services

```
docker-compose up
```

### 6. Visit "hello world" page

go to http://localhost:3000/

 - Open the browser console to check that CSS, JS loaded correctly and no 404 request occured.
 - Check also the logs of the services in your terminal to notice that no error occured.

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
