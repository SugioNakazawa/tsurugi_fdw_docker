CREATE EXTENSION tsurugi_fdw;

CREATE SERVER tsurugi FOREIGN DATA WRAPPER tsurugi_fdw;

CREATE TABLESPACE tsurugi LOCATION '/home/tsurugi/pgsql/tsurugi';
