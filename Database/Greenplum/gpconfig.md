# gpconfig

using `gpconfig -h` to see the details in terminal. Need to note that `gpconfig` files are distributed

```text
The gpconfig utility allows you to set, unset, or view configuration
parameters from the postgresql.conf files of all instances (coordinator,
segments, and mirrors) in your Greenplum Database system. When setting
a parameter, you can also specify a different value for the coordinator if
necessary. For example, parameters such as max_connections require
a different setting on the coordinator than what is used for the segments.
If you want to set or unset a global or coordinator only parameter, use
the --masteronly or --coordinatoronly option.

gpconfig can only be used to manage certain parameters. For example,
you cannot use it to set parameters such as port, which is required
to be distinct for every segment instance. Use the -l (list) option
to see a complete list of configuration parameters supported by gpconfig.

When gpconfig sets a configuration parameter in a segment
postgresql.conf file, the new parameter setting always displays at
the bottom of the file. When you use gpconfig to remove a configuration
parameter setting, gpconfig comments out the parameter in all segment
postgresql.conf files, thereby restoring the system default setting.
For example, if you use gpconfig to remove (comment out) a parameter
and later add it back (set a new value), there will be two instances
of the parameter; one that is commented out, and one that is enabled
and inserted at the bottom of the postgresql.conf file.

After setting a parameter, you must restart your Greenplum Database
system or reload the postgresql.conf files in order for the change
to take effect. Whether you require a restart or a reload depends on
the parameter. See the Server Configuration Parameters reference for
more information about the server configuration parameters.

To show the currently set values for a parameter across the system,
use the -s option.

gpconfig uses the following environment variables to connect to
the Greenplum Database coordinator instance and obtain system
configuration information:
  * PGHOST
  * PGPORT
  * PGUSER
  * PGPASSWORD
  * PGDATABASE
```
