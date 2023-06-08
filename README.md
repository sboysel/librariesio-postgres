# Load Libraries.io data in Postgres

Load an offline copy of the [Libraries.io](https://libraries.io/) database into a Postgresql.

## Data Source

Jeremy Katz. (2020). Libraries.io Open Source Repository and Dependency Metadata (1.6.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.3626071

## Usage 

### Setup: Dependencies and Environment Variables

- `postgresql` (script assumes user `postgres` can write to a local database `librariesio`)
- `curl`
- `make`

See `.envrc` for required environment variables. 

```
export WORKDIR=$HOME"/data/librariesio"
export TARGZ="libraries-1.6.0-2020-01-12.tar.gz"
export URL="https://zenodo.org/record/3626071/files/"$TARGZ
export PG="psql -U postgres -d librariesio"
export DATASETS=("dependencies" "projects" "projects_with_repository_fields"
   "repositories" "repository_dependencies" "versions" "tags")
```

In particular, `WORKDIR` is the directory where the Libraries.io archive will
be downloaded and individual CSV datasets will be extracted.

### Load Database

Download archive, extract individual datasets, and load the data into
Postgres:

```
make
```

## References

- [Libraries.io data documentation](https://libraries.io/data)
