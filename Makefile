detach = no

ifeq ($(detach), yes)
	d = -d
endif

build:
	docker compose -f srcs/docker-compose.yml build

up: 
ifeq ($(B), yes)
	docker compose -f srcs/docker-compose.yml up $(d) --build
else
	docker compose -f srcs/docker-compose.yml up $(d)
endif

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker volume prune --all	

fclean: clean
	docker system prune --all
