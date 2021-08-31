include .env
include .symfony.env.local

.PHONY: up down stop prune ps shell drush logs bash

default: up

up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose up -d --remove-orphans

up-datawarehouse:
	@echo "Starting up only pgadmin for $(PROJECT_NAME)..."
	docker-compose up -d pgadmin4

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

backup-api-db:
	@echo "Iniciando backup de BD $(API_DB_NAME)"
	@docker exec api_api_db mysqldump -u $(API_DB_USER) -p$(API_DB_PASS) $(API_DB_NAME) | gzip > $(API_DB_BACKUP_DESTINATION)/api_backup_`date +%F`.sql.gz
	@echo "Se genero el backup en $(API_DB_BACKUP_DESTINATION)"

install:
	docker exec -it $(PROJECT_NAME)_symfony curl -sS https://get.symfony.com/cli/installer | bash
	docker exec -it $(PROJECT_NAME)_symfony mv /root/.symfony/bin/symfony /usr/local/bin/symfony
	docker exec -it $(PROJECT_NAME)_symfony symfony new symfony --dir=/var/www/symfony

reload-nginx:
	docker exec -ti  $(PROJECT_NAME)_nginx nginx -s reload


