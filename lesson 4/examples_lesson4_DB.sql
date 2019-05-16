// Операторы, фильтрация, сортировка и ограничение
// Агрегация данных

// Находим пользователя
SELECT * FROM users LIMIT 1;
SELECT * FROM users WHERE id = 1; 
SELECT firstname, lastname FROM users WHERE id = 1;

// Данные пользователя с заглушками
SELECT firstname, lastname, 'main_photo', 'city' FROM users WHERE id = 1;

// Расписываем заглушки
SELECT 
  firstname, 
  lastname, 
  (SELECT filename FROM media WHERE id = 
    (SELECT photo_id FROM profiles WHERE user_id = 1)
    ) AS main_photo, 
  (SELECT hometown FROM profiles WHERE user_id = 1) AS city 
  FROM users 
  WHERE id = 1;

// Начинаем работать с фотографиями  
SELECT * FROM media_types WHERE name LIKE 'photo';

// Выбираем фотографии пользователя
SELECT filename FROM media 
  WHERE user_id = 1
    AND media_type_id = (
      SELECT id FROM media_types WHERE name LIKE 'photo'
    ); 
    
// Фото другого пользователя
SELECT filename FROM media 
  WHERE user_id = 3
    AND media_type_id = (
      SELECT id FROM media_types WHERE name LIKE 'photo'
    ); 

// Смотрим типы объектов для которых возможны новости  
SELECT * FROM subject_types;

// Выбираем новости пользователя
SELECT body, 
  created_at 
  FROM news 
  WHERE user_id = 1;
  
// Выбираем путь к файлам медиа, для которых есть новости
SELECT filename FROM media WHERE user_id = 3 
  AND media_type_id = (
    SELECT id FROM media_types WHERE name LIKE 'photo'
);

// Подсчитываем количество таких файлов
SELECT COUNT(*) FROM media WHERE user_id = 3 
  AND media_type_id = (
    SELECT id FROM media_types WHERE name LIKE 'photo'
);

// Смотрим структуру таблицы дружбы
DESC friendship;

// Выбираем друзей пользователя
SELECT * FROM friendship WHERE user_id = 1;

// Смотрим структуру лайков
DESC likes;

// Выбираем только друзей с подтверждённым статусом
SELECT * FROM friendship WHERE user_id = 1 AND status IS TRUE;
SELECT * FROM friendship WHERE user_id = 1 AND status;

// Выбираем новости друзей
SELECT * FROM news WHERE user_id IN (
  SELECT friend_id FROM friendship WHERE user_id  = 1 AND status
);

SELECT * FROM news WHERE user_id = 1;

// Объединяем новости пользователя и его друзей
SELECT * FROM news WHERE user_id = 1
UNION
SELECT * FROM news WHERE user_id IN (
  SELECT friend_id FROM friendship WHERE user_id = 1 AND status
)
ORDER BY created_at DESC
LIMIT 10;

// Находим имена (пути) медиафайлов, на которые ссылаются новости
SELECT to_subject_id FROM news WHERE user_id = 1
UNION
SELECT to_subject_id FROM news WHERE user_id IN (
  SELECT friend_id FROM friendship WHERE user_id = 1 AND status
);

// Подсчитываем лайки для новостей (через медиафайлы)
SELECT to_subject_id, COUNT(*) FROM likes WHERE to_subject_id IN (
  SELECT to_subject_id FROM news WHERE user_id = 1
    UNION
  SELECT to_subject_id FROM news WHERE user_id IN (
    SELECT friend_id FROM friendship WHERE user_id = 1 AND status)
)
GROUP BY to_subject_id;

// Начинаем создавать архив новостей по месяцам
SELECT COUNT(id) AS news, MONTHNAME(created_at) AS month 
  FROM news
  GROUP BY month; 

SELECT COUNT(id) AS news, user_id AS user 
  FROM news
  GROUP BY user;
  
// Архив с правильной сортировкой новостей по месяцам
SELECT COUNT(id) AS news, MONTHNAME(created_at) AS month 
  FROM news
  GROUP BY month
  ORDER BY FIELD(month, 'January', .....) DESC;
  
// Выбираем сообщения от пользователя и к пользователю
SELECT * FROM messages
  WHERE from_user_id = 1
    OR to_user_id = 1
  ORDER BY created_at DESC;
  
// Непрочитанные сообщения
SELECT * FROM messages
  WHERE from_user_id = 1
    AND delivered IS NOT TRUE
  ORDER BY created_at DESC;

// Выводим друзей пользователя с преобразованием пола и возраста 
SELECT user_id, 
       CASE (sex)
         WHEN 'm' THEN 'man'
         WHEN 'f' THEN 'women'
       END AS sex, 
       TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age 
  FROM profiles
  WHERE user_id IN (
    SELECT friend_id 
      FROM friendship
      WHERE user_id = 1
        AND confirmed_at IS NOT NULL
  );



  