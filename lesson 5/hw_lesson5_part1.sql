Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

create table users (
id int unsigned not null primary key, 
name VARCHAR(255)
);

insert into users (id, name) values (1, 'user1'); 
insert into users (id, name) values (2, 'user2');
insert into users (id, name) values (3, 'user3');

create table orders (
id int unsigned not null primary key, 
number int not null,
user_id int not null,
created_at datetime default now());

insert into orders (id, number, user_id) values (1, 1, 1);
insert into orders (id, number, user_id) values (2, 2, 1);
insert into orders (id, number, user_id) values (3, 3, 2);

select distinct u.name from orders o join users u on o.user_id = u.id; 
Выведите список товаров products и разделов catalogs, который соответствует товару.

create table catalogs (
id int unsigned not null primary key, 
name VARCHAR(255)
);

create table products (
id int unsigned not null primary key, 
catalog_id int not null,
name VARCHAR(255)
);

select p.name, c.name from products p join catalogs c on p.catalog_id = c.id; 
(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

create table flights (id int unsigned not null primary key, from_city varchar(100), to_city varchar(100));

create table cities (
    name varchar(100) not null primary key,
    label varchar(100)
 ); 
insert into flights (id, from_city, to_city) values (1, 'moscow', 'omsk');
insert into flights (id, from_city, to_city) values (2, 'novgorod', 'kazan');
insert into flights (id, from_city, to_city) values (3, 'irkutsk', 'moscow');
insert into flights (id, from_city, to_city) values (4, 'omsk', 'irkutsk');
insert into flights (id, from_city, to_city) values (5, 'moscow', 'kazan');

insert into cities (name, label) values ('moscow', 'Москва');
insert into cities (name, label) values ('irkutsk', 'Иркутск');
insert into cities (name, label) values ('novgorod', 'Новгород');
insert into cities (name, label) values ('kazan', 'Казань');
insert into cities (name, label) values ('omsk', 'Омск');

select fc.label, tc.label from flights f join cities fc on f.from_city = fc.name join cities tc on f.to_city = tc.name;
+------------------+----------------+
| label            | label          |
+------------------+----------------+
| Москва           | Омск           |
| Новгород         | Казань         |
| Иркутск          | Москва         |
| Омск             | Иркутск        |
| Москва           | Казань         |
+------------------+----------------+