---------------------------------------------------------------
--  Все оценки по выполненным заказам, исполнителями которых являлись студенты.
-- (используйте IN (SELECT...))
---------------------------------------------------------------

SELECT o.mark
FROM order1 o
WHERE o.employee_id IN (SELECT e.employee_id
                        FROM employee e
                        WHERE o.employee_id = e.employee_id
                          AND e.spec = 'student')
  AND o.mark > 0;

-- +----+
-- |mark|
-- +----+
-- |5   |
-- |5   |
-- |3   |
-- |5   |
-- |4   |
-- |4   |
-- |4   |
-- |4   |
-- |4   |
-- |4   |
-- +----+

---------------------------------------------------------------
--  Фамилии исполнителей, не получивших еще ни одного заказа.
--  Последовательность отладки:
--      - id исполнителей, у которых нет заказов,
--          (используйте NOT IN (SELECT...))
--      - фамилии этих исполнителей.
--          (присоедините еще одну таблицу)
---------------------------------------------------------------

SELECT e.employee_id
FROM employee e
WHERE e.employee_id NOT IN (SELECT o.employee_id
                            FROM order1 o
                            GROUP BY o.employee_id);

-- +-----------+
-- |employee_id|
-- +-----------+
-- |4          |
-- +-----------+

-- Первый вывод: id исполнителей без заказов

SELECT p.last_name
FROM employee e
         JOIN person p ON e.person_id = p.person_id
WHERE e.employee_id NOT IN (SELECT o.employee_id
                            FROM order1 o
                            GROUP BY o.employee_id);

-- +---------+
-- |last_name|
-- +---------+
-- |Zotov    |
-- +---------+

-- Второй вывод: Фамилии этих исполнителей

---------------------------------------------------------------
-- Список заказов (вид услуги, время, фамилия исполнителя, кличка питомца, фамилия владельца).
-- (используйте псевдонимы, см. в презентации раздел 2.3. Сложные соединения таблиц)
---------------------------------------------------------------

SELECT s.name,
       o.time_order     as time,
       p_empl.last_name as Employee_last_name,
       p.nick,
       p_own.last_name  as Owner_last_name
FROM service s
         JOIN order1 o ON s.service_id = o.service_id
         JOIN pet p ON o.pet_id = p.pet_id
         JOIN employee e ON o.employee_id = e.employee_id
         JOIN person p_empl ON p_empl.person_id = e.person_id
         JOIN owner ON o.owner_id = owner.owner_id
         JOIN person p_own ON owner.person_id = p_own.person_id;

-- | name | time | employee\_last\_name | nick | owner\_last\_name |
-- | :--- | :--- | :--- | :--- | :--- |
-- | Walking | 2023-09-11 08:00:00.000000 | Vorobiev | Bobik | Petrov |
-- | Combing | 2023-09-11 09:00:00.000000 | Orlov | Musia | Petrov |
-- | Combing | 2023-09-11 09:00:00.000000 | Orlov | Katok | Petrov |
-- | Walking | 2023-09-11 00:00:00.000000 | Vorobiev | Bobik | Petrov |
-- | Walking | 2023-09-16 11:00:00.000000 | Vorobiev | Bobik | Petrov |
-- | Walking | 2023-09-17 17:00:00.000000 | Vorobiev | Bobik | Petrov |
-- | Combing | 2023-09-17 18:00:00.000000 | Orlov | Musia | Petrov |
-- | Walking | 2023-09-17 18:00:00.000000 | Vorobiev | Partizan | Vasiliev |
-- | Walking | 2023-09-17 10:00:00.000000 | Vorobiev | Apelsin | Vasiliev |
-- | Walking | 2023-09-18 17:00:00.000000 | Vorobiev | Partizan | Vasiliev |
-- | Walking | 2023-09-18 18:00:00.000000 | Vorobiev | Apelsin | Vasiliev |
-- | Walking | 2023-09-18 12:00:00.000000 | Vorobiev | Partizan | Vasiliev |
-- | Walking | 2023-09-18 14:00:00.000000 | Vorobiev | Apelsin | Vasiliev |
-- | Walking | 2023-09-19 10:00:00.000000 | Vorobiev | Daniel | Galkina |
-- | Combing | 2023-09-19 18:00:00.000000 | Orlov | Daniel | Galkina |
-- | Walking | 2023-09-20 10:00:00.000000 | Vorobiev | Daniel | Galkina |
-- | Walking | 2023-09-20 11:00:00.000000 | Vorobiev | Daniel | Galkina |
-- | Walking | 2023-09-22 10:00:00.000000 | Vorobiev | Daniel | Galkina |
-- | Walking | 2023-09-23 10:00:00.000000 | Vorobiev | Daniel | Galkina |
-- | Milking | 2023-09-30 11:00:00.000000 | Ivanov | Model | Sokolov |
-- | Milking | 2023-10-01 11:00:00.000000 | Ivanov | Model | Sokolov |
-- | Milking | 2023-10-02 11:00:00.000000 | Ivanov | Model | Sokolov |
-- | Combing | 2023-10-03 16:00:00.000000 | Orlov | Markiz | Ivanov |

---------------------------------------------------------------
-- Общий список комментариев, имеющихся в базе.
-- (“Хватит захламлять базу, посмотрите, что вы пишите в комментариях!”).
-- (используйте UNION)
-- (комментарии есть в трех таблицах). Это таблицы order, owner, pet
---------------------------------------------------------------

SELECT *
FROM (SELECT o.comments
      FROM order1 o
      UNION ALL
      SELECT o.description
      FROM owner o
      UNION ALL
      SELECT p.description
      FROM pet p) as all_comments
WHERE all_comments.comments <> '';

-- +--------------------+
-- |comments            |
-- +--------------------+
-- |That cat is crazy!  |
-- |Comming late        |
-- |good boy            |
-- |from the ArtsAcademy|
-- |mean                |
-- |crazy guy           |
-- |very big            |
-- |wild                |
-- +--------------------+

---------------------------------------------------------------
-- Имена и фамилии сотрудников, хотя бы раз получивших четверку за выполнение заказа.
-- (используйте EXISTS)
---------------------------------------------------------------

SELECT p.last_name, p.first_name
FROM person p
WHERE EXISTS(SELECT e.person_id
             FROM employee e,
                  order1 o
             WHERE e.employee_id = o.employee_id
               AND p.person_id = e.person_id
               AND o.mark = 4);

-- +---------+----------+
-- |last_name|first_name|
-- +---------+----------+
-- |Orlov    |Oleg      |
-- |Vorobiev |Vova      |
-- +---------+----------+

---------------------------------------------------------------
-- Перепишите предыдущий запрос в каком-либо ином синтаксисе, без EXISTS.
---------------------------------------------------------------


-- Первый вариант с использованием IN
SELECT p.last_name, p.first_name
FROM person p
         JOIN employee e ON p.person_id = e.person_id
WHERE p.person_id IN (SELECT e.person_id
                      FROM order1 o
                      WHERE e.employee_id = o.employee_id
                        AND o.mark = 4);

-- Второй вариант с использованием JOIN
SELECT p.last_name, p.first_name
FROM person p
         JOIN employee e ON p.person_id = e.person_id
         JOIN (SELECT e.person_id
               FROM employee e
                        JOIN order1 o ON e.employee_id = o.employee_id
               WHERE o.mark = 4
               GROUP BY e.person_id) sub ON p.person_id = sub.person_id;