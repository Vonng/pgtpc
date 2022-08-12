# TPC-B

Run with different connection numbers for 1 minute, gather TPS & Latency



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
pgbench -nv -P1 -r -T60 -M prepared  -c 1 postgres
```



## Result

s = 1000, 10e8 tuples.

### Apple 2021 M1 Max 10C 64G 

|          TPS / Latency (µs)          | c=1  | c=2  | c=4  |  c=8   |  c=16  |  c=32  |
| :--------------------------------: | :--: | :--: | :--: | :----: | :----: | :----: |
| s=1000, RO, TPS | 71748 | 107309 | 174629 | 200917 | 228209 | 240841 |
| s=1000, RO, LAT | 14 | 18 | 22 | 36 | 56 | 96 |
| s=1000, RW, TPS | 9254 | 13201 | 21549 | 29882 | 30130 | 31903 |
| s=1000, RW, LAT | 108 | 151 | 184 | 264 | 516 | 953 |

### Apple 2018 Intel i9 8C 32G

|      TPS / Latency (µs)      | c=1  | c=2  | c=4  | c=8  | c=16 | c=32 |
| :----------------: | :--: | :--: | :--: | :--: | :--: | :--: |
|     s=1000, RO, TPS     | 34715 | 63141 | 102741 | 112033 | 127438 | 113870 |
|     s=1000, RO, LAT     | 29 | 31 | 38 | 65 | 101 | 239 |
| s=1000, RW, TPS | 3301 | 4757 | 412 | 15067 | 15141 | 14075 |
| s=1000, RW, LAT | 303 | 420 | 967 | 524 | 1031 | 2163 |

