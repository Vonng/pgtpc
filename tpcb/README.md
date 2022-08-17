# TPC-B

Run with different connection numbers for 1 minute, gather TPS & Latency



## Summary

s = 1000, Read Only TPS

|           TPS            |  c=1  |  c=2   |  c=4   |  c=8   |  c=16  |  c=32  |
| :----------------------: | :---: | :----: | :----: | :----: | :----: | :----: |
| Apple M1 Max 21 / 10C64G | 71748 | 107309 | 174629 | 200917 | 228209 | 240841 |
| Apple Macbook 18 / 8C32G | 34715 | 63141  | 102741 | 112033 | 127438 | 113870 |
|    c5d.xlarge / 4C8G     | 6442  | 10293  |  9997  | 10013  |  8903  |  8467  |
|  z1d.2xlarge / 48C384G   |       |        |        |        |        |        |
|   c5d.metal / 96C192G    |       |        |        |        |        |        |

s = 1000, Read Write TPS

|           TPS            | c=1  |  c=2  |  c=4  |  c=8  | c=16  | c=32  |
| :----------------------: | :--: | :---: | :---: | :---: | :---: | :---: |
| Apple M1 Max 21 / 10C64G | 9254 | 13201 | 21549 | 29882 | 30130 | 31903 |
| Apple Macbook 18 / 8C32G | 3301 | 4757  |  412  | 15067 | 15141 | 14075 |
|    c5d.xlarge / 4C8G     | 634  | 1132  | 2152  | 2938  | 3524  | 3831  |
|   z1d.metal / 48C384G    |      |       |       |       |       |       |
|   c5d.metal / 96C192G    |      |       |       |       |       |       |

s = 1000, Read Write TPS





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



## Detailed Result

s = 1000, 10e8 tuples.

### Apple 2021 M1 Max 10C 64G 

Max CPU Speed: 3.2 GHz, NVME SSD 8TB

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
| s=1000, RW, TPS | 3301 | 4757 |  | 15067 | 15141 | 14075 |
| s=1000, RW, LAT | 303 | 420 |  | 524 | 1031 | 2163 |

### AWS z1d 2xlarge 8C64G 4GHz

CPU 4GHz, NVME SSD 300GB

| TPS / Latency (µs) |  c=1  |  c=2  |  c=4   |  c=8   |  c=16  |  c=32  |
| :----------------: | :---: | :---: | :----: | :----: | :----: | :----: |
|  s=1000, RO, TPS   | 42103 | 80807 | 113047 | 134714 | 156984 | 162315 |
|  s=1000, RO, LAT   |  24   |  25   |   35   |   51   |   81   |  149   |
|  s=1000, RW, TPS   | 5270  | 9743  | 15150  | 19010  | 22702  | 24808  |
|  s=1000, RW, LAT   |  190  |  205  |  263   |  415   |  691   |  1247  |

### AWS c5d.metal 96C 192G

CPU  3.6G Hz, NVME SSD 4 x 900 GB

| TPS / Latency (µs) | c=1  | c=2  | c=4  | c=8  | c=16 | c=32 |
| :----------------: | :--: | :--: | :--: | :--: | :--: | :--: |
|  s=1000, RO, TPS   |      |      |      |      |      |      |
|  s=1000, RO, LAT   |      |      |      |      |      |      |
|  s=1000, RW, TPS   |      |      |      |      |      |      |
|  s=1000, RW, LAT   |      |      |      |      |      |      |

thanks. BTW, Is this the correct ticket if I wish to launch several large EC2 instance? E.g c5d.metal 96C 192G or x1.32xlarge ...



### AWS c5d.xlarge 4C8G

CPU 3.4GHz, NVME SSD 100GB

| TPS / Latency (µs) | c=1  |  c=2  | c=4  |  c=8  | c=16 | c=32 |
| :----------------: | :--: | :---: | :--: | :---: | :--: | :--: |
|  s=1000, RO, TPS   | 6442 | 10293 | 9997 | 10013 | 8903 | 8467 |
|  s=1000, RO, LAT   | 155  |  194  | 393  |  789  | 1787 | 3763 |
|  s=1000, RW, TPS   | 634  | 1132  | 2152 | 2938  | 3524 | 3831 |
|  s=1000, RW, LAT   | 1573 | 1762  | 1851 | 2707  | 4493 | 4960 |

### 
