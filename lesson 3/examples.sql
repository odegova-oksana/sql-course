Вебинар 1. Основы реляционных баз данных. Язык запросов SQL

// Варианты решения ДЗ.

// Создание таблицы users
CREATE TABLE IF NOT EXISTS users (
  id SERIAL COMMENT 'Первичный ключ таблицы',
  name VARCHAR(255) COMMENT 'Имя пользователя'
);

// Выборка 100 записей
mysqldump mysql help_keyword --skip-opt --where='id < 101' > report.sql

// Обновление значений для пустых значений
UPDATE
  catalogs
SET
  name = 'empty'
WHERE
  name = '' OR
  name IS NULL;
  

// Типичные ошибки при создании БД media:
// 1. Выбор структуры.
// 2. Связь таблиц.
// 3. Определение типа столбцов.
// 4. Именование таблиц и столбцов.
// 5. Определение необходимых индексов.

// Пернос данных
INSERT INTO
  sample.cat
SELECT
  id, name
FROM
  shop.catalogs
ON DUPLICATE KEY UPDATE
  name = VALUES(name);


// Создание БД ВКонтакте
CREATE DATABASE vk;
USE vk;

// Создание таблицы пользователей
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  firstname VARCHAR(50),
  lastname VARCHAR(50),
  email VARCHAR(120),
  phone INT,
  INDEX users_phone_idx(phone),
  INDEX users_firstname_lastname_idx(firstname, lastname) 
);

// Создание таблицы профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY,
  sex CHAR(1),
  birthday DATETIME,
  hometown VARCHAR(100)
);

// Создание таблицы сообщений
CREATE TABLE messages (
  from_user_id INT UNSIGNED NOT NULL,
  to_user_id INT UNSIGNED NOT NULL,
  body TEXT,
  created_at DATETIME DEFAULT NOW(),
  PRIMARY KEY (from_user_id, created_at),
  INDEX messages_from_user_id_idx(from_user_id),
  INDEX messages_to_user_id_idx(to_user_id)
);

// Создание таблицы дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL,
  friend_id INT UNSIGNED NOT NULL,
  status VARCHAR(20),
  requested_at DATETIME DEFAULT NOW(),
  confirmed_at DATETIME,
  PRIMARY KEY (user_id, friend_id),
  INDEX frienship_user_id_idx(user_id)
);

// Создание таблицы групп
CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150),
  INDEX communities_name_idx(name)
);

// Таблица связи пользователей и групп
CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (community_id, user_id)
);

// Создание таблицы медиаконтента
CREATE TABLE media (
  id SERIAL PRIMARY KEY,
  media_type_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  filename VARCHAR(255),
  size INT,
  metadata JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX media_user_id_idx(user_id),
  INDEX media_media_type_id_idx(media_type_id)
);

// Создание таблицы типов медиаконтента
CREATE TABLE media_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

// Создание таблицы лайков
CREATE TABLE likes (
  from_user_id INT UNSIGNED NOT NULL,
  to_subject_id INT UNSIGNED NOT NULL,
  subject_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  PRIMARY KEY (from_user_id, to_subject_id, subject_type_id)
);

// Сущности, к которым можно применять лайки
CREATE TABLE subject_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

// Заполняем таблицы с учётом отношений 
// на http://filldb.info

// Тестируем тип TIMESTAMP
CREATE TABLE test_timestamp (
  id INT,
  created_at TIMESTAMP DEFAULT NOW()
);
  
INSERT INTO test_timestamp (id) VALUE (1);
SELECT * FROM test_timestamp;
