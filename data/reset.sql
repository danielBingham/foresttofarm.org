drop database dev_org_foresttofarm;
create database dev_org_foresttofarm;
grant all on dev_org_foresttofarm.* to 'dev'@'localhost' identified by 'development';
use dev_org_foresttofarm;
source /home/dbingham/src/development/foresttofarm.org/laravel/data/schema.sql;
