# Reference: PolarDB-X Sysbench

https://help.aliyun.com/document_detail/139562.html

https://developer.aliyun.com/article/790151

We can infer that: oltp = oltp_read_write, select = oltp_read_only

|    Database     | PGSQL.C5D96C | PolarX.64C |
| :-------------: | :----------: | :--------: |
| oltp_read_only  |    852440    |   366863   |
| oltp_read_write |    519069    |   177506   |
