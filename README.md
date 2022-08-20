# Benchmark for PostgreSQL

* [pgbench](tpcb/)
* [sysbench](tpcc/)
* [TPC-H](tpch/)

----------------------

## pgbench result (tpc-b like)

s = 1000, up to 461k RO TPS & 64k RW TPS


| RO TPS                | 1     | 2      | 4      | 8      | 16     | 32      | 64      | 128     | 256     | 512     |
| --------------------- | ----- | ------ | ------ | ------ | ------ | ------- | ------- | ------- | ------- | ------- |
| Apple MBP M1 Max 2021 | 71748 | 107309 | 174629 | 200917 | 228209 | 240841  |         |         |         |         |
| Apple MBP Intel 2018  | 34715 | 63141  | 102741 | 112033 | 127438 | 113870  |         |         |         |         |
| AWS C5D.Metal s1000   | 21583 | 39309  | 91535  | 91535  | 347259 | 540355  | 689821  | 687448  | 662552  | 625849  |
| AWS C5D.Metal s5000   | 40284 | 87247  | 174382 | 346922 | 687244 | 1111431 | 1362714 | 1671769 | 1784125 | 1998580 |

![](pgbench-ro.png)



## Summary: Read Write

| RW TPS                | 1    | 2     | 4     | 8     | 16     | 32     | 64     | 128   |
| --------------------- | ---- | ----- | ----- | ----- | ------ | ------ | ------ | ----- |
| Apple MBP M1 Max 2021 | 9254 | 13201 | 21549 | 29882 | 30130  | 31903  |        |       |
| Apple MBP Intel 2018  | 3301 | 4757  |       | 15067 | 15141  | 14075  |        |       |
| AWS C5D.Metal s1000   | 2947 | 5602  | 11199 | 21607 | 36237  | 60636  | 71624  | 69629 |
| AWS C5D.Metal s5000   | 6864 | 14904 | 29481 | 57959 | 110893 | 137127 | 107960 | 93477 |

![](pgbench-rw.png)






---------------------




## Sysbench

s = 160M , PointSelect = 170K QPS , PointUpdate = 68K QPS, RW Xact = 3912 tps


|     mode \ thread     |      1       |      2       |       4       |       8       |
| :-------------------: |:------------:| :----------: | :-----------: | :-----------: |
|   oltp_point_select   | 41215 / 20µs | 80037 / 20µs | 150319 / 30µs | 170095 / 50µs |
| oltp_update_non_index | 15583 / 60µs |  31642 / 60µs | 51131 / 80µs |  67958 / 120µs  |
|   oltp_update_index   | 12703 / 80µs |  23376 / 90µs  | 37165 / 110µs | 48490 / 160µs  |
|    oltp_read_write    | 885 / 1130µs | 1370 / 1460µs | 2694/ 1480µs  | 3912/ 2040ms  |


Conpare with TiDB 6.0 on **72C / 234G** , PointSelect = 424K QPS , PointUpdate = 59K QPS, RWXact = 6029 tps

|         mode          |  300   |  600   |  900   |
| :-------------------: | :----: | :----: | :----: |
|   oltp_point_select   | 265208 | 365174 | 424031 |
| oltp_update_non_index | 40814  | 51746  | 59095  |
|   oltp_update_index   | 18187  | 22270  | 25118  |
|    oltp_read_write    |  4829  |  5693  |  6029  |








-----------------------------

## TPC-H

| Factor    | Time (s) |  Spec       |
| :-------: | :-------: | :---------: |
|     1     |     8     |  10C / 64G  |
|    10     |    56     |  10C / 64G  |
|    50     |   1327    |  10C / 64G  |
|    100    |   4835    |  10C / 64G  |

Compare with other databases:

|  Database  | TPCH Factor | Total Time (s) | Hardware Spec |                            Source                            |
| :--------: | :---------: | :------------: | :-----------: | :----------------------------------------------------------: |
| PostgreSQL |      1      |       8        |   10C / 64G   |           [Vonng](https://github.com/Vonng/pgtpc)            |
| PostgreSQL |     10      |       56       |   10C / 64G   |           [Vonng](https://github.com/Vonng/pgtpc)            |
| PostgreSQL |     50      |      1327      |   10C / 64G   |           [Vonng](https://github.com/Vonng/pgtpc)            |
| PostgreSQL |     100     |      4835      |   10C / 64G   |           [Vonng](https://github.com/Vonng/pgtpc)            |
|    TiDB    |     100     |      190       |  120C / 570G  | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
| Greenplum  |     100     |      436       |  120C / 570G  | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
|   Spark    |     100     |      388       |  120C / 570G  | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
| OceanBase  |     100     |      189       |  96C / 384G   | [OceanBase](https://open.oceanbase.com/docs/community/oceanbase-database/V3.1.0/wtu4kv) |
|  PolarDB   |     50      |      387       |  32C / 128G   | [阿里云](https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/download%2Fpdf%2F59748%2F%25E6%2580%25A7%25E8%2583%25BD%25E7%2599%25BD%25E7%259A%25AE%25E4%25B9%25A6_cn_zh-CN.pdf) |
|  PolarDB   |     50      |      755       |   16C / 64G   | [阿里云](https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/download%2Fpdf%2F59748%2F%25E6%2580%25A7%25E8%2583%25BD%25E7%2599%25BD%25E7%259A%25AE%25E4%25B9%25A6_cn_zh-CN.pdf) |
|  StoneDB   |     100     |      3388      |  64C / 128G   | [StoneDB](https://stonedb.io/docs/performance-tuning/performance-tests/OLAP/tcph-test-report) |
| ClickHouse |     100     |     11537      |  64C / 128G   | [StoneDB](https://stonedb.io/docs/performance-tuning/performance-tests/OLAP/tcph-test-report) |