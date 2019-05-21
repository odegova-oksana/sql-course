Практическое задание тема №9

1. Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа и содержимое поля name. 

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(255),
  entry_id INT,
  entry_name VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER users_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
  insert into logs (table_name, entry_id, entry_name) values ('users', NEW.id, NEW.name);
END//

insert into users (id, name) values (7, 'user7')//

select * from logs//
+----+------------+----------+------------+---------------------+
| id | table_name | entry_id | entry_name | created_at          |
+----+------------+----------+------------+---------------------+
|  1 | users      |        7 | user7      | 2019-05-21 07:43:58 |
+----+------------+----------+------------+---------------------+

CREATE TRIGGER catalogs_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
  insert into logs (table_name, entry_id, entry_name) values ('catalogs', NEW.id, NEW.name);
END//

insert into catalogs (id, name) values (6, 'catalog6')//

select * from logs//
+----+------------+----------+------------+---------------------+
| id | table_name | entry_id | entry_name | created_at          |
+----+------------+----------+------------+---------------------+
|  1 | users      |        7 | user7      | 2019-05-21 07:43:58 |
|  2 | catalogs   |        6 | catalog6   | 2019-05-21 07:46:41 |
+----+------------+----------+------------+---------------------+

CREATE TRIGGER products_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
  insert into logs (table_name, entry_id, entry_name) values ('products', NEW.id, NEW.name);
END//

insert into products (id, name) values (10, 'product10')//

select * from logs//
+----+------------+----------+------------+---------------------+
| id | table_name | entry_id | entry_name | created_at          |
+----+------------+----------+------------+---------------------+
|  1 | users      |        7 | user7      | 2019-05-21 07:43:58 |
|  2 | catalogs   |        6 | catalog6   | 2019-05-21 07:46:41 |
|  3 | products   |       10 | product10  | 2019-05-21 07:49:01 |
+----+------------+----------+------------+---------------------+

2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей. 
￼
DELIMITER //

DROP PROCEDURE IF EXISTS INSERTMLN//

CREATE PROCEDURE INSERTMLN ()
BEGIN
  DECLARE LAST_ID, TOTAL INT;

  select max(id) + 1 into LAST_ID from users;
  set TOTAL = LAST_ID + 1000000;

  WHILE LAST_ID < TOTAL DO
      insert into users (id, name) values (LAST_ID, concat('user', LAST_ID));
      SET LAST_ID = LAST_ID + 1;
    END WHILE;
END//

CALL INSERTMLN()//
