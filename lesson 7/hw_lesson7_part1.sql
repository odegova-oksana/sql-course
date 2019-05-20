Практическое задание тема №8

1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". 

delimiter //

drop function if exists hello//

CREATE FUNCTION hello ()
RETURNS varchar(255) DETERMINISTIC
BEGIN
  declare h int;
  set h = hour(now());
  return (case when h >= 6 and h < 12 then 'Доброе утро' when h >= 12 and h < 18 then 'Добрый день' else 'Доброй ночи' end);
END//

select hello()//
+-----------------------+
| hello()               |
+-----------------------+
| Доброе утро           |
+-----------------------+

2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
При попытке присвоить полям NULL-значение необходимо отменить операцию. 

DELIMITER //

DROP TRIGGER IF exists check_product_insert//

CREATE TRIGGER check_product_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF (NEW.name is NULL and NEW.description is NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'INSERT canceled. Name and description are NULL.';
  END IF;
END//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('product 1', NULL, 7890.00, 1)//

select * from products//
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
| id | name                    | description                                                                                                                                         | price    | catalog_id | created_at          | updated_at          |
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
|  1 | Intel Core i3-8100      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   |  7890.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  2 | Intel Core i5-7400      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   | 12700.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  3 | AMD FX-8320E            | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  4780.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  4 | AMD FX-8320             | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  7120.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  5 | ASUS ROG MAXIMUS X HERO | Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX                                                                          | 19310.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  6 | Gigabyte H310M S2H      | Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX                                                                              |  4790.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  7 | MSI B250M GAMING PRO    | Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX                                                                               |  5060.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  8 | product 1               | NULL                                                                                                                                                |  7890.00 |          1 | 2019-05-20 07:22:38 | 2019-05-20 07:22:38 |

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, 'description', 7890.00, 1)//

select * from products//
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
| id | name                    | description                                                                                                                                         | price    | catalog_id | created_at          | updated_at          |
+----+-------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------+----------+------------+---------------------+---------------------+
|  1 | Intel Core i3-8100      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   |  7890.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  2 | Intel Core i5-7400      | Процессор для настольных персональных компьютеров, основанных на платформе Intel.                                                                   | 12700.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  3 | AMD FX-8320E            | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  4780.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  4 | AMD FX-8320             | Процессор для настольных персональных компьютеров, основанных на платформе AMD.                                                                     |  7120.00 |          1 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  5 | ASUS ROG MAXIMUS X HERO | Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX                                                                          | 19310.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  6 | Gigabyte H310M S2H      | Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX                                                                              |  4790.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  7 | MSI B250M GAMING PRO    | Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX                                                                               |  5060.00 |          2 | 2019-05-19 17:08:08 | 2019-05-19 17:08:08 |
|  8 | product 1               | NULL                                                                                                                                                |  7890.00 |          1 | 2019-05-20 07:22:38 | 2019-05-20 07:22:38 |
|  9 | NULL                    | description                                                                                                                                         |  7890.00 |          1 | 2019-05-20 07:23:20 | 2019-05-20 07:23:20 |

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 7890.00, 1)//

ERROR 1644 (45000): INSERT canceled. Name and description are NULL.

DROP TRIGGER IF exists check_product_update//

CREATE TRIGGER check_product_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  DECLARE product_name, product_desc varchar(255);
  SELECT name INTO product_name FROM products where id = NEW.id;
  SELECT description INTO product_desc FROM products where id = NEW.id;
  
  IF NEW.name is NULL and product_desc is NULL THEN
  set NEW.name = product_name;
  END IF;

  IF NEW.description is NULL and product_name is NULL THEN
  set NEW.description = product_desc;
  END IF;
END//

3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55. 

drop function if exists FIBONACCI//

CREATE FUNCTION FIBONACCI (num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE FIRST, SECOND, SUM, i INT;
  SET FIRST = 0;
  SET SECOND = 1;
  SET i = 0;

  IF (num > 0) THEN
    WHILE i < num - 1 DO
      SET SUM = FIRST + SECOND;
      SET FIRST = SECOND;
      SET SECOND = SUM;
      SET i = i + 1;
    END WHILE;
  END IF;

RETURN SECOND;
END//

select FIBONACCI(10)//
￼
