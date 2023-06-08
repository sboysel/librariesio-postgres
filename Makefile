all: import

schema: sql/schema.sql
	$(PG) < $<

import: schema src/import.sh
	./$<

clean: sql/drop.sql
	$(PG) < $< 
