include .env

.DEFAULT_GOAL=build

# ENVごとにコマンドやcomposeファイル使い分けたい時に使う
#ifeq ($(PROJECT_ENV), production)
#	DC = COMPOSE_FILE=docker-compose.production.yml docker-compose
#else
#    ifeq ($(PROJECT_ENV), test)
#        DC = COMPOSE_FILE=docker-compose.test.yml docker-compose
#    else
#        DC = COMPOSE_FILE=docker-compose.development.yml docker-compose
#    endif
#endif
#project_env_check:
#	@$(eval PROJECT_ENV := $(shell read -p "ENV? (prd or stg): " ENV; echo $$ENV))
#	@echo "run command in $(PROJECT_ENV)"

DC = docker-compose

APP = docker-compose exec app
DJANGO = $(APP) python3 manage.py
CD_NGINX = cd .docker/nginx
CD_REDIS = cd .docker/redis


# コンテナ操作コマンド
.PHONY: build up build_up restart force_restart down logs clean test
build:
	$(DC) build
up:
	$(DC) up -d
build_up:
	$(DC) up -d --build
restart:
	$(DC) restart
force_restart:
	@make down
	@make build_up
down:
	$(DC) down
logs:
	$(DC) logs -f
clean:
	@docker image prune
	@docker volume prune

.PHONY: manage
get_command:
	@$(eval EXEC_COMMAND := $(shell read -p "Input command (below manage.py): " COMMAND; echo $$COMMAND))
	@echo "run manage.py $(EXEC_COMMAND)"

manage: get_command
	@$(DJANGO) $(EXEC_COMMAND)

# DB関連コマンド
.PHONY: db_makemigrations db_migrate
db_makemigrations:
	@$(DJANGO) makemigrations
db_migrate:
	@$(DJANGO) migrate
