# inheritance

create two tables: `cities` and `capitals`. normally, capital is also city

```sql
CREATE TABLE cities (
  name       text,
  population real,
  elevation  int     -- (in ft)
);
CREATE TABLE capitals (
  state      char(2) UNIQUE NOT NULL
) INHERITS (cities);
```
