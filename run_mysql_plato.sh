#!/bin/bash

# run mysql under mysql

/usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --plugin-dir=/usr/local/mysql/lib/plugin --user=xtong --log-error=/usr/local/mysql/data/plato.err --pid-file=/usr/local/mysql/data/plato.pid --socket=/tmp/mysql.sock --port=3306

#end
