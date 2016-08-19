drop database local_foresttofarm; 
create database local_foresttofarm;
grant all on local_foresttofarm.* to 'developer'@'127.0.0.1' identified by 'developing';
use local_foresttofarm;
source /srv/www/foresttofarm.org/data/schema.sql;
