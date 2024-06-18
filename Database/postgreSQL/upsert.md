# upsert

when you insert a new row into the table, PostgreSQL will update the row if it already exists, otherwise, it will insert the new row. That is why we call the action is upsert (the combination of update or insert).

## manually

Another clever way to do an "UPSERT" in postgresql is to do two sequential UPDATE/INSERT statements that are each designed to succeed or have no effect.

```sql
UPDATE table SET field='C', field2='Z' WHERE id=3;
INSERT INTO table (id, field, field2)
       SELECT 3, 'C', 'Z'
       WHERE NOT EXISTS (SELECT 1 FROM table WHERE id=3);
```

The UPDATE will succeed if a row with "id=3" already exists, otherwise it has no effect.

The INSERT will succeed only if row with "id=3" does not already exist.

You can combine these two into a single string and run them both with a single SQL statement execute from your application. Running them together in a single transaction is highly recommended.

## use `ON CONFLICT target action`

just support the version above of `9` in postgres

```sql
INSERT INTO table_name(column_list)
VALUES(value_list)
ON CONFLICT target action;
```


## reference

[stackvoerflow](https://stackoverflow.com/questions/1109061/insert-on-duplicate-update-in-postgresql/6527838#6527838)

[postgres tutorial](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-upsert/)