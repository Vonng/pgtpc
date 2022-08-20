# SYSBENCH RESULT FOR PGSQL @ APPLE M1 MAX


## Result: PostgreSQL 14.4 on Macbook M1 Max

SPEC: **10C / 64G**, Apple Macbook Pro M1 Max，PostgreSQL: 14.4, 20M Table x 8

|     mode \ thread     |      1       |      2       |       4       |       8       |
| :-------------------: | :----------: | :----------: | :-----------: | :-----------: |
|   oltp_point_select   | 41215 / 20µs | 80037 / 20µs | 150319 / 30µs | 170095 / 50µs |
| oltp_update_non_index | 15583 / 60µs |  31642 / 60µs | 51131 / 80µs |  67958 / 120µs  |
|   oltp_update_index   | 12703 / 80µs  |  23376 / 90µs  | 37165 / 110µs | 48490 / 160µs  |
|    oltp_read_write    | 885 / 1130µs  | 1370 / 1460µs | 2694/ 1480µs  | 3912/ 2040ms  |




## Procedure


**install sysbench**

```bash
git clone https://github.com:akopytov/sysbench
cd sysbench; ./autogen.sh
./configure --without-mysql --with-pgsql --with-system-luajit
make -j8;
sudo mv src/sysbench /usr/local/bin/sysbench-pgsql
cd src/lua
```

**init data**

Init sysbench with 16 x 10M Tables, 160M = 1.6Y Tuples.

```bash
sysbench-pgsql oltp_common.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=vonng --pgsql-password=vonng --pgsql-db=postgres --table_size=10000000 --tables=16 --threads=16 prepare
```

For write related test, reset fillfactor to 75% and perform vacuum full , analyze , prewarm after last test complete.

```sql
CREATE EXTENSION pg_prewarm;
ALTER TABLE sbtest1  SET (fillfactor=75);ALTER TABLE sbtest2  SET (fillfactor=75);ALTER TABLE sbtest3  SET (fillfactor=75);ALTER TABLE sbtest4  SET (fillfactor=75);ALTER TABLE sbtest5  SET (fillfactor=75);ALTER TABLE sbtest6  SET (fillfactor=75);ALTER TABLE sbtest7  SET (fillfactor=75);ALTER TABLE sbtest8  SET (fillfactor=75);
ALTER TABLE sbtest9  SET (fillfactor=75);ALTER TABLE sbtest10 SET (fillfactor=75);ALTER TABLE sbtest11 SET (fillfactor=75);ALTER TABLE sbtest12 SET (fillfactor=75);ALTER TABLE sbtest13 SET (fillfactor=75);ALTER TABLE sbtest14 SET (fillfactor=75);ALTER TABLE sbtest15 SET (fillfactor=75);ALTER TABLE sbtest16 SET (fillfactor=75);
VACUUM FULL VERBOSE sbtest1,sbtest2,sbtest3,sbtest4,sbtest5,sbtest6,sbtest7,sbtest8;
VACUUM FULL VERBOSE sbtest9,sbtest10,sbtest11,sbtest12,sbtest13,sbtest14,sbtest15,sbtest16;
ANALYZE VERBOSE;
CHECKPOINT;
SELECT pg_prewarm('sbtest' || i::TEXT) FROM generate_series(1,16) i;
SELECT pg_prewarm('sbtest' || i::TEXT || '_pkey') FROM generate_series(1,16) i;
SELECT pg_prewarm('k_' || i::TEXT) FROM generate_series(1,16) i;
```


**run test**

```bash
#!/bin/bash
NAME=${1-oltp_point_select}
mkdir -p /tmp/sysbench
sb="sysbench-pgsql --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=vonng --pgsql-password=vonng --pgsql-db=postgres --table_size=10000000 --tables=16 --report-interval=1 "
${sb} --time=60 --threads=1   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-1  
${sb} --time=60 --threads=2   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-2      
${sb} --time=60 --threads=3   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-3  
${sb} --time=60 --threads=4   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-4  
${sb} --time=60 --threads=5   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-5  
${sb} --time=60 --threads=6   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-6     
${sb} --time=60 --threads=7   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-7  
${sb} --time=60 --threads=8   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-8  
${sb} --time=60 --threads=9   ${NAME}.lua run 1> /tmp/sysbench/${NAME}-9  
${sb} --time=60 --threads=10  ${NAME}.lua run 1> /tmp/sysbench/${NAME}-10 
${sb} --time=60 --threads=11  ${NAME}.lua run 1> /tmp/sysbench/${NAME}-11 
${sb} --time=60 --threads=12  ${NAME}.lua run 1> /tmp/sysbench/${NAME}-12
```

```bash
./run  oltp_point_select
./run  oltp_read_only
./run  oltp_read_write
./run  oltp_write_only
./run  oltp_delete
./run  oltp_insert
./run  oltp_update_non_index
./run  oltp_update_index
./run  select_random_points
./run  select_random_ranges
```


```
oltp_point_select-1:    transactions:                        1706679 (28444.49 per sec.)
oltp_point_select-10:    transactions:                        7735524 (128606.03 per sec.)
oltp_point_select-11:    transactions:                        6277413 (104326.84 per sec.)
oltp_point_select-12:    transactions:                        5411775 (90195.27 per sec.)
oltp_point_select-2:    transactions:                        3682559 (61375.60 per sec.)
oltp_point_select-3:    transactions:                        6147925 (102464.70 per sec.)
oltp_point_select-4:    transactions:                        8628282 (143803.87 per sec.)
oltp_point_select-5:    transactions:                        9854099 (164183.73 per sec.)
oltp_point_select-6:    transactions:                        10087379 (168121.00 per sec.)
oltp_point_select-7:    transactions:                        10119908 (168663.10 per sec.)
oltp_point_select-8:    transactions:                        9926901 (165447.10 per sec.)
oltp_point_select-9:    transactions:                        8701978 (145031.60 per sec.)