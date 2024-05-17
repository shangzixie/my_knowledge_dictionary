# Not Null Constrain

`not null constrain` is used to control whether a column can accept NULL, you use the NOT NULL constraint:

```sql
CREATE TABLE table_name(
   ...
   column_name data_type NOT NULL,
   ...
);
```

If a column has a NOT NULL constraint, any attempt to insert or update NULL in the column will result in an error.

## reference

[postgres tutorial](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-not-null-constraint/)