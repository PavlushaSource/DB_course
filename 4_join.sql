---------------------------------------------------------------
-- Данные на Партизана (включая вид животного). Без JOIN
---------------------------------------------------------------

SELECT p.nick, pt.name
FROM pet p,
     pet_type pt
WHERE p.pet_type_id = pt.pet_type_id
  AND p.nick = 'Partizan';

-- +--------+----+
-- |nick    |name|
-- +--------+----+
-- |Partizan|CAT |
-- +--------+----+

---------------------------------------------------------------
-- Список всех собак с кличками, породой и возрастом. Без JOIN
---------------------------------------------------------------

SELECT p.nick, p.breed, p.age
FROM pet p,
     pet_type pt
WHERE p.pet_type_id = pt.pet_type_id
  AND pt.name = 'DOG';


-- +-------+-------+---+
-- |nick   |breed  |age|
-- +-------+-------+---+
-- |Bobik  |unknown|3  |
-- |Apelsin|poodle |5  |
-- |Daniel |spaniel|14 |
-- |Markiz |poodle |1  |
-- +-------+-------+---+

---------------------------------------------------------------
-- Средний возраст кошек. Без JOIN
---------------------------------------------------------------

SELECT AVG(p.age)
FROM pet p,
     pet_type pt
WHERE p.pet_type_id = pt.pet_type_id
  AND pt.name = 'CAT';

-- +---+
-- |avg|
-- +---+
-- |6.6|
-- +---+


---------------------------------------------------------------
--Время и исполнители невыполненных заказов. Без JOIN
---------------------------------------------------------------

SELECT o.time_order, p.last_name
FROM order1 o,
     employee e,
     person p
WHERE o.employee_id = e.employee_id
  AND e.person_id = p.person_id
  AND o.is_done != 1;

-- +--------------------------+---------+
-- |time_order                |last_name|
-- +--------------------------+---------+
-- |2023-09-19 18:00:00.000000|Orlov    |
-- |2023-09-20 10:00:00.000000|Vorobiev |
-- |2023-09-20 11:00:00.000000|Vorobiev |
-- |2023-09-22 10:00:00.000000|Vorobiev |
-- |2023-09-23 10:00:00.000000|Vorobiev |
-- |2023-10-01 11:00:00.000000|Ivanov   |
-- |2023-10-02 11:00:00.000000|Ivanov   |
-- |2023-10-03 16:00:00.000000|Orlov    |
-- +--------------------------+---------+

---------------------------------------------------------------
-- Список хозяев собак (имя, фамилия, телефон). C JOIN
---------------------------------------------------------------

SELECT p.first_name, p.last_name, p.phone
FROM Pet
         JOIN owner ON Pet.owner_id = owner.owner_id
         JOIN person p ON owner.person_id = p.person_id
         JOIN pet_type pt ON Pet.pet_type_id = pt.pet_type_id
WHERE pt.name = 'DOG';

-- +----------+---------+------------+
-- |first_name|last_name|phone       |
-- +----------+---------+------------+
-- |Petia     |Petrov   |+79234567890|
-- |Vasia     |Vasiliev |+7345678901 |
-- |Galia     |Galkina  |+7567890123 |
-- |Vano      |Ivanov   |+7789012345 |
-- +----------+---------+------------+

---------------------------------------------------------------
--  Все виды питомцев и клички представителей этих видов (внешнее соединение). C Left JOIN
---------------------------------------------------------------

SELECT pt.name, p.nick
FROM pet_type pt
         LEFT JOIN pet p ON pt.pet_type_id = p.pet_type_id
ORDER BY pt.name;

-- | name | nick |
-- | :--- | :--- |
-- | CAT | Musia |
-- | CAT | Zombi |
-- | CAT | Las |
-- | CAT | Partizan |
-- | CAT | Katok |
-- | COW | Model |
-- | DOG | Bobik |
-- | DOG | Apelsin |
-- | DOG | Daniel |
-- | DOG | Markiz |
-- | FISH | null |


---------------------------------------------------------------
-- Сколько имеется котов, собак и т.д. в возрасте 1 год, 2 года, и т.д. С JOIN
---------------------------------------------------------------
SELECT p.age, pt.name, COUNT(*)
FROM pet p
         JOIN pet_type pt ON p.pet_type_id = pt.pet_type_id
GROUP BY p.age, pt.name
ORDER BY p.age, pt.name;

-- +---+----+-----+
-- |age|name|count|
-- +---+----+-----+
-- |1  |DOG |1    |
-- |2  |CAT |1    |
-- |3  |DOG |1    |
-- |5  |CAT |1    |
-- |5  |COW |1    |
-- |5  |DOG |1    |
-- |7  |CAT |2    |
-- |12 |CAT |1    |
-- |14 |DOG |1    |
-- +---+----+-----+


---------------------------------------------------------------
--  Фамилии сотрудников, выполнивших более трех заказов. С JOIN
---------------------------------------------------------------

SELECT p.last_name, count(*) as count_of_orders
FROM person p
         JOIN employee e ON p.person_id = e.person_id
         JOIN order1 o ON e.employee_id = o.employee_id
WHERE o.is_done = 1
group by p.last_name
HAVING count(*) > 3;

-- +---------+---------------+
-- |last_name|count_of_orders|
-- +---------+---------------+
-- |Vorobiev |11             |
-- +---------+---------------+


---------------------------------------------------------------
-- Придумайте какой-нибудь осмысленный запрос про прививки, в котором задействованы не менее четырех таблиц базы данных.
-- Не забудьте добавить текстовую формулировку.
-- Формулировка: Выведите имена людей, у которых есть животные с прививкой Janssen
---------------------------------------------------------------

SELECT vt.name, p.last_name, p.first_name
FROM vaccination v,
     person p,
     vaccination_type vt,
     pet,
     owner
WHERE v.vaccination_type_id = vt.vaccination_type_id
  AND v.pet_id = pet.pet_id
  AND pet.owner_id = owner.owner_id
  AND owner.person_id = p.person_id
  AND vt.name = 'Janssen';

-- +-------+---------+----------+
-- |name   |last_name|first_name|
-- +-------+---------+----------+
-- |Janssen|Ivanov   |Vano      |
-- +-------+---------+----------+