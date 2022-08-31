# command in PostgreSQL

## get info

* list all catalog/database: `\l`
* connect catalog/database: `\c database_name`
* list all schema: `SELECT nspname FROM pg_catalog.pg_namespace;`
* list all tables: `\dt`ns
* list all tables all schemas: `\dt *.*`
* list tables in a particular schema:: `\dt public.*`
* change current schema: `set search_path to gpmetrics;`
* Viewing the path of a relation: `SELECT pg_relation_filepath('tablename');`
* list all users: `\du`
* current user is: `\conninfo`
* create super role: `CREATE USER username SUPERUSER;`
`CREATE USER username WITH SUPERUSER PASSWORD 'passwordstring';`
* clean all data from table: `TRUNCATE TABLE `

## basic operate

* insert info: `INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);`
