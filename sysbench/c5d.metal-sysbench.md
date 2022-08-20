# SYSBENCH RESULT FOR PGSQL @ AWS.C5D.METAL

## Result

PostgreSQL 14.5 on `c5d.metal` , 96C/192G

|         mode          |   QPS    |  TPS  |
| :-------------------: |:--------:| :---: |
|   oltp_point_select   | 1372654  |   -   |
| select_random_points  |  227623  |   -   |
| select_random_ranges  |  24632   |   -   |
|      oltp_insert      |  164351  |   -   |
|      oltp_delete      |  839153  |   -   |
|    oltp_read_only     |  852440  | 53277 |
|    oltp_read_write    |  519069  | 25953 |
|    oltp_write_only    |  495942  | 82656 |
| oltp_update_non_index |  217626  |       |
|   oltp_update_index   |  169714  |       |


## Procedure

**prepare**

Init sysbench with 16 x 10M Tables, 160M = 1.6Y Tuples.

```bash
sysbench oltp_common.lua --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=10000000 --tables=16 --threads=16 prepare
```

For write related test, reset fillfactor to 75% and perform vacuum full , analyze , prewarm after last test complete.

```sql
ALTER TABLE sbtest1  SET (fillfactor=75);ALTER TABLE sbtest2  SET (fillfactor=75);ALTER TABLE sbtest3  SET (fillfactor=75);ALTER TABLE sbtest4  SET (fillfactor=75);ALTER TABLE sbtest5  SET (fillfactor=75);ALTER TABLE sbtest6  SET (fillfactor=75);ALTER TABLE sbtest7  SET (fillfactor=75);ALTER TABLE sbtest8  SET (fillfactor=75);
ALTER TABLE sbtest9  SET (fillfactor=75);ALTER TABLE sbtest10 SET (fillfactor=75);ALTER TABLE sbtest11 SET (fillfactor=75);ALTER TABLE sbtest12 SET (fillfactor=75);ALTER TABLE sbtest13 SET (fillfactor=75);ALTER TABLE sbtest14 SET (fillfactor=75);ALTER TABLE sbtest15 SET (fillfactor=75);ALTER TABLE sbtest16 SET (fillfactor=75);
VACUUM FULL VERBOSE sbtest1,sbtest2,sbtest3,sbtest4,sbtest5,sbtest6,sbtest7,sbtest8;
VACUUM FULL VERBOSE sbtest9,sbtest10,sbtest11,sbtest12,sbtest13,sbtest14,sbtest15,sbtest16;
ANALYZE VERBOSE;
CHECKPOINT;
SELECT pg_prewarm('sbtest' || i::TEXT) FROM generate_series(1,16) i;
SELECT pg_prewarm('sbtest' || i::TEXT || '_pkey') FROM generate_series(1,16) i;
SELECT pg_prewarm('k_' || i::TEXT) FROM generate_series(1,16) i;
```


**scripts**

```bash
touch /usr/share/sysbench/runtest
chmod a+x runtest
```

content of `runtest` 

```bash
#!/bin/bash
TESTNAME=${1-oltp_point_select}
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=10000000 --tables=16 --report-interval=1 "
${sb} --time=30 --threads=1   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-1    
${sb} --time=30 --threads=2   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-2    
${sb} --time=30 --threads=4   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-4    
${sb} --time=30 --threads=8   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-8    
${sb} --time=30 --threads=16  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-16 
${sb} --time=30 --threads=24  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-24  
${sb} --time=30 --threads=32  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-32 
${sb} --time=30 --threads=40  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-40  
${sb} --time=30 --threads=48  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-48 
${sb} --time=30 --threads=56  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-56  
${sb} --time=30 --threads=64  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-64  
${sb} --time=30 --threads=72  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-72 
${sb} --time=30 --threads=80  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-80   
${sb} --time=30 --threads=88  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-88  
${sb} --time=30 --threads=96  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-96 
${sb} --time=30 --threads=104 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-104 
${sb} --time=30 --threads=112 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-112
${sb} --time=30 --threads=120 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-120
${sb} --time=30 --threads=128 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-128
${sb} --time=30 --threads=256 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-256
${sb} --time=30 --threads=384 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-384
${sb} --time=30 --threads=512 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-512
```

content of `runtest2`, for write involved queries

```bash
#!/bin/bash
TESTNAME=${1-oltp_point_select}
mkdir -p /tmp/sysbench
sb="sysbench --db-driver=pgsql --pgsql-host=/tmp --pgsql-user=test --pgsql-password=test --pgsql-db=test --table_size=10000000 --tables=16 --report-interval=1 "
${sb} --time=30 --threads=1   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-1
${sb} --time=30 --threads=2   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-2
${sb} --time=30 --threads=4   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-4
${sb} --time=30 --threads=8   ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-8
${sb} --time=60 --threads=16  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-16
${sb} --time=60 --threads=24  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-24
${sb} --time=60 --threads=32  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-32
${sb} --time=60 --threads=40  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-40
${sb} --time=60 --threads=48  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-48
${sb} --time=60 --threads=56  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-56
${sb} --time=60 --threads=60  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-60
${sb} --time=60 --threads=64  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-64
${sb} --time=60 --threads=68  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-68
${sb} --time=60 --threads=72  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-72
${sb} --time=60 --threads=76  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-76
${sb} --time=60 --threads=80  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-80
${sb} --time=60 --threads=84  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-84
${sb} --time=60 --threads=88  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-88
${sb} --time=60 --threads=92  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-92
${sb} --time=60 --threads=96  ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-96
${sb} --time=60 --threads=100 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-100
${sb} --time=60 --threads=104 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-104
${sb} --time=60 --threads=112 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-112
${sb} --time=60 --threads=120 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-120
${sb} --time=60 --threads=128 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-128
${sb} --time=60 --threads=256 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-256
${sb} --time=60 --threads=384 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-384
${sb} --time=60 --threads=512 ${TESTNAME}.lua run 1> /tmp/sysbench/${TESTNAME}-512
```

```bash
./runtest oltp_read_only
./runtest select_random_points
./runtest select_random_ranges
./runtest oltp_insert
./runtest oltp_delete
./runtest2 oltp_read_write
./runtest2 oltp_write_only
./runtest2 oltp_update_non_index
./runtest2 oltp_update_index
```


## Raw Data

**oltp_point_select**

1    37147
2    79234
4    158786
8    316150
16   648992
24   926373
32   912554
40   1103889
48   1310241 
50   1372654 *
56   1291251
64   1247078
72   1175059
80   1118079
88   1103682
96   1053276
104  1028882
112  1020559
120  1035870
128  993677
256  932693
384  877564
512  858555


select_random_points

1     654
2     50885
4     94395
8     166221
16    216767
24    223343
32    225161
40    223571
48    223799
56    227623 *
64    227001
72    226161
80    224807
88    225005
96    223247
104   222843
112   221300
120   222288
128   221566
256   221419
384   221005
512   207632

select_random_ranges

1   94
2   241
4   355
8   392
16  419
24  8066
32  14006
40  17813
48  19756
56  21225
64  22326
72  23491
80  23998
88  24310
96  24632 *
104 24591
112 24330
120 24254
128 23852
256 22199
384 20639
512 14395


oltp_insert

1    10446.78
2    18463.55
4    31359.79
8    55516.29
16   63063.46
24   86106.09
32   109628.13
40   128745.36
48   146894.58
56   152813.50
64   148829.55
72   156254.48
80   158182.42
88   159998.85
96   159354.67
104  160759.58
112  161771.12
120  160879.26
128  164351.32 *
256  150340.91
384  134385.73
512  124118.04

oltp_delete

1    15023.77
2    30223.16
4    70268.29
8    165610.67
16   292525.02
24   369479.31
32   444529.38
40   529698.40
48   609189.97
56   631867.82
64   667186.55
72   694838.05
80   717191.34
88   740938.70
96   763542.43
104  784550.70
112  806837.39
120  823274.92
128  839153.30 *
256  812028.27
384  804926.79
512  806965.24

oltp_read_only

1   25687   1605
2   46018   2876
4   94881   5930
8   201909  12619
16  409166  25572
24  544739  34046
32  635966  39747
40  727087  45442
48  852440  53277 *
56  842912  52682
64  813458  50841
72  787088  49193
80  764702  47793
88  755879  47242
96  731817  45738
104 716506  44781
112 710184  44386
120 703862  43991
128 698732  43670
256 657152  41072
384 628643  39290
512 597907  37369


oltp_read_write

1   26857   1342  
2   50725   2536  
4   101403  5070  
8   200283  10014 
16  338977  16948 
24  428483  21424 
32  457728  22886 
40  486792  24339 
48  506017  25300 
56  519069  25953 *
64  516240  25811 
72  507858  25392 
80  501610  25080 
88  497433  24871 
96  491959  24597 
104 486735  24336 
112 480804  24040 
120 477484  23874 
128 475899  23794 
256 441472  22072 
384 415301  20764 
512 397958  19896 



oltp_write_only

1    23811   3968   
2    50665   8444   
4    94965   15827  
8    173772  28962  
16   273537  45589  
24   382189  63697  
32   422777  70462  
40   463455  77241  
48   494289  82380  
56   495942  82656  *
64   492688  82113  
72   494362  82392  
80   463590  77263  
88   435787  72629  
96   428340  71388  
104  419539  69921  
112  470529  78420  
120  459623  76602  
128  454562  75758  
256  444371  74058  
384  421148  70186  
512  417757  69620  


oltp_update_non_index

1    12784     
2    23622     
4    39191     
8    72629     
16   95758     
24   102900     
32   126177     
40   149498     
48   173373     
56   185816     
64   195918     
72   201585     
80   203714     
88   207486     
96   213723     
104  216080     
112  217626 *     
120  209144     
128  201827     
256  195963     
384  183923     
512  155860     


oltp_update_index

1    6529
2    15929
4    26947
8    57324
16   66576
24   85936
32   106154
40   124452
48   139708
56   152713
64   156959
72   158821
80   162130
88   163359
96   166829
104  169714 *
112  169640
120  167136
128  162289
256  136014
384  121475
512  118136
