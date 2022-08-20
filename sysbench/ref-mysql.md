# Reference MySQL Rouge Test

DAMN, MySQL publish a **shameless** benchmark result based on MySQL 8.0

https://www.mysql.com/cn/why-mysql/benchmarks/mysql/

It just turns off checksum, double write, binlog, PFS, and fsync and use latin-1 charset. 

Which makes it a toy and impossible to use in real-world production environment.

http://dimitrik.free.fr/blog/posts/mysql-performance-80-and-sysbench-oltp_rw-updatenokey.html 



But we can do it to postgres too and see how far it goes.



## Compare

400M Tuples. MySQL & PostgreSQL Extreme Performence

|     Database      |   mysql-8   |  pgsql-14   |  pgsql-14   |  pgsql-14  |
| :---------------: | :---------: | :---------: | :---------: | :--------: |
|     Configure     | extreme.48C | extreme.48C | extreme.96c | common.96C |
| oltp_point_select |   1050000   |   1296712   |   1998580   |  1372654   |
|  oltp_read_only   |             |             |             |   852440   |
|  oltp_read_write  |   500000    |             |             |   519069   |
|  oltp_write_only  |             |             |             |   495942   |
|    oltp_delete    |             |             |             |   839153   |
|    oltp_insert    |   240000    |             |             |   164351   |
