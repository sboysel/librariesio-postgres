include .env

all: import query

schema: sql/schema/librariesio.sql
	psql -U postgres -d librariesio < sql/schema.sql

import: src/import.sh
	./src/import.sh

query:
	date +"[%F %T %z] Begin query ... "
	psql -d librariesio \
		   -f sql/queries/deps.sql
	date +"[%F %T %z] End query ... "

clean:
	psql -U postgres -d librariesio < sql/drop.sql
