include .env

all: build services data

data: download extract copy

build: docker-compose.yml Dockerfile
	docker-compose build

services: docker-compose.yml
	docker-compose up -d

download: src/download.sh
	docker run -it --rm \
  		--env-file .env \
		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/download.sh

extract: src/extract.sh
	docker run -it --rm \
  		--env-file .env \
  		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/extract.sh

copy: src/copy.sh sql/schema.sql
	docker run -it --rm \
  		--env-file .env \
  		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/copy.sh

clean:
	# docker image prune
	# docker builder prune
	docker system prune -a --volumes


test:
	@echo $(LIBIO_TARGZ) 
	@echo $(LIBIO_URL) 
	@echo $(LIBIO_TARGZ) 
