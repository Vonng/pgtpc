# PostgreSQL TPC-C Performence



Tuples: 1e7 x 16 , Size: 2GB x 16 


|     mode \ thread     |  1   |  2   |  4   |  8   | 16   | 32   | 48   | 64   | 72   | 84   | 96   | 108  |
| :-------------------: | :--: | :--: | :--: | :--: | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| select_random_points  |      |      |      |      |      |      |      |      |      |      |      |      |
| select_random_ranges  |      |      |      |      |      |      |      |      |      |      |      |      |
|   oltp_point_select   |      |      |      |      |      |      |      |      | 1187720  |      |      |      |
|    oltp_read_only     |      |      |      |      |      |      |      |      |      |      |      |      |
|    oltp_read_write    |      |      |      |      |      |      |      |      |      |      |      |      |
|    oltp_write_only    |      |      |      |      |      |      |      |      |      |      |      |      |
|      oltp_delete      |      |      |      |      |      |      |      |      |      |      |      |      |
|      oltp_insert      |      |      |      |      |      |      |      |      |      |      |      |      |
| oltp_update_non_index |      |      |      |      |      |      |      |      |      |      |      |      |
|   oltp_update_index   |      |      |      |      |      |      |      |      |      |      |      |      |



```bash
sb --time=30 --threads=1   oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-1   
sb --time=30 --threads=2   oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-2   
sb --time=30 --threads=4   oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-4   
sb --time=30 --threads=8   oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-8   
sb --time=30 --threads=16  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-16  
sb --time=30 --threads=32  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-32  
sb --time=30 --threads=48  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-48  
sb --time=30 --threads=64  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-64  
sb --time=30 --threads=72  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-72  
sb --time=30 --threads=84  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-84  
sb --time=30 --threads=96  oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-96  
sb --time=30 --threads=108 oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-108 
sb --time=30 --threads=120 oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-120 
sb --time=30 --threads=256 oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-256 
sb --time=30 --threads=384 oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-384 
sb --time=30 --threads=512 oltp_point_select.lua run > /tmp/sysbench/oltp_point_select-512 



mkdir -p /tmp/sysbench
sb --time=15 --threads=96 select_random_points.lua  run > /tmp/sysbench/select_random_points.res                      
sb --time=15 --threads=96 select_random_ranges.lua  run > /tmp/sysbench/select_random_ranges.res                      
sb --time=15 --threads=96 oltp_point_select.lua     run > /tmp/sysbench/oltp_point_select.res                    
sb --time=15 --threads=96 oltp_read_only.lua        run > /tmp/sysbench/oltp_read_only.res                   
sb --time=15 --threads=96 oltp_read_write.lua       run > /tmp/sysbench/oltp_read_write.res                   
sb --time=15 --threads=96 oltp_write_only.lua       run > /tmp/sysbench/oltp_write_only.res                   
sb --time=15 --threads=96 oltp_delete.lua           run > /tmp/sysbench/oltp_delete.res                 
sb --time=15 --threads=96 oltp_insert.lua           run > /tmp/sysbench/oltp_insert.res                 
sb --time=15 --threads=96 oltp_update_non_index.lua run > /tmp/sysbench/oltp_update_non_index.res                      
sb --time=15 --threads=96 oltp_update_index.lua     run > /tmp/sysbench/oltp_update_index.res                    

```

```
oltp_point_select.res:     queries: 1,014,092
oltp_delete.res:           queries: 367,635
oltp_insert.res:           queries: 178,625
oltp_read_only.res:        queries: 705,367
oltp_read_write.res:       queries: 562,706
oltp_update_index.res:     queries: 433,703
oltp_update_non_index.res: queries: 481,838
oltp_write_only.res:       queries: 494,340
select_random_points.res:  queries: 214,814
select_random_ranges.res:  queries: 24,746


oltp_delete.res:           transactions:  367635
oltp_insert.res:           transactions:  178625
oltp_point_select.res:     transactions:  1014092
oltp_read_only.res:        transactions:  44085
oltp_read_write.res:       transactions:  28135
oltp_update_index.res:     transactions:  433703
oltp_update_non_index.res: transactions:  481838
oltp_write_only.res:       transactions:  82388
select_random_points.res:  transactions:  214814
select_random_ranges.res:  transactions:  24746

```



## Result: PostgreSQL 14.5

SPEC: **10C / 64G**, Apple Macbook Pro M1 Max，PostgreSQL: 14.4, 20M Table x 8

|     mode \ thread     |      1       |      2       |       4       |       8       |
| :-------------------: | :----------: | :----------: | :-----------: | :-----------: |
|   oltp_point_select   | 41215 / 20µs | 80037 / 20µs | 150319 / 30µs | 170095 / 50µs |
| oltp_update_non_index | 15583 / 60µs |  31642 / 60µs | 51131 / 80µs |  67958 / 120µs  |
|   oltp_update_index   | 12703 / 80µs  |  23376 / 90µs  | 37165 / 110µs | 48490 / 160µs  |
|    oltp_read_write    | 885 / 1130µs  | 1370 / 1460µs | 2694/ 1480µs  | 3912/ 2040ms  |


## Reference: TiDB 6.0

SPEC: **72C / 234G** ，3xPD 3xTiDB 3xTiKV , TiDB 6.0, 10M Table x 16

* PD: 4C 16G x 3, m5.xlarge x3
* TiKV: 4C 30G x 3, i3.4xlarge x 3
* TiDB: 16C 32G x 3, c5.4xlarge x 3
* Sysbench: c5.9xlarge x1


|         mode          |  300   |  600   |  900   |
| :-------------------: | :----: | :----: | :----: |
|   oltp_point_select   | 265208 | 365174 | 424031 |
| oltp_update_non_index | 40814  | 51746  | 59095  |
|   oltp_update_index   | 18187  | 22270  | 25118  |
|    oltp_read_write    |  4829  |  5693  |  6029  |

Reference: https://docs.pingcap.com/tidb/stable/benchmark-sysbench-v6.0.0-vs-v5.4.0





## Prepare Sysbench

**install sysbench**

```bash
brew install auto
git clone git@github.com:akopytov/sysbench.git;
cd sysbench; ./autogen.sh
./configure --without-mysql --with-pgsql --with-system-luajit
make -j8;
cd src/lua
```

**init data**

```bash
psql postgres -c 'DROP DATABASE tpcc WITH (FORCE)'; psql postgres -c 'CREATE DATABASE tpcc';
 
# init with 8 x 20M table
cd /usr/share/sysbench/
sysbench oltp_common.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=10000000 --tables=16 --threads=16 prepare
# sysbench oltp_common.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=1000000 --tables=16 --threads=16 cleanup
```



```bash
bulk_insert.lua           
oltp_common.lua           
oltp_delete.lua           
oltp_insert.lua           
oltp_point_select.lua     
oltp_read_only.lua        
oltp_read_write.lua       
oltp_update_index.lua     
oltp_update_non_index.lua 
oltp_write_only.lua       
select_random_points.lua  
select_random_ranges.lua  
```


```bash           
oltp_point_select.lua       1220269
select_random_points.lua    1082996
select_random_ranges.lua    29239
oltp_read_only.lua          50652 / 810438
oltp_read_write.lua         25400 / 508030
oltp_write_only.lua         84405 / 506510           
oltp_delete.lua             572596
oltp_insert.lua             192340
oltp_update_non_index.lua   212216
oltp_update_index.lua       191821
```


```bash
alias sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=10000000 --tables=16 --report-interval=1 "
sb --time=300 --threads=1   oltp_point_select.lua run
sb --time=300 --threads=2   oltp_point_select.lua run
sb --time=300 --threads=4   oltp_point_select.lua run
sb --time=300 --threads=8   oltp_point_select.lua run
sb --time=300 --threads=16  oltp_point_select.lua run
sb --time=300 --threads=32  oltp_point_select.lua run
sb --time=300 --threads=48  oltp_point_select.lua run
sb --time=300 --threads=64  oltp_point_select.lua run
sb --time=300 --threads=72  oltp_point_select.lua run
sb --time=300 --threads=84  oltp_point_select.lua run
sb --time=300 --threads=96  oltp_point_select.lua run
sb --time=300 --threads=108 oltp_point_select.lua run
sb --time=300 --threads=120 oltp_point_select.lua run
sb --time=300 --threads=256 oltp_point_select.lua run
sb --time=300 --threads=384 oltp_point_select.lua run
sb --time=300 --threads=512 oltp_point_select.lua run

```


**run queries**

`oltp_point_select`

```bash
sysbench oltp_point_select.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=1 --time=300 run
../sysbench oltp_point_select.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=2 --time=300 run
../sysbench oltp_point_select.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=4 --time=300 run
../sysbench oltp_point_select.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=8 --time=300 run
```

`oltp_read_write`

```bash
../sysbench oltp_read_write.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=1 --time=300 run
../sysbench oltp_read_write.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=2 --report-interval=1 --time=300 run
../sysbench oltp_read_write.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=4 --report-interval=1 --time=300 run
../sysbench oltp_read_write.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=8 --report-interval=1 --time=300 run
```


`oltp_update_index`

```bash
../sysbench oltp_update_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=1 --time=300 run
../sysbench oltp_update_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=2 --report-interval=1 --time=300 run
../sysbench oltp_update_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=4 --report-interval=1 --time=300 run
../sysbench oltp_update_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=8 --report-interval=1 --time=300 run
```


`oltp_update_non_index`

```bash
../sysbench oltp_update_non_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=1 --report-interval=1 --time=300 run
../sysbench oltp_update_non_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=2 --report-interval=1 --time=300 run
../sysbench oltp_update_non_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=4 --report-interval=1 --time=300 run
../sysbench oltp_update_non_index.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
  --table_size=20000000 --tables=8 --threads=8 --report-interval=1 --time=300 run
```




## Optimize

**Pgbouncer**

```bash
cd pgbouncer; pgbouncer pgbouncer.ini

../sysbench oltp_read_write.lua \
  --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=6432 --pgsql-user=vonng --pgsql-password=vonng --pgsql-db=tpcc --db-ps-mode=disable \
  --table_size=20000000 --tables=8 --threads=8 --report-interval=1 --time=300 run
```


**FillFactor**

```sql
ALTER TABLE sbtest1 SET (fillfactor=85);
ALTER TABLE sbtest2 SET (fillfactor=85);
ALTER TABLE sbtest3 SET (fillfactor=85);
ALTER TABLE sbtest4 SET (fillfactor=85);
ALTER TABLE sbtest5 SET (fillfactor=85);
ALTER TABLE sbtest6 SET (fillfactor=85);
ALTER TABLE sbtest7 SET (fillfactor=85);
ALTER TABLE sbtest8 SET (fillfactor=85);

VACUUM FULL VERBOSE sbtest1,sbtest2,sbtest3,sbtest4,sbtest5,sbtest6,sbtest7,sbtest8;

-- prewarm
-- CREATE EXTENSION pg_prewarm;
SELECT pg_prewarm('sbtest1');
SELECT pg_prewarm('sbtest2');
SELECT pg_prewarm('sbtest3');
SELECT pg_prewarm('sbtest4');
SELECT pg_prewarm('sbtest5');
SELECT pg_prewarm('sbtest6');
SELECT pg_prewarm('sbtest7');
SELECT pg_prewarm('sbtest8');
SELECT pg_prewarm('k_1');
SELECT pg_prewarm('k_2');
SELECT pg_prewarm('k_3');
SELECT pg_prewarm('k_4');
SELECT pg_prewarm('k_5');
SELECT pg_prewarm('k_6');
SELECT pg_prewarm('k_7');
SELECT pg_prewarm('k_8');
SELECT pg_prewarm('sbtest1_pkey');
SELECT pg_prewarm('sbtest2_pkey');
SELECT pg_prewarm('sbtest3_pkey');
SELECT pg_prewarm('sbtest4_pkey');
SELECT pg_prewarm('sbtest5_pkey');
SELECT pg_prewarm('sbtest6_pkey');
SELECT pg_prewarm('sbtest7_pkey');
SELECT pg_prewarm('sbtest8_pkey');
ANALYZE VERBOSE;
CHECKPOINT;
```