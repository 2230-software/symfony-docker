include .env
.PHONY: up down stop prune ps shell drush logs bash

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --remove-orphans

force-recreate:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose up -d --force-recreate --remove-orphans

down: stop

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

logs:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose logs -f

build:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose build

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v

ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

bash:
	docker exec -ti $(PROJECT_NAME)_symfony /bin/bash

bash-root:
	docker exec -ti -u root $(PROJECT_NAME)_symfony /bin/bash

install:
	docker exec -it $(PROJECT_NAME)_symfony curl -sS https://get.symfony.com/cli/installer | bash
	docker exec -it $(PROJECT_NAME)_symfony mv /root/.symfony/bin/symfony /usr/local/bin/symfony
	docker exec -it $(PROJECT_NAME)_symfony symfony new symfony --dir=/var/www/symfony



