FROM ghcr.io/project-tsurugi/tsurugidb:1.5.0

SHELL ["/usr/bin/bash", "-l", "-c"]

USER root
RUN apt update \
    && apt -y install libreadline-dev \
    zlib1g-dev curl net-tools \
    make gcc g++ git vim \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER tsurugi

# Postgres
RUN curl -sL https://ftp.postgresql.org/pub/source/v12.4/postgresql-12.4.tar.gz | tar -xz \
    && cd postgresql-12.4 \
    && ./configure --prefix=$HOME/pgsql \
    && make \
    && make install
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/home/tsurugi/pgsql/lib
ENV PATH /home/tsurugi/pgsql/bin:$PATH
# fdw
RUN cd postgresql-12.4/contrib \
    && git clone https://github.com/project-tsurugi/tsurugi_fdw.git \
    && cd tsurugi_fdw \
    && git submodule update --init --recursive \
    && make install_dependencies USE_PGXS=1
ENV LIBRARY_PATH $LIBRARY_PATH:/home/tsurugi/pgsql/lib
RUN cd postgresql-12.4/contrib/tsurugi_fdw \
    && make \
    && make install
ENV LD_LIBRARY_PATH /home/tsurugi/pgsql/lib:/usr/lib/tsurugi/lib
# setup
RUN mkdir -p /home/tsurugi/pgsql/data
RUN initdb -D /home/tsurugi/pgsql/data/
RUN echo "shared_preload_libraries = 'tsurugi_fdw'" >> /home/tsurugi/pgsql/data/postgresql.conf \
    && echo "listen_addresses = '*'" >> /home/tsurugi/pgsql/data/postgresql.conf \
    && echo "logging_collector = on" >> /home/tsurugi/pgsql/data/postgresql.conf \
    && echo "unix_socket_directories = '/var/run/postgresql'" >> /home/tsurugi/pgsql/data/postgresql.conf \
    && echo "host  all  all  all  trust" >> /home/tsurugi/pgsql/data/pg_hba.conf

USER root
RUN mkdir -p /var/run/postgresql/ && chmod 777 /var/run/postgresql

USER tsurugi
RUN mkdir /home/tsurugi/pgsql/tsurugi && chmod 777 /home/tsurugi/pgsql/tsurugi  # 外部テーブル用

EXPOSE 5432

CMD [ "/home/tsurugi/pgsql/bin/pg_ctl","-D","/home/tsurugi/pgsql/data" ]
