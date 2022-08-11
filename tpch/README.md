# TPC-H 

MacBook Pro（16英寸，2021年） Apple M1 Max, 10 核心，64GB 内存， 8TB 硬盘

## Result

| Query  | 10仓 |  50仓  | 100仓  |
| :----: | :--: | :----: | :----: |
| **1**  | 3.8  |  46.3  | 102.7  |
| **2**  | 1.8  |  6.0   |  28.8  |
| **3**  | 1.2  |  26.1  | 151.1  |
| **4**  | 0.5  |  15.2  | 196.4  |
| **5**  | 0.6  |  15.9  |  51.1  |
| **6**  | 0.7  |  33.0  | 257.7  |
| **7**  | 1.3  |  30.6  | 141.8  |
| **8**  | 0.7  |  20.2  |  95.8  |
| **9**  | 2.5  | 373.5  | 1250.0 |
| **10** | 1.1  |  29.9  | 264.6  |
| **11** | 0.6  |  3.9   |  7.8   |
| **12** | 1.1  |  49.8  |  87.1  |
| **13** | 11.2 |  65.6  | 189.3  |
| **14** | 0.6  |  3.4   |  11.1  |
| **15** | 5.6  |  27.6  | 483.6  |
| **16** | 0.8  |  13.6  |  29.7  |
| **17** | 7.0  | 189.8  | 404.5  |
| **18** | 10.4 | 322.4  | 518.4  |
| **19** | 0.2  |  0.7   |  1.3   |
| **20** | 1.2  |  6.9   | 358.2  |
| **21** | 1.8  |  41.4  | 152.2  |
| **22** | 1.0  |  5.6   |  52.1  |
|  总计  | 55.7 | 1327.4 | 4835.3 |

备注，测试环境为笔记本，50仓与100仓工作集超出内存大小出现SWAP与内存压缩。

每个查询运行3次取中间值。


一些相对参考结果，注意使用的**硬件规格差异和仓数差异！**

|   数据库   | TPC-H仓数 | 总耗时(s) |  测试环境   |                             来源                             |
| :--------: | :-------: | :-------: | :---------: | :----------------------------------------------------------: |
| PostgreSQL |     1     |     8     |  10C / 64G  |                            Vonng                             |
| PostgreSQL |    10     |    56     |  10C / 64G  |                            Vonng                             |
| PostgreSQL |    50     |   1327    |  10C / 64G  |                            Vonng                             |
| PostgreSQL |    100    |   4835    |  10C / 64G  |                            Vonng                             |
| ClickHouse |    100    |   11537   | 64C / 128G  | [StoneDB](https://stonedb.io/docs/performance-tuning/performance-tests/OLAP/tcph-test-report) |
|  StoneDB   |    100    |   3388    | 64C / 128G  | [StoneDB](https://stonedb.io/docs/performance-tuning/performance-tests/OLAP/tcph-test-report) |
|    TiDB    |    100    |    190    | 120C / 570G | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
| Greenplum  |    100    |    436    | 120C / 570G | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
|   Spark    |    100    |    388    | 120C / 570G | [TiDB](https://docs.pingcap.com/zh/tidb/v5.2/v5.2-performance-benchmarking-with-tpch) |
| OceanBase  |    100    |    189    | 96C / 384G  | [OceanBase](https://open.oceanbase.com/docs/community/oceanbase-database/V3.1.0/wtu4kv) |
|  PolarDB   |    50     |    387    | 32C / 128G  | [阿里云](https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/download%2Fpdf%2F59748%2F%25E6%2580%25A7%25E8%2583%25BD%25E7%2599%25BD%25E7%259A%25AE%25E4%25B9%25A6_cn_zh-CN.pdf) |
|  PolarDB   |    50     |    755    |  16C / 64G  | [阿里云](https://static-aliyun-doc.oss-cn-hangzhou.aliyuncs.com/download%2Fpdf%2F59748%2F%25E6%2580%25A7%25E8%2583%25BD%25E7%2599%25BD%25E7%259A%25AE%25E4%25B9%25A6_cn_zh-CN.pdf) |



参考对照结果： Stone DB 和 Click House 使用 64C 256G 跑100仓的结果：

## DDL

<details>

```sql
CREATE TABLE REGION
(
    R_REGIONKEY INTEGER  NOT NULL PRIMARY KEY,
    R_NAME      CHAR(25) NOT NULL,
    R_COMMENT   VARCHAR(152)
);

CREATE TABLE NATION
(
    N_NATIONKEY INTEGER  NOT NULL PRIMARY KEY,
    N_NAME      CHAR(25) NOT NULL,
    N_REGIONKEY INTEGER  NOT NULL,
    N_COMMENT   VARCHAR(152),
    FOREIGN KEY (N_REGIONKEY) REFERENCES REGION (R_REGIONKEY)
);

CREATE TABLE PART
(
    P_PARTKEY     INTEGER        NOT NULL PRIMARY KEY,
    P_NAME        VARCHAR(55)    NOT NULL,
    P_MFGR        CHAR(25)       NOT NULL,
    P_BRAND       CHAR(10)       NOT NULL,
    P_TYPE        VARCHAR(25)    NOT NULL,
    P_SIZE        INTEGER        NOT NULL,
    P_CONTAINER   CHAR(10)       NOT NULL,
    P_RETAILPRICE DECIMAL(15, 2) NOT NULL,
    P_COMMENT     VARCHAR(23)    NOT NULL
);
CREATE INDEX ON PART (P_NAME);

CREATE TABLE SUPPLIER
(
    S_SUPPKEY   INTEGER        NOT NULL PRIMARY KEY,
    S_NAME      CHAR(25)       NOT NULL,
    S_ADDRESS   VARCHAR(40)    NOT NULL,
    S_NATIONKEY INTEGER        NOT NULL,
    S_PHONE     CHAR(15)       NOT NULL,
    S_ACCTBAL   DECIMAL(15, 2) NOT NULL,
    S_COMMENT   VARCHAR(101)   NOT NULL,
    FOREIGN KEY (S_NATIONKEY) REFERENCES NATION (N_NATIONKEY)
);
CREATE INDEX ON SUPPLIER (S_NAME);

CREATE TABLE PARTSUPP
(
    PS_PARTKEY    INTEGER        NOT NULL,
    PS_SUPPKEY    INTEGER        NOT NULL,
    PS_AVAILQTY   INTEGER        NOT NULL,
    PS_SUPPLYCOST DECIMAL(15, 2) NOT NULL,
    PS_COMMENT    VARCHAR(199)   NOT NULL,
    PRIMARY KEY (PS_PARTKEY, PS_SUPPKEY),
    FOREIGN KEY (PS_SUPPKEY) REFERENCES SUPPLIER (S_SUPPKEY),
    FOREIGN KEY (PS_PARTKEY) REFERENCES PART (P_PARTKEY)
);

CREATE TABLE CUSTOMER
(
    C_CUSTKEY    INTEGER        NOT NULL PRIMARY KEY,
    C_NAME       VARCHAR(25)    NOT NULL,
    C_ADDRESS    VARCHAR(40)    NOT NULL,
    C_NATIONKEY  INTEGER        NOT NULL,
    C_PHONE      CHAR(15)       NOT NULL,
    C_ACCTBAL    DECIMAL(15, 2) NOT NULL,
    C_MKTSEGMENT CHAR(10)       NOT NULL,
    C_COMMENT    VARCHAR(117)   NOT NULL,
    FOREIGN KEY (C_NATIONKEY) REFERENCES NATION (N_NATIONKEY)
);

CREATE TABLE ORDERS
(
    O_ORDERKEY      INTEGER        NOT NULL PRIMARY KEY,
    O_CUSTKEY       INTEGER        NOT NULL,
    O_ORDERSTATUS   CHAR(1)        NOT NULL,
    O_TOTALPRICE    DECIMAL(15, 2) NOT NULL,
    O_ORDERDATE     DATE           NOT NULL,
    O_ORDERPRIORITY CHAR(15)       NOT NULL,
    O_CLERK         CHAR(15)       NOT NULL,
    O_SHIPPRIORITY  INTEGER        NOT NULL,
    O_COMMENT       VARCHAR(79)    NOT NULL,
    FOREIGN KEY (O_CUSTKEY) REFERENCES CUSTOMER (C_CUSTKEY)
);
CREATE INDEX ON ORDERS (O_ORDERDATE);

CREATE TABLE LINEITEM
(
    L_ORDERKEY      INTEGER        NOT NULL,
    L_PARTKEY       INTEGER        NOT NULL,
    L_SUPPKEY       INTEGER        NOT NULL,
    L_LINENUMBER    INTEGER        NOT NULL,
    L_QUANTITY      NUMERIC(15, 2) NOT NULL,
    L_EXTENDEDPRICE NUMERIC(15, 2) NOT NULL,
    L_DISCOUNT      NUMERIC(15, 2) NOT NULL,
    L_TAX           NUMERIC(15, 2) NOT NULL,
    L_RETURNFLAG    CHAR(1)        NOT NULL,
    L_LINESTATUS    CHAR(1)        NOT NULL,
    L_SHIPDATE      DATE           NOT NULL,
    L_COMMITDATE    DATE           NOT NULL,
    L_RECEIPTDATE   DATE           NOT NULL,
    L_SHIPINSTRUCT  CHAR(25)       NOT NULL,
    L_SHIPMODE      CHAR(10)       NOT NULL,
    L_COMMENT       VARCHAR(44)    NOT NULL
    PRIMARY KEY (L_ORDERKEY, L_LINENUMBER),
    -- FOREIGN KEY (L_ORDERKEY) REFERENCES ORDERS (O_ORDERKEY)
    -- FOREIGN KEY (L_PARTKEY, L_SUPPKEY) REFERENCES PARTSUPP (PS_PARTKEY, PS_SUPPKEY)
);
CREATE INDEX ON LINEITEM (L_PARTKEY, L_SUPPKEY);
CREATE INDEX ON LINEITEM (L_ORDERKEY);
CREATE INDEX ON LINEITEM (L_SHIPDATE);
```

</details>


## Config

<details>
<summary>postgresql.auto.conf</summary>

```ini
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
max_connections = 30 
shared_buffers = 54GB
maintenance_work_mem = 30GB
effective_cache_size = 10GB
work_mem = 1024MB

max_worker_processes = 10
max_parallel_workers = 10
max_parallel_workers_per_gather = 10
max_parallel_maintenance_workers = 4
max_prepared_transactions = 100
max_locks_per_transaction = 256

# wal
wal_level = 'replica'
wal_log_hints = off
wal_buffers = 16MB
wal_keep_size = 1GB
max_wal_size = 200GB
min_wal_size = 1GB
wal_receiver_status_interval = 1s
wal_receiver_timeout = 60s
wal_writer_delay = 20ms
wal_writer_flush_after = 1MB

# bgwriter
bgwriter_delay = 10ms
bgwriter_lru_maxpages = 800
bgwriter_lru_multiplier = 5.0
checkpoint_completion_target = 0.9
checkpoint_timeout = 15min
commit_delay = 20
commit_siblings = 10

# misc
cluster_name = 'pg-meta'
deadlock_timeout = 50ms
hot_standby = on
hot_standby_feedback = on
huge_pages = try
password_encryption = md5
max_replication_slots = 10
max_standby_archive_delay = 10min
max_standby_streaming_delay = 3min
max_wal_senders = 10

# logging
log_checkpoints = on
log_destination = 'csvlog'
log_filename = 'postgresql-%Y-%m-%d.log'
log_lock_waits = on
log_min_duration_statement = 100
log_replication_commands = on
log_statement = 'ddl'
logging_collector = on
track_activity_query_size = 4096
track_commit_timestamp = on
track_functions = all
track_io_timing = on

# planner
random_page_cost = 1.1
default_statistics_target = 2048

# auto vacuum
autovacuum = off
vacuum_cost_delay = 10ms
vacuum_cost_limit = 10000
vacuum_defer_cleanup_age = 50000
autovacuum_freeze_max_age = 1000000000
autovacuum_max_workers = 1
autovacuum_naptime = 1min
autovacuum_vacuum_cost_delay = -1
autovacuum_vacuum_cost_limit = -1
log_autovacuum_min_duration = 1s
```

<details>


## Prepare Tools

**download dbgen**

```bash
git clone git@github.com:electrum/tpch-dbgen.git; 
cd tpch-dbgen; make -j8;
cp -f dbgen qgen dists.dss ../
```

**prepare postgres**

```bash
/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpch stop

rm -rf ~/pgtpch/;
/usr/local/pgsql/bin/initdb  -D ~/pgtpch -E UTF-8 --locale=en_US.UTF-8 --lc-collate=C
cp postgresql.auto.conf ~/pgtpch/postgresql.auto.conf
/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpch start
```

```bash
psql postgres -c 'DROP DATABASE tpch WITH (FORCE);';
psql postgres -c 'CREATE DATABASE tpch';
psql tpch -f ddl/schema.ddl;
```


**load data**

```bash
./dbgen -vf -s 1
sed 's/|$//' region.tbl    | psql tpch -c "COPY region    FROM STDIN DELIMITER '|';"
sed 's/|$//' nation.tbl    | psql tpch -c "COPY nation    FROM STDIN DELIMITER '|';"
sed 's/|$//' supplier.tbl  | psql tpch -c "COPY supplier  FROM STDIN DELIMITER '|';"
sed 's/|$//' part.tbl      | psql tpch -c "COPY part      FROM STDIN DELIMITER '|';"
sed 's/|$//' customer.tbl  | psql tpch -c "COPY customer  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsupp.tbl  | psql tpch -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' orders.tbl    | psql tpch -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' lineitem.tbl  | psql tpch -c "COPY lineitem  FROM STDIN DELIMITER '|';"
```

**run query**

```bash
#!/bin/bash
mkdir -p result
echo "| Query  | Time |"
echo "| -----  | ---- |"
for i in {1..22}
do
    for j in {1..3}
    do
        psql tpch -f queries/$i.sql -o result/$i.$j ;
        elapse=$(cat result/$i.$j | grep Execution | grep -Eo '(\d+).\d+ ms') ;
        echo "$i,'${elapse}'";
    done
done
```


## Queries

使用 QGEN 默认替换生成标准的TPCH22个查询，按照 PostgreSQL 语法进行适配性修改（LIMIT，INTERVAL 语句），这里略过。