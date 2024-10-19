---------------------------------------------------------------
-- Данные на Nick - Partizan
---------------------------------------------------------------

SELECT *
FROM Pet
WHERE Nick = 'Partizan';

-- +------+--------+-------+---+-----------+-----------+--------+
-- |pet_id|nick    |breed  |age|description|pet_type_id|owner_id|
-- +------+--------+-------+---+-----------+-----------+--------+
-- |5     |Partizan|Siamese|5  |very big   |2          |2       |
-- +------+--------+-------+---+-----------+-----------+--------+

---------------------------------------------------------------
-- Клички и породы всех питомцев с сортировкой по возрасту.
---------------------------------------------------------------

SELECT p.nick, p.breed, p.age
FROM pet p
ORDER BY p.age;


-- +--------+-------+---+
-- |nick    |breed  |age|
-- +--------+-------+---+
-- |Markiz  |poodle |1  |
-- |Katok   |null   |2  |
-- |Bobik   |unknown|3  |
-- |Model   |null   |5  |
-- |Apelsin |poodle |5  |
-- |Partizan|Siamese|5  |
-- |Las     |Siamese|7  |
-- |Zombi   |unknown|7  |
-- |Musia   |null   |12 |
-- |Daniel  |spaniel|14 |
-- +--------+-------+---+

---------------------------------------------------------------
-- Питомцы, имеющие хоть какое-нибудь описание.
---------------------------------------------------------------

SELECT p.nick, p.description
FROM pet p
WHERE p.description <> '';

-- +--------+-----------+
-- |nick    |description|
-- +--------+-----------+
-- |Katok   |crazy guy  |
-- |Partizan|very big   |
-- |Zombi   |wild       |
-- +--------+-----------+

---------------------------------------------------------------
-- Средний возраст пуделей.
---------------------------------------------------------------

SELECT AVG(age)
from pet
WHERE pet.breed = 'poodle';


-- +---+
-- |avg|
-- +---+
-- |3  |
-- +---+


---------------------------------------------------------------
-- Количество владельцев.
---------------------------------------------------------------

SELECT COUNT(DISTINCT owner_id)
FROM pet;

-- +-----+
-- |count|
-- +-----+
-- |6    |
-- +-----+

---------------------------------------------------------------
-- Сколько имеется питомцев каждой породы.
---------------------------------------------------------------

SELECT breed, COUNT(pet_id)
FROM pet
group by breed
Order by COUNT(pet_id);

-- +-------+-----+
-- |breed  |count|
-- +-------+-----+
-- |spaniel|1    |
-- |poodle |2    |
-- |Siamese|2    |
-- |unknown|2    |
-- |null   |3    |
-- +-------+-----+

---------------------------------------------------------------
-- Сколько имеется питомцев каждой породы (если только один - не показывать эту породу).
---------------------------------------------------------------

SELECT breed, COUNT(pet_id)
FROM pet
group by breed
HAVING COUNT(pet_id) > 1
Order by COUNT(pet_id);

-- +-------+-----+
-- |breed  |count|
-- +-------+-----+
-- |poodle |2    |
-- |Siamese|2    |
-- |unknown|2    |
-- |null   |3    |
-- +-------+-----+

---------------------------------------------------------------
-- запрос с BETWEEN. pet_ID и имена питомцев, прививки которым были поставлены
-- с 2022-01-01 по 2022-06-01
---------------------------------------------------------------

SELECT p.pet_id, p.nick, v.vaccination_date
FROM pet p
         JOIN vaccination v ON p.pet_id = v.pet_id
WHERE v.vaccination_date BETWEEN '2022-01-01' AND '2022-06-01';

-- +------+------+----------------+
-- |pet_id|nick  |vaccination_date|
-- +------+------+----------------+
-- |6     |Daniel|2022-01-01      |
-- |7     |Model |2022-05-12      |
-- +------+------+----------------+


---------------------------------------------------------------
-- запрос с LIKE. Все люди, номера которых начинаются с цифр +79
---------------------------------------------------------------

SELECT *
FROM person
WHERE phone LIKE '+79%';

-- +---------+---------+----------+------------+--------------------+
-- |person_id|last_name|first_name|phone       |address             |
-- +---------+---------+----------+------------+--------------------+
-- |1        |Ivanov   |Vania     |+79123456789|Srednii pr VO, 34-2 |
-- |2        |Petrov   |Petia     |+79234567890|Sadovaia ul, 17\2-23|
-- +---------+---------+----------+------------+--------------------+

---------------------------------------------------------------
-- запрос с IN(...)      (без вложенного select, это будет позже :))
-- Фамилия и имя каждого сотрудника, кто является боссом или студентом
---------------------------------------------------------------

SELECT last_name, first_name, spec
FROM person
         JOIN employee ON person.person_id = employee.person_id
WHERE spec IN ('boss', 'student');

-- +---------+----------+-------+
-- |last_name|first_name|spec   |
-- +---------+----------+-------+
-- |Ivanov   |Vania     |boss   |
-- |Vorobiev |Vova      |student|
-- |Zotov    |Misha     |student|
-- +---------+----------+-------+