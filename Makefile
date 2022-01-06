include .env
include .symfony.env.local

.PHONY: up up-datawarehouse-only up-with-datawarehouse down down-datawarehouse-only down-with-datawarehouse stop prune ps shell drush logs bash

default: up

### Development ###
up:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose -f docker-compose.yml up -d --remove-orphans

up-datawarehouse-only:
	@echo "Starting up only datawarehouse db and pgadmin for $(PROJECT_NAME)..."
	docker-compose -f docker-compose-dw.yml up -d

up-with-datawarehouse:
	@echo "Starting up only datawarehouse db and pgadmin for $(PROJECT_NAME)..."
	docker-compose -f docker-compose.yml -f docker-compose-dw.yml up -d

force-recreate:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose pull
	docker-compose -f docker-compose.yml up -d --force-recreate --remove-orphans

down: stop
down-datawarehouse-only:stop-datawarehouse-only
down-with-datawarehouse:stop-with-datawarehouse

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml stop

stop-datawarehouse-only:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose-dw.yml stop

stop-with-datawarehouse:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-dw.yml stop

logs:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml logs -f

build:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml build

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml down -v

### Production ###
down-prod: stop-prod

up-prod:
	@echo "Starting up containers for $(PROJECT_NAME)..."
	docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d --remove-orphans

stop-prod:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml stop

logs-prod:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml logs -f

build-prod:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml build

prune-prod:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose -f docker-compose.yml -f docker-compose-prod.yml down -v

### Common ###
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
