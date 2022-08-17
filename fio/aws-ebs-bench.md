# Block Device Benchmark

bench method: fio

```bash
fio -name=8krandw  -runtime=60 -filename=/data2/rand.txt -ioengine=libaio -direct=1  -bs=8K  -size=10g  -iodepth=128  -numjobs=1  -rw=randwrite -group_reporting -time_based # 8k  随机写
fio -name=8krandr  -runtime=60 -filename=/data2/rand.txt -ioengine=libaio -direct=1  -bs=8K  -size=10g  -iodepth=128  -numjobs=1  -rw=randread -group_reporting -time_based # 8K  随机读
fio -name=8krandrw -runtime=60 -filename=/data2/rand.txt -ioengine=libaio -direct=1  -bs=8k  -size=10g  -iodepth=128  -numjobs=1  -rw=randrw -rwmixwrite=30  -group_reporting -time_based # 8k混合读写
fio -name=1mseqw   -runtime=60 -filename=/data2/seq.txt  -ioengine=libaio -direct=1  -bs=1024k  -size=20g  -iodepth=128  -numjobs=1  -rw=write -group_reporting -time_based # 1Mb  顺序写
fio -name=1mseqr   -runtime=60 -filename=/data2/seq.txt  -ioengine=libaio -direct=1  -bs=1024k  -size=20g  -iodepth=128  -numjobs=1  -rw=read -group_reporting -time_based # 1Mb  顺序读
fio -name=1mseqrw  -runtime=60 -filename=/data2/seq.txt  -ioengine=libaio -direct=1  -bs=1024k  -size=20g  -iodepth=128  -numjobs=1  -rw=rw -rwmixwrite=30  -group_reporting -time_based # 1Mb混合读写
```





## Baseline

default 10GB root device

| 写             | IOPS | Bandwidth  | avg(clat) |
| -------------- | :--: | :--------: | :-------: |
| 8KiB randwrite | 3162 | 24.7 MiB/s |  40.5 ms  |
| 8KiB randread  | 3162 | 24.7 MiB/s |  40.5 ms  |
| 8KiB randrw    | 3123 | 24.7 MiB/s |  40.5 ms  |
| 1MiB write     |  61  | 61.5 MiB/s |  2077 ms  |
| 1MiB read      |  61  | 64.5 MiB/s |  2077 ms  |
| 1MiB randrw    |  61  | 61.5 MiB/s |  1479ms   |

## IO1 Max Spec

 ```
 volume_type = "io1"
 volume_size = 640     # iops:gb = 50:1
 iops = 32000          # max available value: 80k = 313 MiB/s
 ```

| 写             | IOPS  | Bandwidth  | avg(clat) |
| -------------- | :---: | :--------: | :-------: |
| 8KiB randwrite | 10500 | 81.9 MiB/s |   12 ms   |
| 8KiB randread  | 13900 | 109 MiB/s  |  9.2 ms   |
| 8KiB randrw    | 9620  | 75.2 MiB/s |  9.2 ms   |
| 1MiB write     |  381  | 382 MiB/s  |  335 ms   |
| 1MiB read      |  379  | 379 MiB/s  |   337ms   |
| 1MiB randrw    |  379  | 379 MiB/s  |  337 ms   |

# NVME SSD EMPHERAL

Associated with z1d.2xlarge: 279.4G NVME SSD

| 写             | IOPS  | Bandwidth |   avg(clat)   |
| -------------- | :---: | :-------: | :-----------: |
| 8KiB randwrite | 32500 | 254 MiB/s |    3.9 ms     |
| 8KiB randread  | 67100 | 524 MiB/s |    1.9 ms     |
| 8KiB randrw    | 94700 | 740 MiB/s | 1.7ms / 0.5ms |
| 1MiB write     |  253  | 254 MiB/s |     504ms     |
| 1MiB read      |  521  | 521 MiB/s |     246ms     |
| 1MiB randrw    |  738  | 739 MiB/s |  178ms/160ms  |



# NVME SSD EMPHERAL

Associated with z1d.2xlarge: 279.4G NVME SSD

| 写             | IOPS  | Bandwidth |   avg(clat)   |
| -------------- | :---: | :-------: | :-----------: |
| 8KiB randwrite | 32500 | 254 MiB/s |    3.9 ms     |
| 8KiB randread  | 67100 | 524 MiB/s |    1.9 ms     |
| 8KiB randrw    | 94700 | 740 MiB/s | 1.7ms / 0.5ms |
| 1MiB write     |  253  | 254 MiB/s |     504ms     |
| 1MiB read      |  521  | 521 MiB/s |     246ms     |
| 1MiB randrw    |  738  | 739 MiB/s |  178ms/160ms  |

# 







```bash
# 8k  随机写
fio -name=8krandw  -runtime=120  -filename=/tmp/rand.txt -ioengine=libaio -direct=1  -bs=8K  -size=1g  -iodepth=128  -numjobs=1  -rw=randwrite -group_reporting -time_based
  
# 8K  随机读
fio -name=8krandr  -runtime=120  -filename=/tmp/rand.txt -ioengine=libaio -direct=1  -bs=8K  -size=1g  -iodepth=128  -numjobs=1  -rw=randread -group_reporting -time_based
  
# 8k  混合读写 
fio -name=8krandrw  -runtime=120  -filename=/tmp/rand.txt -ioengine=libaio -direct=1  -bs=8k  -size=1g  -iodepth=128  -numjobs=1  -rw=randrw -rwmixwrite=30  -group_reporting -time_based
   
# 1Mb  顺序写
fio -name=1mseqw  -runtime=120  -filename=/tmp/seq.txt -ioengine=libaio -direct=1  -bs=1024k  -size=2g  -iodepth=128  -numjobs=1  -rw=write -group_reporting -time_based
  
# 1Mb  顺序读
fio -name=1mseqr  -runtime=120  -filename=/tmp/seq.txt -ioengine=libaio -direct=1  -bs=1024k  -size=2g  -iodepth=128  -numjobs=1  -rw=read -group_reporting -time_based
  
# 1Mb  顺序读写
fio -name=1mseqrw  -runtime=120  -filename=/tmp/seq.txt -ioengine=libaio -direct=1  -bs=1024k  -size=2g  -iodepth=128  -numjobs=1  -rw=rw -rwmixwrite=30  -group_reporting -time_based
```