# TPC-B





## Procedure

Use `pgbench` for tpc-b benchmark.

```bash
cd tpcb
make init                 # init a local postgres cluster
SCALE=1000 make i         # init tpc-b with 1000 scale factor

make r1
make r2
make r4
make r8
make r16
make r32
make w1
make w2
make w4
make w8
make w16
make w32
```

**prepare postgres**

```bash
/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpcb stop ; rm -rf ~/pgtpcb/;
/usr/local/pgsql/bin/initdb  -D ~/pgtpcb -E UTF-8 --locale=en_US.UTF-8 --lc-collate=C
cp postgresql.auto.conf ~/pgtpcb/postgresql.auto.conf
/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpcb start
```

```bash
pgbench -is 1000 postgres
pgbench -nv -P1 -r --select-only -T60 -M prepared  -c 1 postgres
pgbench -nv -P1 -r -T60 -M prepared  -c 1 postgres
```



## Result

|          Throughput (TPS)          | c=1  | c=2  | c=4  | c=8  | c=16 | c=32 |
| :--------------------------------: | :--: | :--: | :--: | :--: | :--: | :--: |
| Apple 21 M1 MAX 10C64G, s=1000, RO |      |      |      |      |      |      |
| Apple 21 M1 MAX 10C64G s=1000, RW  |      |      |      |      |      |      |
|     Apple 19 8C32G, s=1000, RO     |      |      |      |      |      |      |
|     Apple 19 8C32G s=1000, RW      |      |      |      |      |      |      |



|      Latencya (µs)      | c=1  | c=2  | c=4  | c=8  | c=16 | c=32 |
| :----------------: | :--: | :--: | :--: | :--: | :--: | :--: |
| Apple 21 M1 MAX 10C64G, s=1000, RO | 15 |      |      |      |      |      |
| Apple 21 M1 MAX 10C64G s=1000, RW  |      |      |      |      |      |      |
|     Apple 19 8C32G, s=1000, RO     |      |      |      |      |      |      |
|     Apple 19 8C32G s=1000, RW      |      |      |      |      |      |      |

