#!/bin/bash

oltp_point_select
oltp_read_only
oltp_read_write
oltp_write_only
oltp_delete
oltp_insert
oltp_update_non_index
oltp_update_index
select_random_points
select_random_ranges


grep 'queries:' /tmp/sysbench/oltp_point_select*       > oltp_point_select
grep 'queries:' /tmp/sysbench/oltp_read_only*          > oltp_read_only
grep 'queries:' /tmp/sysbench/oltp_read_write*         > oltp_read_write
grep 'queries:' /tmp/sysbench/oltp_write_only*         > oltp_write_only
grep 'queries:' /tmp/sysbench/oltp_delete*             > oltp_delete
grep 'queries:' /tmp/sysbench/oltp_insert*             > oltp_insert
grep 'queries:' /tmp/sysbench/oltp_update_non_index*   > oltp_update_non_index
grep 'queries:' /tmp/sysbench/oltp_update_index*       > oltp_update_index
grep 'queries:' /tmp/sysbench/select_random_points*    > select_random_points
grep 'queries:' /tmp/sysbench/select_random_ranges*    > select_random_ranges

# /tmp/sysbench/[a-z_]+-(\d+):\s+queries:\s+\d+\s*\((\d+)\.\d+ per sec\.\)
# $1\t$2