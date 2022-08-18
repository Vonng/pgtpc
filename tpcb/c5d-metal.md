# AWS c5d.metal

96 vCPU x 3.6 GHz , 192 GB Memory , 900GB x 4 NVME SSD



## Result

| clients \ mode | s=1000, RW | s=1000, RO |
| :------------: | :--------: | :--------: |
|       1        |    2947    |   21583    |
|       2        |    5602    |   39309    |
|       4        |   11199    |   91535    |
|       8        |   21607    |   177088   |
|       16       |   36237    |   347259   |
|       32       |   60636    |   540355   |
|       64       |   71624    |   689821   |
|       96       |   69908    |   688743   |
|      128       |   69629    |   687448   |
|      160       |   69303    |   681453   |
|      192       |   68776    |   676480   |
|      224       |   68611    |   670735   |
|      256       |   68457    |   662552   |
|      384       |   66557    |   646750   |
|      512       |   64478    |   625849   |



Read Write : 70K TPS (c=96)

![](c5d-metal/s1000-rw.png)



Read Only: 690K TPS (c=96)

![](c5d-metal/s1000-ro.png)




## Prepare

```bash
bin/createpg pg-test
```

```bash
export PGURL="postgres://test:test@10.10.10.11/test"
pgbench -is 1000 -F 95 ${PGURL}
psql ${PGURL} -c "CREATE EXTENSION pg_prewarm";
psql ${PGURL} -c "SELECT monitor.pg_prewarm('pgbench_accounts');";
psql ${PGURL} -c "SELECT monitor.pg_prewarm('pgbench_branches');";
psql ${PGURL} -c "SELECT monitor.pg_prewarm('pgbench_history');";
psql ${PGURL} -c "SELECT monitor.pg_prewarm('pgbench_tellers');";
psql ${PGURL} -c "SELECT monitor.pg_prewarm('pgbench_accounts_pkey');";
```

```bash
pg edit-config
max_connections : 800
shared_buffers : 32GB
work_mem : 64MB
autovacuum : false
full_page_writes : false
```

```bash
# Read Only Queries
export RES=/tmp/pgbench
export PGURL="test"
mkdir -p ${RES}
pgbench -nv --select-only -j 1   -c 1   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-1.txt   
pgbench -nv --select-only -j 2   -c 2   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-2.txt   
pgbench -nv --select-only -j 4   -c 4   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-4.txt   
pgbench -nv --select-only -j 8   -c 8   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-8.txt   
pgbench -nv --select-only -j 16  -c 16  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-16.txt  
pgbench -nv --select-only -j 32  -c 32  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-32.txt  
pgbench -nv --select-only -j 64  -c 64  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-64.txt  
pgbench -nv --select-only -j 96  -c 96  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-96.txt  
pgbench -nv --select-only -j 128 -c 128 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-128.txt 
pgbench -nv --select-only -j 160 -c 160 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-160.txt 
pgbench -nv --select-only -j 192 -c 192 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-192.txt 
pgbench -nv --select-only -j 224 -c 224 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-224.txt 
pgbench -nv --select-only -j 256 -c 256 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-256.txt 
pgbench -nv --select-only -j 384 -c 384 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-384.txt
pgbench -nv --select-only -j 512 -c 512 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-512.txt 
```

```bash
export RES=/tmp/pgbench
export PGURL="test"
mkdir -p ${RES}
for i in {1..128}; do
  echo "${i} clients"
  pgbench -nv --select-only -j ${i} -c ${i} -T 30 -r -P 1  ${PGURL}  > ${RES}/ro-${i}.txt
done

pgbench -nv --select-only -j 1   -c 1   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-1.txt   
pgbench -nv --select-only -j 2   -c 2   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-2.txt   
pgbench -nv --select-only -j 4   -c 4   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-4.txt   
pgbench -nv --select-only -j 8   -c 8   -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-8.txt   
pgbench -nv --select-only -j 16  -c 16  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-16.txt  
pgbench -nv --select-only -j 32  -c 32  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-32.txt  
pgbench -nv --select-only -j 64  -c 64  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-64.txt  
pgbench -nv --select-only -j 96  -c 96  -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-96.txt  
pgbench -nv --select-only -j 128 -c 128 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-128.txt 
pgbench -nv --select-only -j 160 -c 160 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-160.txt 
pgbench -nv --select-only -j 192 -c 192 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-192.txt 
pgbench -nv --select-only -j 224 -c 224 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-224.txt 
pgbench -nv --select-only -j 256 -c 256 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-256.txt 
pgbench -nv --select-only -j 384 -c 384 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-384.txt
pgbench -nv --select-only -j 512 -c 512 -T 15 -r -P 1  ${PGURL}  > ${RES}/ro-512.txt
```

http://52.83.42.158:3000/d/wPbb-UiVk/pgsql-bench?orgId=1&from=1660736400000&to=1660739100000


```bash
# Read Write Queries
export RES=/tmp/pgbench
export PGURL="test"
mkdir -p ${RES}
pgbench -j 1   -c 1   -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-1.txt   
pgbench -j 2   -c 2   -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-2.txt   
pgbench -j 4   -c 4   -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-4.txt   
pgbench -j 8   -c 8   -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-8.txt   
pgbench -j 16  -c 16  -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-16.txt  
pgbench -j 32  -c 32  -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-32.txt  
pgbench -j 64  -c 64  -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-64.txt  
pgbench -j 96  -c 96  -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-96.txt  
pgbench -j 128 -c 128 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-128.txt 
pgbench -j 160 -c 160 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-160.txt 
pgbench -j 192 -c 192 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-192.txt 
pgbench -j 224 -c 224 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-224.txt 
pgbench -j 256 -c 256 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-256.txt 
pgbench -j 384 -c 384 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-384.txt
pgbench -j 512 -c 512 -T 180 -r -P 10  ${PGURL}  > ${RES}/rw-512.txt 
```









## S = 10000 (160GB)

