# command in PostgreSQL

* list all catalog: `\l`
* cennect catalog/database: `\c database_name`
* list all schema: `SELECT nspname FROM pg_catalog.pg_namespace;`
* list all tables: `\dt`ns
* list all tables all schemas: `\dt *.*`
* list tables in a particular schema:: `\dt public.*`
* change current schema: `set search_path to gpmetrics;`
* Viewing the path of a relation: `SELECT pg_relation_filepath('tablename');`