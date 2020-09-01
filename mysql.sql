create database mydb;
CREATE TABLE mydb.mytab3 ( id int, name varchar(20), salary int );
GRANT DROP,CREATE,ALTER,SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE ON *.* TO mysql@'%';
