# Load Libraries.io data in Postgres

Load an offline copy of the Libraries.io database into a Dockerized Postgres
instance.

## dependencies

```
docker
docker-compose
make
```

## usage

```
git clone git@github.com:sboysel/librariesio-docker.git
cd librariesio-docker
```

Edit `.env` and `.envrc` to set `$LIBIO_HOME` as the directory in which the
Libraries.io archive and component CSVs will live.  The archive is downloaded if
not already present in this directory.  All component CSVs are extracted and
processed here.

In repository root, run GNU make to build the application container, bring up
services, and run the application (download, extract, copy CSV to post
)
```bash
make
```

Use visit pgweb UI in browser at [0.0.0.0:8081](0.0.0.0:81) or use `psql` to
connect to `postgres` instance
```bash
PGPASSWORD=postgres psql -U postgres -d librariesio -h 0.0.0.0
```

Run queries

```bash
make query
```

## todo

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

