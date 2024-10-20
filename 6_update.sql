-- Напишите оператор, добавляющий пометку “(s)” в начало комментария по каждому заказу,
-- исполнитель которого – студент. Выполните этот оператор.

UPDATE order1 o
SET comments = concat('(s)', comments)
WHERE o.employee_id IN (SELECT e.employee_id FROM employee e WHERE e.spec = 'student');

-- RESULT:
-- | order\_id | owner\_id | service\_id | pet\_id | employee\_id | time\_order | is\_done | mark | comments |
-- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
-- | 22 | 4 | 3 | 7 | 1 | 2023-10-02 11:00:00.000000 | 0 | 0 | null |
-- | 20 | 4 | 3 | 7 | 1 | 2023-09-30 11:00:00.000000 | 1 | 5 |  |
-- | 21 | 4 | 3 | 7 | 1 | 2023-10-01 11:00:00.000000 | 0 | 0 | null |
-- | 23 | 5 | 2 | 8 | 2 | 2023-10-03 16:00:00.000000 | 0 | 0 | null |
-- | 3 | 1 | 2 | 3 | 2 | 2023-09-11 09:00:00.000000 | 1 | 4 | That cat is crazy! |
-- | 2 | 1 | 2 | 2 | 2 | 2023-09-11 09:00:00.000000 | 1 | 4 |  |
-- | 7 | 1 | 2 | 2 | 2 | 2023-09-17 18:00:00.000000 | 1 | 5 |  |
-- | 15 | 3 | 2 | 6 | 2 | 2023-09-19 18:00:00.000000 | 0 | 0 |  |
-- | 11 | 2 | 1 | 4 | 3 | 2023-09-18 18:00:00.000000 | 1 | 4 | \(s\) |
-- | 12 | 2 | 1 | 5 | 3 | 2023-09-18 12:00:00.000000 | 1 | 4 | \(s\) |
-- | 13 | 2 | 1 | 4 | 3 | 2023-09-18 14:00:00.000000 | 1 | 4 | \(s\) |
-- | 14 | 3 | 1 | 6 | 3 | 2023-09-19 10:00:00.000000 | 1 | 5 | \(s\) |
-- | 16 | 3 | 1 | 6 | 3 | 2023-09-20 10:00:00.000000 | 0 | 0 | \(s\) |
-- | 17 | 3 | 1 | 6 | 3 | 2023-09-20 11:00:00.000000 | 0 | 0 | \(s\) |
-- | 18 | 3 | 1 | 6 | 3 | 2023-09-22 10:00:00.000000 | 0 | 0 | \(s\) |
-- | 19 | 3 | 1 | 6 | 3 | 2023-09-23 10:00:00.000000 | 0 | 0 | \(s\) |
-- | 1 | 1 | 1 | 1 | 3 | 2023-09-11 08:00:00.000000 | 1 | 5 | \(s\) |
-- | 4 | 1 | 1 | 1 | 3 | 2023-09-11 00:00:00.000000 | 1 | 5 | \(s\) |
-- | 5 | 1 | 1 | 1 | 3 | 2023-09-16 11:00:00.000000 | 1 | 3 | \(s\)Comming late |
-- | 6 | 1 | 1 | 1 | 3 | 2023-09-17 17:00:00.000000 | 1 | 5 | \(s\) |
-- | 8 | 2 | 1 | 5 | 3 | 2023-09-17 18:00:00.000000 | 1 | 4 | \(s\) |
-- | 9 | 2 | 1 | 4 | 3 | 2023-09-17 10:00:00.000000 | 1 | 4 | \(s\) |
-- | 10 | 2 | 1 | 5 | 3 | 2023-09-18 17:00:00.000000 | 1 | 4 | \(s\) |

-- Напишите оператор, удаляющий все заказы по combing-у,
-- которые еще не выполнены (“Мы приостанавливаем оказание этой услугу из-за не продления лицензии”).

DELETE
FROM order1 o
WHERE o.service_id IN (SELECT s.service_id FROM service s WHERE s.name = 'Combing')
  AND o.is_done = 0;

-- RESULT AFTER REMOVE
-- postgres.public> DELETE
--                  FROM order1 o
--                  WHERE o.service_id IN (SELECT s.service_id FROM service s WHERE s.name = 'Combing')
--                    AND o.is_done = 0
-- [2024-10-20 02:57:07] 2 rows affected in 12 ms

---------------------------------------------------------------
-- Напишите оператор, добавляющий в таблицу PERSON новое физическое
-- лицо с сохранением последовательной нумерации записей
-- (используйте вложенный select с “max(…) + 1”).

INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES ((SELECT MAX(Person_ID) + 1 FROM Person),
        'Pavlushkin',
        'Dmitrii',
        '+88005553535',
        'Pushkina, Dom Kolotushkina');

-- Создайте в базе новую таблицу для хранения данных о документах физ.лиц (вид и номер документа).
-- При создании связи от нее к таблице PERSON укажите свойства каскадности редактирования и удаления.

CREATE TABLE IF NOT EXISTS Document
(
    Document_ID SERIAL,
    Person_ID   INT,
    Doc_type    VARCHAR(20) NOT NULL,
    Doc_number  VARCHAR(20) NOT NULL,
    CONSTRAINT Document_PK PRIMARY KEY (Document_ID)
);

ALTER TABLE
    Document
    ADD
        CONSTRAINT FK_Document_Person FOREIGN KEY (Person_ID) REFERENCES Person (Person_ID)
            ON UPDATE CASCADE ON DELETE CASCADE;

-- Добавьте в нее пару документов для только что созданного нового физ.лица.
INSERT INTO Document (Person_ID, Doc_type, Doc_number)
VALUES (11, 'passport', '102030'),
       (11, 'driving_licence', '112233'),
       (11, 'SNILS', '332211');

-- Изменение Person_ID
UPDATE person p
SET Person_ID=322
WHERE p.last_name = 'Pavlushkin';

-- Результат в Document
-- | document\_id | person\_id | doc\_type | doc\_number |
-- | :--- | :--- | :--- | :--- |
-- | 1 | 322 | passport | 102030 |
-- | 2 | 322 | driving\_licence | 112233 |
-- | 3 | 322 | SNILS | 332211 |

DELETE
FROM person p
WHERE p.last_name = 'Pavlushkin'

-- Таблица Document стала пустой из-за каскада
