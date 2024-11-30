# schema

## star schema

The name “star schema” comes from the fact that when the table relationships are
visualized,  the  fact  table  is  in  the  middle,  surrounded  by  its  dimension  tables;  the
connections to these tables are like the rays of a star.
![126](/Image/database/126.png)

## snowflake schema

A variation of this template is known as the snowflake schema, where dimensions are further broken down into sub-dimensions. For example, there could be separate tables for brands and product categories, and each row in the  dim_product  table could reference the brand and category as foreign keys, rather than storing them as strings in the  dim_product  table. Snowflake schemas are more normalized than star schemas, but star schemas are often preferred because they are simpler for analysts to work with

## reference

[DDIA](https://github.com/shangzixie/ddia/blob/main/ch3.md)