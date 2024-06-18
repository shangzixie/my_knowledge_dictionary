# Fill Factor

Fill Factor is directly related to Indexes.

## what is fill factor and what is the best value for it

Fill factor is the value that determines the percentage of space on each leaf-level page to be filled with data. In an SQL Server, the smallest unit is a page, which is made of  Page with size 8K. Every page can store one or more rows based on the size of the row. The default value of the Fill Factor is 100, which is same as value 0. The default Fill Factor (100 or 0) will allow the SQL Server to fill the leaf-level pages of an index with the maximum numbers of the rows it can fit. There will be no or very little empty space left in the page, when the fill factor is 100.

If the page is completely filled and new data is inserted in the table which belongs to completely filled page, the `page split` event happens to accommodate new data. When new data arrives, SQL Server has to accommodate the new data, and if it belongs to the page which is completely filled, SQL Server splits the page in two pages dividing the data in half. This means a completely filled page is now two half-filled pages. Once this page split process is over, the new data is inserted at its logical place. This page split process is expensive in terms of the resources. As there is a lock on the page for a brief period as well, more storage space is used to accommodate small amounts of data. The argument usually is that it does not matter as storage is cheaper now a day. Let us talk about Fill Factor in terms of IO in the next paragraph.

## fill factor in B-Tree

 For B-trees, leaf pages are filled to this `fill factor percentage` during initial index build, and also when extending the index at the right (adding new largest key values). If pages subsequently become completely full, they will be split, leading to gradual degradation in the index's efficiency

## reference

[blog](https://www.itprotoday.com/sql-server/what-fill-factor-index-fill-factor-and-performance-part-1)
