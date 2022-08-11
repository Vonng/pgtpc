# PGBIN?=/usr/local/pgsql/bin
# PGDIR?="~/pgtpcb"

PGURL?="postgres"
TIME?=60
SCALE?=1000
FILLFACTOR?=70

init:
	/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpcb stop ; rm -rf ~/pgtpcb/;
	/usr/local/pgsql/bin/initdb  -D ~/pgtpcb -E UTF-8 --locale=en_US.UTF-8 --lc-collate=C
	cp postgresql.auto.conf ~/pgtpcb/postgresql.auto.conf
	/usr/local/pgsql/bin/pg_ctl  -D ~/pgtpcb start

i:
	pgbench -is $(SCALE) -F $(FILLFACTOR) $(PGURL)
r1:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 1   $(PGURL)
r2:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 2   $(PGURL)
r4:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 4   $(PGURL)
r8:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 8   $(PGURL)
r16:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 16  $(PGURL)
r32:
	pgbench -rnv -P1 --select-only -T$(TIME) -M prepared  -c 32  $(PGURL)

w1:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 1   $(PGURL)
w2:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 2   $(PGURL)
w4:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 4   $(PGURL)
w8:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 8   $(PGURL)
w16:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 16  $(PGURL)
w32:
	pgbench -rnv -P1 -T$(TIME) -M prepared  -c 32  $(PGURL)
