# PostgreSQL TPC-C Performence



## Summary


|    Test \ Database    |                        PostgreSQL                        |                             TiDB                             |                          Oceanbase                           |
| :-------------------: | :------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|         SPEC          |                         96C 192G                         |                          108C 510G                           |                           96C 384G                           |
|        Source         | [Vonng](https://github.com/Vonng/pgtpc/tree/master/tpcc) | [TiDB 6.1](https://docs.pingcap.com/tidb/stable/benchmark-sysbench-v6.1.0-vs-v6.0.0) | [Oceanbase](https://www.oceanbase.com/docs/community/observer-cn/V3.1.4/10000000000450311) |
|                       |                                                          |                                                              |                                                              |
|   oltp_point_select   |                         1372654                          |                            407625                            |                            401404                            |
| select_random_points  |                          227623                          |                              -                               |                                                              |
| select_random_ranges  |                          24632                           |                              -                               |                                                              |
|      oltp_insert      |                          164351                          |                              -                               |                                                              |
|      oltp_delete      |                          839153                          |                              -                               |                                                              |
|    oltp_read_only     |                          852440                          |                                                              |                            279067                            |
|    oltp_read_write    |                          519069                          |                             6223                             |                            157859                            |
|    oltp_write_only    |                          495942                          |                                                              |                            119307                            |
| oltp_update_non_index |                          217626                          |                            62084                             |                                                              |
|   oltp_update_index   |                          163359                          |                            26431                             |                                                              |





## Result: PostgreSQL 14.4 on C5D.Metal


|         mode          |  PostgreSQL |  TiDB  |
| :-------------------: |:-----------:|:------:|
|   oltp_point_select   |   1014092   | 407625 |
| oltp_update_non_index |   481838    | 62084  |
|   oltp_update_index   |   433703    | 26431  |
|    oltp_read_write    |    28135    |  6223  |

## Reference: TiDB 6.0

[TiDB 6.1 sysbench](Reference: https://docs.pingcap.com/tidb/stable/benchmark-sysbench-v6.0.0-vs-v5.4.0)

|         mode          | BEST (TPS) |
| :-------------------: | :--------: |
|   oltp_point_select   |   407625   |
| oltp_update_non_index |   62084    |
|   oltp_update_index   |   26431    |
|    oltp_read_write    |    6223    |

**Hardware Spec**

Compute power of PD + TiKV + TiDB is roughly equivalent to c5d.metal (92C 192G)

|  Service type  |  EC2 type  | Count | CPU  | Mem  | Freq |
| :------------: | :--------: | :---: | :--: | :--: | :--: |
|       PD       | m5.xlarge  |   3   |  4   |  16  | 3.1  |
|      TiKV      | i3.4xlarge |   3   |  16  | 122  | 2.3  |
|      TiDB      | c5.4xlarge |   3   |  16  |  32  | 3.4  |
| **Sum(Above)** |            |       | 108  | 510G |      |
|    Sysbench    | c5.9xlarge |   1   |  36  |  72  | 3.4  |




## Prepare Sysbench


**run queries**

`oltp_point_select`

```bash
../sysbench oltp_point_select.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-port=5432 --pgsql-user=vonng --pgsql-db=tpcc \
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