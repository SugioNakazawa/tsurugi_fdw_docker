# Tsurugi DB & PostgreSQL & FDW
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
tsurugi_fdw_docker$ docker compose up -d
tsurugi_fdw_docker$ docker exec -it tsurugi_fdw /bin/bash

$ psql postgres < /docker-entrypoint-initdb.d/01_ddl.sql
$ psql postgres < /docker-entrypoint-initdb.d/02_setup.sql
```

## Sample
### Create sample external table
```SQL
$ psql postgres
# CREATE TABLE tsurugi_customer( c_id INTEGER PRIMARY KEY, c_name VARCHAR(30) NOT NULL, c_age INTEGER) TABLESPACE tsurugi;
# CREATE FOREIGN TABLE tsurugi_customer( c_id INTEGER,c_name VARCHAR(30) NOT NULL,c_age INTEGER) SERVER tsurugi;
```
### Connect from client
```shell
$ psql postgres -h localhost -U tsurugi
```