include .env

all: import query

import: src/import.sh
	./src/import.sh

query:
	date +"[%F %T %z] Begin query ... "
	psql -d librariesio \
		   -f sql/queries/test.sql
	date +"[%F %T %z] End query ... "
