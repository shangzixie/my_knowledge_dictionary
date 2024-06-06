# QUOTE_LITERAL(string)

quote string use ''

```sql
select quote_literal(catid), catname
from category
order by 1,2;

quote_literal |  catname
--------------+-----------
'1'           | MLB
'10'          | Jazz
'11'          | Classical
'2'           | NHL
'3'           | NFL
'4'           | NBA
'5'           | MLS
'6'           | Musicals
'7'           | Plays
'8'           | Opera
'9'           | Pop
(11 rows)
```

## QUOTE_IDENT(string)

quote string use ""

## QUOTE_NULLABLE(string)

Like QUOTE_LITERAL, QUOTE_NULLABLE sets off string values with single quotes, including empty strings. Unlike QUOTE_LITERAL, QUOTE_NULLABLE outputs NULL for null values:

```sql
=> SELECT QUOTE_NULLABLE (fname) "First Name", QUOTE_NULLABLE (lname) "Last Name", band FROM lead_vocalists ORDER BY fname DESC;
 First Name | Last Name |                      band
------------+-----------+-------------------------------------------------
 NULL       | 'Cher'    | ["Sonny and Cher"]
 'Stevie'   | 'Winwood' | ["Spencer Davis Group","Traffic","Blind Faith"]
 'Mick'     | 'Jagger'  | ["Rolling Stones"]
 'Grace'    | 'Slick'   | ["Jefferson Airplane","Jefferson Starship"]
 'Diana'    | 'Ross'    | ["Supremes"]
 ''         | 'Sting'   | ["Police"]
(6 rows)
```