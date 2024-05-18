# greenplum data replica

## How Mirror Segments Copy Data

how to set could use configuration file `postgresql.conf` to set

### WAL Replication

GreenPlum uses Write-Ahead Logging (WAL) replication to keep the mirror segments synchronized with their corresponding primary segments.
When a transaction modifies data on a primary segment, the changes are first written to the WAL. The WAL entries are then sent to the mirror segment.

### Synchronous Replication

In synchronous replication, the primary segment waits for an acknowledgment from the mirror segment that it has received and written the WAL entries before committing the transaction.
This ensures that the mirror segment has an up-to-date copy of the data at the time of the transaction commit, providing strong consistency and data protection.

### Asynchronous Replication

In asynchronous replication, the primary segment does not wait for an acknowledgment from the mirror segment before committing the transaction.
This can improve performance but introduces a slight risk of data loss if the primary segment fails before the mirror segment has fully synchronized.

### Streaming Replication

The primary segment continuously streams WAL entries to the mirror segment. This ensures that the mirror segment is updated in near real-time with minimal lag.
The mirror segment replays the WAL entries to apply the changes and keep its data consistent with the primary segment.

## WAL

on the above, the sync and async is belongs to WAL replication.

Asynchrony vs. Synchrony: WAL replication can be either asynchronous or synchronous, depending on how it is set up. Sync replicas specifically refer to those WAL replicas configured for synchronous replication.
