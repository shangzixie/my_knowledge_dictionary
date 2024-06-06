# install postgres by source code

```shell
./configure
make
su
make install
adduser postgres
mkdir /usr/local/pgsql/data
chown postgres /usr/local/pgsql/data
su - postgres
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start
/usr/local/pgsql/bin/createdb test
/usr/local/pgsql/bin/psql test
```

## some issues

1. error: readline library not found:

```shell
sudo apt-get install libreadline-dev
```

2. error: zlib library not found:

```shell
sudo apt-get install zlib1g-dev
```

3. 'bison' is missing on your system.

```shell
sudo apt-get install bison -y
./configure
make
```

4. 'flex' is missing on your system

```shell
sudo apt-get install flex
./configure
make
```