# tablespaces

`Tablespaces` in PostgreSQL allow database administrators to define locations in the file system where the files representing database objects can be stored. Once created, a tablespace can be referred to by name when creating database objects.

## why

First, if the partition or volume on which the cluster was initialized runs out of space and cannot be extended, a tablespace can be created on a different partition and used until the system can be reconfigured.

Second, tablespaces allow an administrator to use knowledge of the usage pattern of database objects to optimize performance. For example, an index which is very heavily used can be placed on a very fast, highly available disk, such as an expensive solid state device. At the same time a table storing archived data which is rarely used or not performance critical could be stored on a less expensive, slower disk system.

## reference

[document](https://www.postgresql.org/docs/current/manage-ag-tablespaces.html#:~:text=Tablespaces%20in%20PostgreSQL%20allow%20database,name%20when%20creating%20database%20objects.)
