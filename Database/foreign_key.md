# Foreign Keys

There are two tables:

```sql
CREATE TABLE cities (
        name     varchar(80) primary key,
        location point
);
CREATE TABLE weather (
        city      varchar(80) references cities(name),
        temp_lo   int,
        temp_hi   int,
        prcp      real,
        date      date
);
```

You want to make sure that no one can insert rows in the weather table that do not have a matching entry in the cities table. This is called maintaining the `referential integrity` of your data. In simplistic database systems this would be implemented (if at all) by first looking at the cities table to check if a matching record exists, and then inserting or rejecting the new weather records. This approach has a number of problems and is very inconvenient, so PostgreSQL can do this for you by using `references`