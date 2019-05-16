Практическое задание тема №6

В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. 
use sample;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
show tables;
+------------------+
| Tables_in_sample |
+------------------+
| cat              |
| users            |
+------------------+

select * from users;

use shop;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
show tables;
+----------------+
| Tables_in_shop |
+----------------+
| catalogs       |
+----------------+

create table users (
    id int unsigned not null primary key, 
    name VARCHAR(255)
    );

insert into users (id, name) values (1, 'user1'); 
insert into users (id, name) values (2, 'user2');
insert into users (id, name) values (3, 'user3');

select * from users;
+----+-------+
| id | name  |
+----+-------+
|  1 | user1 |
|  2 | user2 |
|  3 | user3 |
+----+-------+

start transaction;
insert into sample.users (id, name) select id, name from shop.users where id =1;
delete from shop.users where id =1;
commit;

select * from sample.users;
+------+-------+
| id   | name  |
+------+-------+
|    1 | user1 |
+------+-------+

select * from shop.users;
+----+-------+
| id | name  |
+----+-------+
|  2 | user2 |
|  3 | user3 |
+----+-------+

Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

create view prod_view as select p.name as product_name, c.name as catalog_name from products p join catalogs c on p.catalog_id = c.id;

select * from prod_view;
+-------------------------+-----------------------------------+
| product_name            | catalog_name                      |
+-------------------------+-----------------------------------+
| Intel Core i3-8100      | Процессоры                        |
| Intel Core i5-7400      | Процессоры                        |
| AMD FX-8320E            | Процессоры                        |
| AMD FX-8320             | Процессоры                        |
| ASUS ROG MAXIMUS X HERO | Материнские платы                 |
| Gigabyte H310M S2H      | Материнские платы                 |
| MSI B250M GAMING PRO    | Материнские платы                 |
+-------------------------+-----------------------------------+

(по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.

create table dates (date_month DATETIME);

insert into dates (date_month) values ('2019-05-01');
insert into dates (date_month) values ('2019-05-04');
insert into dates (date_month) values ('2019-05-16');
insert into dates (date_month) values ('2019-05-17'); 

SELECT date_field
FROM
(
    SELECT
        MAKEDATE(YEAR(NOW()),1) +
        INTERVAL (MONTH(NOW())-1) MONTH +
        INTERVAL daynum DAY date_field
    FROM
    (
        SELECT t*10+u daynum
        FROM
            (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
            (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
            UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
            UNION SELECT 8 UNION SELECT 9) B
        ORDER BY daynum
    ) AA
) AAA
WHERE MONTH(date_field) = MONTH(NOW());

select 
	dv.date_field, 
	case when date_month is not null then 1 else '' end as hasDate 
from date_view dv 
left join dates d on DAY(d.date_month) = DAY(dv.date_field) 
order by date_field;

+------------+---------+
| date_field | hasDate |
+------------+---------+
| 2019-05-01 | 1       |
| 2019-05-02 |         |
| 2019-05-03 |         |
| 2019-05-04 | 1       |
| 2019-05-05 |         |
| 2019-05-06 |         |
| 2019-05-07 |         |
| 2019-05-08 |         |
| 2019-05-09 |         |
| 2019-05-10 |         |
| 2019-05-11 |         |
| 2019-05-12 |         |
| 2019-05-13 |         |
| 2019-05-14 |         |
| 2019-05-15 |         |
| 2019-05-16 | 1       |
| 2019-05-17 | 1       |
| 2019-05-18 |         |
| 2019-05-19 |         |
| 2019-05-20 |         |
| 2019-05-21 |         |
| 2019-05-22 |         |
| 2019-05-23 |         |
| 2019-05-24 |         |
| 2019-05-25 |         |
| 2019-05-26 |         |
| 2019-05-27 |         |
| 2019-05-28 |         |
| 2019-05-29 |         |
| 2019-05-30 |         |
| 2019-05-31 |         |
+------------+---------+

(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

create table dates_recent (date_month DATETIME);

insert into dates_recent (date_month) values ('2019-05-01');
insert into dates_recent (date_month) values ('2019-05-02');
insert into dates_recent (date_month) values ('2019-05-03');
insert into dates_recent (date_month) values ('2019-05-04');
insert into dates_recent (date_month) values ('2019-05-16');
insert into dates_recent (date_month) values ('2019-05-17'); 
insert into dates_recent (date_month) values ('2019-05-18');

select * from dates_recent where date_month < (select min(date_month) from (select date_month from dates_recent order by date_month desc limit 5) tbl);
+---------------------+
| date_month          |
+---------------------+
| 2019-05-01 00:00:00 |
| 2019-05-02 00:00:00 |
+---------------------+

delete dates_recent where date_month < (select min(date_month) from (select date_month from dates_recent order by date_month desc limit 5) tbl);


