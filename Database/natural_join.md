# join

## natural join

The natural join operation operates on two relations and produces a relation as the result. Unlike the Cartesian product of two relations, which concatenates each tuple of
the first relation with every tuple of the second, natural join considers only those pairs of tuples with the same value on those attributes that appear in the schemas of both
relations

## join ... using

```sql
select name, title
from (student natural join takes) join course using (course id);
```

Consider the operation: **r~1~ join r~2~ using(A~1~, A~2~)**. The operation is similar to **r~1~ natural join r~2~**, except that a pair of tuples t1 from r1 and t2 from r2 match if t1.A1 = t2.A1 and t1.A2 = t2.A2; even if r1 and r2 both have an attribute named A3, it is not required that t1.A3 = t2.A3