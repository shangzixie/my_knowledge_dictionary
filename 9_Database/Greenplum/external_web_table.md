# External web tables in Greenplum

**External web tables** are one of the most useful features when you you have to load
data into a Greenplum database from different sources.

## What is an external table?

External web tables are a special type of external tables.
The keyword **web** means that they are able to access dynamic data, and they can show it to you as if they were regular database tables.
Given that data could change during every single query execution involving the web table, the Greenplum planner must avoid to choose plans that perform a complete re-scanning of the whole table.

## How to use them

There are two different types of web tables: Web URLs based and OS Command based.
With Web URL ones it is possible to create an external web table that loads data from
files on a web server. The data transmission relies on the HTTP protocol.
With the OS Command mode you can specify a shell script (or a command) to execute on any number of your cluster’s segments. The output of your script will be the data of the web table at the time of access. The command is executed in parallel on all segments by default, but you can limit that to the master node for instance.
In this article I have used the OS command mode.

## A practical scenario

Say we want to load PostgreSQL data into Greenplum using web tables.
First of all, we need to write a script that outputs the desired data.
To achieve that, we will use the power of the COPY command.
An example script would be:

```shell
#!/bin/bash
COMMAND="COPY table_name(field) TO STDOUT WITH (FORMAT CSV, DELIMITER '|', HEADER)"
psql -U user -d database -c "$COMMAND"
```

This prints the content of the *field* column of the *table_name* table on *standard output* in CSV format. In this example we will run the script on the master. Theoretically, you could copy the script on all segments, each collecting data from partitioned tables in parallel.
**IMPORTANT:** the script must be executable by the gpadmin user.
Now it is possible to create the corresponding external web table in Greenplum:

```shell
# CREATE EXTERNAL WEB TABLE ext_table ( field TEXT )
EXECUTE '/path/to/script.sh'
ON MASTER
FORMAT 'CSV';
```

Now you are ready to concretise the external data in a database table.
For that, you can use either an `INSERT INTO table SELECT * FROM ext\_table
or a CREATE TABLE table AS SELECT * FROM ext\_table`

## Conclusions

As you can imagine, this is an extremely powerful feature.
You can write a script to connect to every other DBMS and dump data or
produce live data with any programming language (for instance through RSS or Atom or XML feeds).
Feeding tables with OS script is one of my favourite features,
and I think the only limitation you have here is your imagination.
