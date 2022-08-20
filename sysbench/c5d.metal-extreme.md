# SYSBENCH RESULT FOR PGSQL @ AWS.C5D.METAL


## Result




## Prepare

```bash
pg_ctl  -D /data/pg/data stop ;
rm -rf /data/pg/data;
    
    
initdb -X /data1/pg/wal -D /data/pg/data -E LATIN1 --lc-collate=C --locale=C 
cp postgresql.auto.conf /data/pgtpcb/postgresql.auto.conf
echo 'host all all 0.0.0.0/0 trust' >> /data/pgtpcb/pg_hba.conf
pg_ctl  -D /data/pgtpcb start
```

Use this configuration instead:

```ini
# NOT FOR PRODUCTION

listen_addresses = '*'
max_connections = 256
shared_buffers = 128GB
maintenance_work_mem = 20GB
effective_cache_size = 64GB
work_mem = 64MB
effective_io_concurrency = 1000

max_worker_processes = 64
max_parallel_workers = 64
max_parallel_workers_per_gather = 0
max_parallel_maintenance_workers = 4
max_prepared_transactions = 0
max_locks_per_transaction = 64

# wal
wal_level = minimal
wal_sync_method = fdatasync
huge_pages = on
fsync = off
wal_log_hints = off
synchronous_commit = off
full_page_writes = off

wal_buffers = 16MB
wal_keep_size = 20GB
max_wal_size = 200GB
min_wal_size = 20GB
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

max_replication_slots = 0
max_wal_senders = 0

max_standby_archive_delay = 10min
max_standby_streaming_delay = 3min


# logging
log_checkpoints = on
log_destination = 'csvlog'
log_filename = 'postgresql-%Y-%m-%d.log'
log_lock_waits = off
log_min_duration_statement = -1
log_replication_commands = on
log_statement = 'ddl'
logging_collector = on
track_activity_query_size = 1024
track_commit_timestamp = off
track_functions = none
track_io_timing = off

# planner
random_page_cost = 1.1
default_statistics_target = 200

# auto vacuum
autovacuum = off
vacuum_cost_delay = 10ms
vacuum_cost_limit = 10000
vacuum_defer_cleanup_age = 0
autovacuum_max_workers = 2
autovacuum_naptime = 1min
autovacuum_vacuum_cost_delay = -1
autovacuum_vacuum_cost_limit = -1
log_autovacuum_min_duration = 1s
```

**init data**

```bash
cd /usr/share/sysbench/
# http://dimitrik.free.fr/blog/posts/mysql-performance-80-and-sysbench-oltp_rw-updatenokey.html
# oltp_rw (90w), oltp_ro(90w), oltp_update_nokey(24w) for 10M x 8
sysbench oltp_common.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=postgres --pgsql-password=postgres --pgsql-db=postgres --table_size=50000000 --tables=8 --threads=8 prepare

# http://dimitrik.free.fr/blog/posts/mysql-performance-1m-iobound-qps-with-80-ga-on-intel-optane-ssd.html
# oltp_point select for 50M x 8 , 105w 

```

**prewarm**

```sql
ALTER TABLE sbtest1  SET (fillfactor=75);ALTER TABLE sbtest2  SET (fillfactor=75);ALTER TABLE sbtest3  SET (fillfactor=75);ALTER TABLE sbtest4  SET (fillfactor=75);
ALTER TABLE sbtest5  SET (fillfactor=75);ALTER TABLE sbtest6  SET (fillfactor=75);ALTER TABLE sbtest7  SET (fillfactor=75);ALTER TABLE sbtest8  SET (fillfactor=75);

VACUUM FULL VERBOSE sbtest1,sbtest2,sbtest3,sbtest4;
VACUUM FULL VERBOSE sbtest5,sbtest6,sbtest7,sbtest8;
ANALYZE VERBOSE;
CHECKPOINT;
SELECT pg_prewarm('sbtest' || i::TEXT) FROM generate_series(1,8) i;
SELECT pg_prewarm('sbtest' || i::TEXT || '_pkey') FROM generate_series(1,8) i;
SELECT pg_prewarm('k_' || i::TEXT) FROM generate_series(1,8) i;
```




test1: oltp_read_only on 10M x 8

tps = 58855 , qps = 941694

```bash
#!/bin/bash
TESTNAME=oltp_read_only
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=postgres --pgsql-password=postgres --pgsql-db=postgres --table_size=10000000 --tables=8 --report-interval=1 "
${sb} --time=300 --threads=1   oltp_read_only run 1> /tmp/sysbench/ro-1
${sb} --time=300 --threads=2   oltp_read_only run 1> /tmp/sysbench/ro-2
${sb} --time=300 --threads=4   oltp_read_only run 1> /tmp/sysbench/ro-4
${sb} --time=300 --threads=8   oltp_read_only run 1> /tmp/sysbench/ro-8
${sb} --time=300 --threads=16  oltp_read_only run 1> /tmp/sysbench/ro-16
${sb} --time=300 --threads=24  oltp_read_only run 1> /tmp/sysbench/ro-24
${sb} --time=300 --threads=32  oltp_read_only run 1> /tmp/sysbench/ro-32
${sb} --time=300 --threads=40  oltp_read_only run 1> /tmp/sysbench/ro-40  
${sb} --time=300 --threads=48  oltp_read_only run 1> /tmp/sysbench/ro-48 
${sb} --time=300 --threads=56  oltp_read_only run 1> /tmp/sysbench/ro-56  
${sb} --time=300 --threads=64  oltp_read_only run 1> /tmp/sysbench/ro-64  
${sb} --time=300 --threads=72  oltp_read_only run 1> /tmp/sysbench/ro-72 
${sb} --time=300 --threads=80  oltp_read_only run 1> /tmp/sysbench/ro-80   
${sb} --time=300 --threads=88  oltp_read_only run 1> /tmp/sysbench/ro-88  
${sb} --time=300 --threads=96  oltp_read_only run 1> /tmp/sysbench/ro-96 
${sb} --time=300 --threads=104 oltp_read_only run 1> /tmp/sysbench/ro-104 
${sb} --time=300 --threads=112 oltp_read_only run 1> /tmp/sysbench/ro-112
${sb} --time=300 --threads=120 oltp_read_only run 1> /tmp/sysbench/ro-120
${sb} --time=300 --threads=128 oltp_read_only run 1> /tmp/sysbench/ro-128
${sb} --time=300 --threads=256 oltp_read_only run 1> /tmp/sysbench/ro-256
${sb} --time=300 --threads=384 oltp_read_only run 1> /tmp/sysbench/ro-384
${sb} --time=300 --threads=512 oltp_read_only run 1> /tmp/sysbench/ro-512
```



test2: oltp_update_non_index on 10M x 8

tps =  qps = 269233 > mysql (24w)

```bash
#!/bin/bash
TESTNAME=oltp_update_non_index
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=postgres --pgsql-password=postgres --pgsql-db=postgres --table_size=10000000 --tables=8 --report-interval=1 "
${sb} --time=300 --threads=1   oltp_update_non_index.lua run 1> /tmp/sysbench/update-1
${sb} --time=300 --threads=2   oltp_update_non_index.lua run 1> /tmp/sysbench/update-2
${sb} --time=300 --threads=4   oltp_update_non_index.lua run 1> /tmp/sysbench/update-4
${sb} --time=300 --threads=8   oltp_update_non_index.lua run 1> /tmp/sysbench/update-8
${sb} --time=300 --threads=16  oltp_update_non_index.lua run 1> /tmp/sysbench/update-16
${sb} --time=300 --threads=24  oltp_update_non_index.lua run 1> /tmp/sysbench/update-24
${sb} --time=300 --threads=32  oltp_update_non_index.lua run 1> /tmp/sysbench/update-32
${sb} --time=300 --threads=40  oltp_update_non_index.lua run 1> /tmp/sysbench/update-40  
${sb} --time=300 --threads=48  oltp_update_non_index.lua run 1> /tmp/sysbench/update-48 
${sb} --time=300 --threads=56  oltp_update_non_index.lua run 1> /tmp/sysbench/update-56  
${sb} --time=300 --threads=64  oltp_update_non_index.lua run 1> /tmp/sysbench/update-64  
${sb} --time=300 --threads=72  oltp_update_non_index.lua run 1> /tmp/sysbench/update-72 
${sb} --time=300 --threads=80  oltp_update_non_index.lua run 1> /tmp/sysbench/update-80   
${sb} --time=300 --threads=88  oltp_update_non_index.lua run 1> /tmp/sysbench/update-88  
${sb} --time=300 --threads=96  oltp_update_non_index.lua run 1> /tmp/sysbench/update-96 
${sb} --time=300 --threads=104 oltp_update_non_index.lua run 1> /tmp/sysbench/update-104 
${sb} --time=300 --threads=112 oltp_update_non_index.lua run 1> /tmp/sysbench/update-112
${sb} --time=300 --threads=120 oltp_update_non_index.lua run 1> /tmp/sysbench/update-120
${sb} --time=300 --threads=128 oltp_update_non_index.lua run 1> /tmp/sysbench/update-128
${sb} --time=300 --threads=256 oltp_update_non_index.lua run 1> /tmp/sysbench/update-256
${sb} --time=300 --threads=384 oltp_update_non_index.lua run 1> /tmp/sysbench/update-384
${sb} --time=300 --threads=512 oltp_update_non_index.lua run 1> /tmp/sysbench/update-512
```


oltp_read_write under 10M x 8 / 128G Shared buffer (mysql: 45k/90w)

tps = 36145, qps = 722907 for thread = 48
tps = 45527, qps = 910554 for thread = 128

```bash
#!/bin/bash
TESTNAME=oltp_read_write
#!/bin/bash
TESTNAME=oltp_update_non_index
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=postgres --pgsql-password=postgres --pgsql-db=postgres --table_size=10000000 --tables=8 --report-interval=1 "
${sb} --time=300 --threads=1   oltp_read_write.lua run 1> /tmp/sysbench/rw-1
${sb} --time=300 --threads=2   oltp_read_write.lua run 1> /tmp/sysbench/rw-2
${sb} --time=300 --threads=4   oltp_read_write.lua run 1> /tmp/sysbench/rw-4
${sb} --time=300 --threads=8   oltp_read_write.lua run 1> /tmp/sysbench/rw-8
${sb} --time=300 --threads=16  oltp_read_write.lua run 1> /tmp/sysbench/rw-16
${sb} --time=300 --threads=24  oltp_read_write.lua run 1> /tmp/sysbench/rw-24
${sb} --time=300 --threads=32  oltp_read_write.lua run 1> /tmp/sysbench/rw-32
${sb} --time=300 --threads=40  oltp_read_write.lua run 1> /tmp/sysbench/rw-40  
${sb} --time=300 --threads=48  oltp_read_write.lua run 1> /tmp/sysbench/rw-48 
${sb} --time=300 --threads=56  oltp_read_write.lua run 1> /tmp/sysbench/rw-56  
${sb} --time=300 --threads=64  oltp_read_write.lua run 1> /tmp/sysbench/rw-64  
${sb} --time=300 --threads=72  oltp_read_write.lua run 1> /tmp/sysbench/rw-72 
${sb} --time=300 --threads=80  oltp_read_write.lua run 1> /tmp/sysbench/rw-80   
${sb} --time=300 --threads=88  oltp_read_write.lua run 1> /tmp/sysbench/rw-88  
${sb} --time=300 --threads=96  oltp_read_write.lua run 1> /tmp/sysbench/rw-96 
${sb} --time=300 --threads=104 oltp_read_write.lua run 1> /tmp/sysbench/rw-104 
${sb} --time=300 --threads=112 oltp_read_write.lua run 1> /tmp/sysbench/rw-112
${sb} --time=300 --threads=120 oltp_read_write.lua run 1> /tmp/sysbench/rw-120
${sb} --time=300 --threads=128 oltp_read_write.lua run 1> /tmp/sysbench/rw-128
${sb} --time=300 --threads=256 oltp_read_write.lua run 1> /tmp/sysbench/rw-256
${sb} --time=300 --threads=384 oltp_read_write.lua run 1> /tmp/sysbench/rw-384
${sb} --time=300 --threads=512 oltp_read_write.lua run 1> /tmp/sysbench/rw-512
```



oltp_point_select under 50M x 8 (95GB) / 128G Shared buffer (mysql: 105w)


```bash
#!/bin/bash
TESTNAME=oltp_point_select
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=postgres --pgsql-password=postgres --pgsql-db=postgres --table_size=50000000 --tables=8 --report-interval=1 "
${sb} --time=300 --threads=1   oltp_point_select.lua run 1> /tmp/sysbench/point-1
${sb} --time=300 --threads=2   oltp_point_select.lua run 1> /tmp/sysbench/point-2
${sb} --time=300 --threads=4   oltp_point_select.lua run 1> /tmp/sysbench/point-4
${sb} --time=300 --threads=8   oltp_point_select.lua run 1> /tmp/sysbench/point-8
${sb} --time=300 --threads=16  oltp_point_select.lua run 1> /tmp/sysbench/point-16
${sb} --time=300 --threads=24  oltp_point_select.lua run 1> /tmp/sysbench/point-24
${sb} --time=300 --threads=32  oltp_point_select.lua run 1> /tmp/sysbench/point-32
${sb} --time=300 --threads=40  oltp_point_select.lua run 1> /tmp/sysbench/point-40  
${sb} --time=300 --threads=48  oltp_point_select.lua run 1> /tmp/sysbench/point-48 
${sb} --time=300 --threads=56  oltp_point_select.lua run 1> /tmp/sysbench/point-56  
${sb} --time=300 --threads=64  oltp_point_select.lua run 1> /tmp/sysbench/point-64  
${sb} --time=300 --threads=72  oltp_point_select.lua run 1> /tmp/sysbench/point-72 
${sb} --time=300 --threads=80  oltp_point_select.lua run 1> /tmp/sysbench/point-80   
${sb} --time=300 --threads=88  oltp_point_select.lua run 1> /tmp/sysbench/point-88  
${sb} --time=300 --threads=96  oltp_point_select.lua run 1> /tmp/sysbench/point-96 
${sb} --time=300 --threads=104 oltp_point_select.lua run 1> /tmp/sysbench/point-104 
${sb} --time=300 --threads=112 oltp_point_select.lua run 1> /tmp/sysbench/point-112
${sb} --time=300 --threads=120 oltp_point_select.lua run 1> /tmp/sysbench/point-120
${sb} --time=300 --threads=128 oltp_point_select.lua run 1> /tmp/sysbench/point-128
${sb} --time=300 --threads=256 oltp_point_select.lua run 1> /tmp/sysbench/point-256
${sb} --time=300 --threads=384 oltp_point_select.lua run 1> /tmp/sysbench/point-384
${sb} --time=300 --threads=512 oltp_point_select.lua run 1> /tmp/sysbench/point-512
```

