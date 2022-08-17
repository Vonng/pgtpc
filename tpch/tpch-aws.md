# TPC-H on AWS


**download dbgen**

```bash
yum install gcc

cd /data
git clone https://github.com/Vonng/pgtpc
cd pgtpc/tpch

git clone https://github.com:electrum/tpch-dbgen
cd tpch-dbgen; make -j8;
```

**prepare postgres**

```bash
pg_ctl  -D /data/pgtpch stop

rm -rf /data/pgtpch/;
initdb  -D /data/pgtpch -E UTF-8 --locale=en_US.UTF-8 --lc-collate=C
cp postgresql.auto.conf /data/pgtpch/postgresql.auto.conf
pg_ctl -D /data/pgtpch start
```

```bash
psql postgres -c 'DROP DATABASE tpch WITH (FORCE);';
psql postgres -c 'CREATE DATABASE tpch';
psql tpch -f ddl/schema.ddl;
```

**load data**

```bash
./dbgen -vf -s 100
sed 's/|$//' region.tbl    | psql tpch -c "COPY region    FROM STDIN DELIMITER '|';"
sed 's/|$//' nation.tbl    | psql tpch -c "COPY nation    FROM STDIN DELIMITER '|';"
sed 's/|$//' supplier.tbl  | psql tpch -c "COPY supplier  FROM STDIN DELIMITER '|';"
sed 's/|$//' part.tbl      | psql tpch -c "COPY part      FROM STDIN DELIMITER '|';"
sed 's/|$//' customer.tbl  | psql tpch -c "COPY customer  FROM STDIN DELIMITER '|';"
sed 's/|$//' partsupp.tbl  | psql tpch -c "COPY partsupp  FROM STDIN DELIMITER '|';"
sed 's/|$//' orders.tbl    | psql tpch -c "COPY orders    FROM STDIN DELIMITER '|';"
sed 's/|$//' lineitem.tbl  | psql tpch -c "COPY lineitem  FROM STDIN DELIMITER '|';"
```

```bash
psql tpch -f ddl/index.ddl;
```



**run query**

```bash
./run
```

