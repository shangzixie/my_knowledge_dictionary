# WAL

is similar to the `WAL` in PostgreSQL, which is a standard method for ensuring data integrity. Briefly, WAL's central concept is that changes to data files (where tables and indexes reside) must be written only after those changes have been logged, that is, after WAL records describing the changes have been flushed to permanent storage. [WAL in postgres](/9_Database/postgreSQL/WAL.md)

## WAL Replica in Greenplum

the GP keeps the WAL Synchronize to mirror of master/coordinator.

## reference

[document](https://docs.vmware.com/en/VMware-Greenplum/7/greenplum-database/admin_guide-intro-arch_overview.html)