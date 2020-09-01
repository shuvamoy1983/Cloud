create database mydb;
CREATE TABLE mydb.mytab ( id int  not null auto_increment, sal int, constraint pk_example primary key (id) );
GRANT DROP,CREATE,ALTER,SELECT,INSERT,UPDATE,DELETE,LOCK TABLES,EXECUTE ON *.* TO mysql@'%';
