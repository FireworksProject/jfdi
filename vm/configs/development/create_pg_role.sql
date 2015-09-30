CREATE ROLE vagrant WITH SUPERUSER LOGIN PASSWORD 'rootdev';
CREATE DATABASE vagrant;
UPDATE pg_database SET datistemplate=false WHERE datname='template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH owner=postgres encoding='UTF-8'
lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;
UPDATE pg_database SET datistemplate=true WHERE datname='template1';
