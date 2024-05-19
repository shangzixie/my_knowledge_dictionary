# WAL

is similar to the `WAL` in PostgreSQL, which is a standard method for ensuring data integrity. Briefly, WAL's central concept is that changes to data files (where tables and indexes reside) must be written only after those changes have been logged, that is, after WAL records describing the changes have been flushed to permanent storage. [WAL in postgres](/9_Database/postgreSQL/WAL.md)

## WAL Replica in Greenplum

Greenplum supports configuring a standby master at the time of initial cluster setup or added later. This standby master is kept up-to-date with the primary master through continuous WAL (Write-Ahead Logging) replication. The standby master is essentially a live copy of the primary master. It continuously receives WAL records from the primary master, which contain all the changes made to the system catalogs and other critical metadata.

## reference

[document](https://docs.vmware.com/en/VMware-Greenplum/7/greenplum-database/admin_guide-intro-arch_overview.html)