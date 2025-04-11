# Tsurugi DB & PostgreSQL FDW
## Resources
```
├── docker-compose.yml
├── entrypoint
│   └── docker-entrypoint.sh    # Launch Tsurugi, PostgreSQL
├── initdb
│   ├── 01_ddl.sql              # Create data tg_catalog
│   └── 02_setup.sql            # Create fdw, tableSpace, server 
├── readme.md                   # This document
└── tsurugi_fdw
    └── Dockerfile
```

## Getting start & prepare FDW
FDWのセットアップはコンテナ起動後に手動にて行います。
```
docker compose up -d
docker exec -it tsurugi_fdw bash

# in container
psql postgres < /docker-entrypoint-initdb.d/01_ddl.sql
psql postgres < /docker-entrypoint-initdb.d/02_setup.sql
```

## Sample
### Create sample table

on Tsurugi
```SQL
tgsql -c tcp://localhost:12345
CREATE TABLE tg_customer( c_id INTEGER PRIMARY KEY, c_name VARCHAR(30) NOT NULL, c_age INTEGER);
INSERT INTO tg_customer values(1,'one', 1);
INSERT INTO tg_customer values(2,'two', 2);
INSERT INTO tg_customer values(3,'three', 3);
```

on postgresql
```SQL
psql postgres -h localhost -U tsurugi
CREATE FOREIGN TABLE tg_customer( c_id INTEGER,c_name VARCHAR(30) NOT NULL,c_age INTEGER) SERVER tsurugi;
postgres=# select * from tg_customer;
 c_id | c_name | c_age 
------+--------+-------
    1 | one    |     1
    2 | two    |     2
    3 | three  |     3
(3 rows)
```
