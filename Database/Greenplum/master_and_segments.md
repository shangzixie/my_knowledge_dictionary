# master and segments

## master

master, now called coordinator ,is where the global system catalog resides. The global system catalog is the set of system tables that contain metadata about the Greenplum Database system itself. The coordinator does not contain any user data; data resides only on the segments.
