include .env

all: build services data

data: download extract copy

build: docker-compose.yml Dockerfile
	docker-compose build

services: build docker-compose.yml sql/schema.sql
	docker-compose up -d

download: src/download.sh
	docker run -it --rm \
  		--env-file .env \
		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/download.sh

extract: download src/extract.sh
	docker run -it --rm \
  		--env-file .env \
  		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/extract.sh

copy: extract src/copy.sh sql/schema.sql
	docker run -it --rm \
  		--env-file .env \
  		--mount type=bind,source=$(LIBIO_HOME),target=/data \
		--network librariesio \
		librariesio:latest ./src/copy.sh

query:
	# PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0 \
	# 	   -f sql/queries/sample_projects_core.sql
	# PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0 \
	# 	   -f sql/queries/export_projects_core.sql \
	# 	   --csv -o $(LIBIO_HOME)/projects_core.csv
	date +"[%F %T %z] Begin query ... "
	PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0 \
		   -f sql/queries/sample_network_pre.sql
	PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0 \
		   -f sql/queries/sample_network.sql \
		   --csv -o $(LIBIO_HOME)/sample.csv
	date +"[%F %T %z] End query ... "

clean:
	# docker image prune
	# docker builder prune
	docker-compose down
	# docker rm librariesio
	# docker rm postgres
	# docker rm pgweb
	docker system prune -a --volumes


test:
	@echo $(LIBIO_TARGZ) 
	@echo $(LIBIO_URL) 
	@echo $(LIBIO_TARGZ) 

