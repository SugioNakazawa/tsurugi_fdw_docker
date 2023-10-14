FROM ghcr.io/project-tsurugi/tsurugidb:latest

SHELL ["/usr/bin/bash", "-l", "-c"]
USER root
RUN apt update && apt -y install libreadline-dev zlib1g-dev curl net-tools
RUN apt -y install make gcc g++ git vim
# RUN useradd -m tsurugi -s /usr/bin/bash

USER tsurugi
# WORKDIR /home/tsurugi
# # Tsurugi
# RUN mkdir /home/tsurugi/inst
# ADD https://github.com/project-tsurugi/tsurugidb/releases/download/1.0.0-BETA1/tsurugidb-1.0.0-BETA1.tar.gz /home/tsurugi/inst/
# USER root
# RUN chmod 777 /home/tsurugi/inst/tsurugidb-1.0.0-BETA1.tar.gz
# USER tsurugi
# RUN cd /home/tsurugi/inst && tar xf tsurugidb-1.0.0-BETA1.tar.gz
# USER root
# RUN cd /home/tsurugi/inst && ./apt-install.sh
# USER tsurugi
# RUN cd /home/tsurugi/inst && ./install.sh --prefix=/home/tsurugi --symbolic
# ENV TSURUGI_HOME /home/tsurugi/tsurugi

# Postgres
RUN curl -sL https://ftp.postgresql.org/pub/source/v12.4/postgresql-12.4.tar.gz | tar -xz
RUN cd postgresql-12.4 && ./configure --prefix=$HOME/pgsql
RUN cd postgresql-12.4 && make
RUN cd postgresql-12.4 && make install
# RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/tsurugi/pgsql/lib
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/tsurugi/pgsql/lib
# RUN export PATH=/home/tsurugi/pgsql/bin:$PATH
ENV PATH /home/tsurugi/pgsql/bin:$PATH
RUN cd postgresql-12.4/contrib && git clone https://github.com/project-tsurugi/tsurugi_fdw.git
# .gitmodules の中身のgit@github.com を https に変えたものに置き換える
ADD .gitmodules postgresql-12.4/contrib/tsurugi_fdw
RUN cd postgresql-12.4/contrib/tsurugi_fdw && git submodule update --init
# RUN export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/tsurugi/lib
ENV LIBRARY_PATH $LIBRARY_PATH:/usr/lib/tsurugi/lib
RUN cd postgresql-12.4/contrib/tsurugi_fdw && make
RUN cd postgresql-12.4/contrib/tsurugi_fdw && make install
ENV LD_LIBRARY_PATH /home/tsurugi/pgsql/lib:/usr/lib/tsurugi/lib

RUN mkdir -p /home/tsurugi/pgsql/data
RUN initdb -D /home/tsurugi/pgsql/data/
RUN echo "shared_preload_libraries = 'tsurugi_fdw'" >> /home/tsurugi/pgsql/data/postgresql.conf
RUN echo "listen_addresses = '*'" >> /home/tsurugi/pgsql/data/postgresql.conf
RUN echo "logging_collector = on" >> /home/tsurugi/pgsql/data/postgresql.conf
RUN echo "unix_socket_directories = '/var/run/postgresql'" >> /home/tsurugi/pgsql/data/postgresql.conf
RUN echo "host  all  all  all  trust" >> /home/tsurugi/pgsql/data/pg_hba.conf

USER root
RUN mkdir -p /var/run/postgresql/
RUN chmod 777 /var/run/postgresql

USER tsurugi
# ENV PGDATA /home/tsurugi/pgsql/data
RUN mkdir /home/tsurugi/pgsql/tsurugi  # 外部テーブル用
RUN chmod 777 /home/tsurugi/pgsql/tsurugi
WORKDIR $HOME
EXPOSE 5432

CMD [ "/home/tsurugi/pgsql/bin/pg_ctl","-D","/home/tsurugi/pgsql/data" ]
# CMD [ "/home/tsurugi/pgsql/bin/postgres","-D","/home/tsurugi/pgsql/data","-c","config_file=/home/tsurugi/pgsql/data/postgresql.conf" ]

# setup fdw
# psql postgres < /home/tsurugi/postgresql-12.4/contrib/tsurugi_fdw/third_party/metadata-manager/sql/ddl.sql 
# CREATE EXTENSION tsurugi_fdw;
# CREATE SERVER tsurugi FOREIGN DATA WRAPPER tsurugi_fdw;
# mkdir /home/tsurugi/pgsql/tsurugi
# CREATE TABLESPACE tsurugi LOCATION '/home/tsurugi/pgsql//tsurugi';

# sample external table
# CREATE TABLE tsurugi_customer( c_id INTEGER PRIMARY KEY, c_name VARCHAR(30) NOT NULL, c_age INTEGER) TABLESPACE tsurugi;
# CREATE FOREIGN TABLE tsurugi_customer( c_id INTEGER,c_name VARCHAR(30) NOT NULL,c_age INTEGER) SERVER tsurugi;
