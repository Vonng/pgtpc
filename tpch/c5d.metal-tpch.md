# PostgreSQL TPC-C Performence


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


## Prepare Tools

**download dbgen**

```bash
git clone git@github.com:electrum/tpch-dbgen.git; 
cd tpch-dbgen; make -j8;
cp -f dbgen qgen dists.dss ../
```

**prepare postgres**

```bash
pg edit-config
+    max_connections: 30
+    shared_buffers: 95GB
+    work_mem: 1GB
+    effective_cache_size: 90GB
+    autovacuums: false
+    wal_log_hints: false
+    full_page_writes: false
+    archive_command: false
```


```bash
psql postgres -c 'DROP DATABASE test WITH (FORCE);';
psql postgres -c 'CREATE DATABASE test';
psql test -f ddl/schema.ddl;
```


**load data**

```bash
./dbgen -vf -s 1
sed 's/|$//' region.tbl    | psql test -c "COPY region    FROM STDIN DELIMITER '|';"
sed 's/|$//' nation.tbl    | psql test -c "COPY nation    FROM STDIN DELIMITER '|';"
sed 's/|$//' supplier.tbl  | psql test -c "COPY supplier  FROM STDIN DELIMITER '|';"
sed 's/|$//' part.tbl      | psql test -c "COPY part      FROM STDIN DELIMITER '|';"
sed 's/|$//' customer.tbl  | psql test -c "COPY customer  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsupp.tbl  | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' orders.tbl    | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' lineitem.tbl  | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
```

```bash
SELECT monitor.pg_prewarm('')


SELECT monitor.pg_prewarm('region');   
SELECT monitor.pg_prewarm('nation');   
SELECT monitor.pg_prewarm('supplier'); 
SELECT monitor.pg_prewarm('part');     
SELECT monitor.pg_prewarm('customer'); 
SELECT monitor.pg_prewarm('partsupp'); 
SELECT monitor.pg_prewarm('orders');   
#SELECT monitor.pg_prewarm('lineitem'); 
SELECT monitor.pg_prewarm('customer_pkey');                       -- 321 MB       
SELECT monitor.pg_prewarm('lineitem_pkey');                       -- 13 GB     
SELECT monitor.pg_prewarm('nation_pkey');                         -- 16 kB     
SELECT monitor.pg_prewarm('orders_o_orderdate_idx');              -- 8192 bytes
SELECT monitor.pg_prewarm('orders_pkey');                         -- 8192 bytes
SELECT monitor.pg_prewarm('part_p_name_idx');                     -- 1382 MB   
SELECT monitor.pg_prewarm('part_pkey');                           -- 428 MB    
SELECT monitor.pg_prewarm('partsupp_pkey');                       -- 1723 MB   
SELECT monitor.pg_prewarm('region_pkey');                         -- 16 kB     
SELECT monitor.pg_prewarm('spatial_ref_sys_pkey');                -- 304 kB    
SELECT monitor.pg_prewarm('supplier_pkey');                       -- 21 MB     
SELECT monitor.pg_prewarm('supplier_s_name_idx');                 -- 47 MB     

SELECT monitor.pg_prewarm('lineitem_l_orderkey_idx');             -- 7425 MB   
SELECT monitor.pg_prewarm('lineitem_l_partkey_l_suppkey_idx');    -- 5807 MB   
SELECT monitor.pg_prewarm('lineitem_l_shipdate_idx');             -- 3967 MB

```




































**pre process data**

```bash
cp /data3/pgtpc/tpch/tpch-dbgen/lineitem.tbl /data2/
cd /data2/
split -l 10000000 lineitem.tbl lineitem.tbl
 
```

**load data**

```bash
cat lineitemaa｜ | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat lineitemaa｜ | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
```

```
sed 's/|$//' lineitem.tbl | split -l 10000000 - lineitem
split -l 10000000 orders.tbl order
split -l 10000000 partsupp.tbl partsupp

sed 's/|$//' orderaa | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderab | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderac | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderad | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderae | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderaf | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderag | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderah | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderai | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderaj | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderak | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderal | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderam | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderan | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' orderao | psql test -c "COPY orders    FROM STDIN DELIMITER '|';"

sed 's/|$//' partsuppaa | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppab | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppac | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppad | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppae | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppaf | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppag | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsuppah | psql test -c "COPY partsupp  FROM STDIN DELIMITER '|';"

cat  lineitemaa | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemab | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemac | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemad | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemae | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemaf | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemag | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemah | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemai | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemaj | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemak | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemal | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemam | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineiteman | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemao | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemap | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemaq | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemar | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemas | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemat | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemau | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemav | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemaw | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemax | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemay | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemaz | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemba | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembb | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembc | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembd | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembe | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembf | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembg | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembh | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembi | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembj | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembk | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembl | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembm | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembn | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembo | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembp | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembq | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembr | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembs | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembt | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembu | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembv | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembw | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembx | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemby | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitembz | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemca | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemcb | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemcc | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemcd | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemce | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemcf | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemcg | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemch | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"
cat  lineitemci | psql test -c "COPY lineitem  FROM STDIN DELIMITER '|';"

```