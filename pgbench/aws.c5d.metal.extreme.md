# AWS c5d.metal (EXTREME RECORD)

96 vCPU x 3.6 GHz , 192 GB Memory , 900GB x 4 NVME SSD

s = 4000, 400M Records, 64GB , test under extreme condition.

HugePage 2MB x 70000

| clients  | s=4000, RW | s=4000, RO |
|:--------:|:----------:|:----------:|
|    1     |    6864    |   40284    |
|    2     |   14904    |   87247    |
|    4     |   29481    |   174382   |
|    8     |   57959    |   346922   |
|    16    |   110893   |   687244   |
|    24    |   129063   |  1006202   |
|    32    |   137127   |  1111431   |
|    40    |   123457   |  1209933   |
|    48    |   119356   |  1296712   |
|    64    |   107960   |  1362714   |
|    96    |   100168   |  1539603   |
|   128    |   93477    |  1671769   |
|   192    |   84544    |  1718048   |
|   256    |   79073    |  1784125   |
|   384    |   71686    |  1877568   |
|   512    |   66042    |  1975253   |
|   555    |   64672    |  1998580   |


Typical performance :

* Read Only (Point Select) : [130w @ 48c](/Users/vonng/dev/pgtpc/pgbench/c5d-metal-extreme/ro-48)
* Read Only (Point Select) : [200w @ 96c](/Users/vonng/dev/pgtpc/pgbench/c5d-metal-extreme/ro-555)
* Read Write : 137127 @ 32c



## Prepare

Same as c5d-metal.md , but use [postgresql-extreme](postgresql-extreme.auto.conf] conf instead.


```bash
export PGURL=postgres
export PGURL="postgres://test:test@10.10.10.11/test"
pgbench -is 4000 -F 95 ${PGURL}
psql ${PGURL} -c "CREATE EXTENSION pg_prewarm";
psql ${PGURL} -c "SELECT pg_prewarm('pgbench_accounts');";
psql ${PGURL} -c "SELECT pg_prewarm('pgbench_branches');";
psql ${PGURL} -c "SELECT pg_prewarm('pgbench_history');";
psql ${PGURL} -c "SELECT pg_prewarm('pgbench_tellers');";
psql ${PGURL} -c "SELECT pg_prewarm('pgbench_accounts_pkey');";
```

```bash
# Read Only Queries
export RES=/tmp/pgbench
export PGURL="test"
mkdir -p ${RES}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 1   -c 1    ${PGURL}    
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 2   -c 2    ${PGURL}    
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 4   -c 4    ${PGURL}    
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 8   -c 8    ${PGURL}    
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 16  -c 16   ${PGURL}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 24  -c 24   ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 32  -c 32   ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 40  -c 40   ${PGURL}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 48  -c 48   ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 64  -c 64   ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 64  -c 96   ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 64  -c 128  ${PGURL}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 108 -c 192  ${PGURL}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 108 -c 256  ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 108 -c 384  ${PGURL}     
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 108 -c 512  ${PGURL}
pgbench -rnv -P1 --select-only -T300 -M prepared -s4000 -j 111 -c 555  ${PGURL}
```


```bash
# Read Only Queries
export RES=/tmp/pgbench
export PGURL="test"
mkdir -p ${RES}
pgbench -r -P1 -T300 -M prepared -s4000 -j 1   -c 1    ${PGURL}    
pgbench -r -P1 -T300 -M prepared -s4000 -j 2   -c 2    ${PGURL}    
pgbench -r -P1 -T300 -M prepared -s4000 -j 4   -c 4    ${PGURL}    
pgbench -r -P1 -T300 -M prepared -s4000 -j 8   -c 8    ${PGURL}    
pgbench -r -P1 -T300 -M prepared -s4000 -j 16  -c 16   ${PGURL}
pgbench -r -P1 -T300 -M prepared -s4000 -j 24  -c 24   ${PGURL}          
pgbench -r -P1 -T300 -M prepared -s4000 -j 32  -c 32   ${PGURL}
pgbench -r -P1 -T300 -M prepared -s4000 -j 40  -c 40   ${PGURL}       
pgbench -r -P1 -T300 -M prepared -s4000 -j 48  -c 48   ${PGURL}     
pgbench -r -P1 -T300 -M prepared -s4000 -j 64  -c 64   ${PGURL}     
pgbench -r -P1 -T300 -M prepared -s4000 -j 64  -c 96   ${PGURL}     
pgbench -r -P1 -T300 -M prepared -s4000 -j 64  -c 128  ${PGURL}
pgbench -r -P1 -T300 -M prepared -s4000 -j 108 -c 192  ${PGURL}
pgbench -r -P1 -T300 -M prepared -s4000 -j 108 -c 256  ${PGURL}     
pgbench -r -P1 -T300 -M prepared -s4000 -j 108 -c 384  ${PGURL}     
pgbench -r -P1 -T300 -M prepared -s4000 -j 108 -c 512  ${PGURL}
pgbench -r -P1 -T300 -M prepared -s4000 -j 111 -c 555  ${PGURL}
```










