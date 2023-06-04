# Load Libraries.io data in Postgres

Load an offline copy of the Libraries.io database into a Dockerized Postgres
instance.

## Data Source

Jeremy Katz. (2020). Libraries.io Open Source Repository and Dependency Metadata (1.6.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.3626071

## Setup

### Dependencies

- `docker`
- `docker-compose`
- `make`

### Environment

- `LIBIO_URL=https://zenodo.org/record/3626071/files/libraries-1.6.0-2020-01-12.tar.gz`
- `LIBIO_TARGZ=libraries-1.6.0-2020-01-12.tar.gz`
- `LIBIO_HOME=/mnt/storage/librariesio`

Edit `.env` (for Docker, required) and `.envrc` (for direnv,
optional) to set `$LIBIO_HOME` as the directory in which the
Libraries.io archive and component CSVs will live.  The archive is
downloaded if not already present in this directory.  All component
CSVs are extracted and processed here.

### Usage

```
git clone git@github.com:sboysel/librariesio-docker.git
cd librariesio-docker
make
```

The default Makefile will build the application container, bring up
services, and run the application (download, extract, copy CSV to
post).  Visit [0.0.0.0:8081](0.0.0.0:8181) in a web browser or use
`psql` to connect to the Dockerized `postgres` instance

```bash
PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0
```

- [x] Sort out CSV formatting issues in `repositories` table
- [x] Create approproiate indexes
- [ ] Write up

## references

- https://zenodo.org/record/3626071#.YprimnXMJQJ
- https://zenodo.org/record/3626071/files/libraries-1.6.0-2020-01-12.tar.gz?download=1
- https://geshan.com.np/blog/2021/12/docker-postgres/
- https://herewecode.io/blog/create-a-postgresql-database-using-docker-compose/
- https://graspingtech.com/docker-compose-postgresql/
- https://thedatasoup.com/data-ingestion-running-a-pipeline-with-python-postgres-and-pgadmin-using-docker/
- https://hub.docker.com/r/sosedoff/pgweb/

