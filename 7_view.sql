-- Создайте представление “Собаки” со следующими атрибутами:
-- кличка, порода, возраст, фамилия и имя хозяина.
-- Используя это представление, получите список пуделей: кличка, фамилия хозяина.

CREATE VIEW Dogs AS
SELECT pet.nick, pet.breed, pet.age, person.last_name, person.first_name
FROM person,
     pet,
     owner,
     pet_type
WHERE owner.owner_id = pet.owner_id
  AND owner.person_id = person.person_id
  AND pet.pet_type_id = pet_type.pet_type_id
  AND pet_type.name = 'DOG';

-- | nick | breed | age | last\_name | first\_name |
-- | :--- | :--- | :--- | :--- | :--- |
-- | Bobik | unknown | 3 | Petrov | Petia |
-- | Apelsin | poodle | 5 | Vasiliev | Vasia |
-- | Daniel | spaniel | 14 | Galkina | Galia |
-- | Markiz | poodle | 1 | Ivanov | Vano |

SELECT d.nick, d.last_name
FROM Dogs d
WHERE d.breed = 'poodle';

-- | nick | last\_name |
-- | :--- | :--- |
-- | Apelsin | Vasiliev |
-- | Markiz | Ivanov |

-- Создайте представление “Рейтинг сотрудников”: фамилия, имя, количество выполненных заказов,
-- средний балл (по оценке).
-- Используя это представление, выведите рейтинг с сортировкой по убыванию балла.

CREATE VIEW Employee_Rating AS
SELECT person.last_name, person.first_name, COUNT(*) as all_count, AVG(order1.mark) as average_mark
FROM person,
     order1,
     employee
WHERE person.person_id = employee.person_id
  AND order1.employee_id = employee.employee_id
  AND order1.is_done = 1
group by person.last_name, person.first_name;

-- | last\_name | first\_name | count | avg |
-- | :--- | :--- | :--- | :--- |
-- | Ivanov | Vania | 1 | 5 |
-- | Orlov | Oleg | 3 | 4.3333333333333333 |
-- | Vorobiev | Vova | 11 | 4.2727272727272727 |

SELECT *
FROM employee_rating
ORDER BY average_mark DESC;

-- | last\_name | first\_name | all\_count | average\_mark |
-- | :--- | :--- | :--- | :--- |
-- | Ivanov | Vania | 1 | 5 |
-- | Orlov | Oleg | 3 | 4.3333333333333333 |
-- | Vorobiev | Vova | 11 | 4.2727272727272727 |

-- Создайте представление “Заказчики”: фамилия, имя, телефон, адрес. Используя это представление, напишите оператор,
-- после выполнения которого у всех заказчиков без адреса в это поле добавится вопросительный знак.


-- CREATE VIEW Customers AS
-- SELECT p.last_name, p.first_name, p.phone, p.address
-- FROM person p
--          JOIN owner ON p.person_id = owner.person_id
--          JOIN order1 o ON owner.owner_id = o.owner_id
-- GROUP BY p.last_name, p.first_name, p.phone, p.address;

CREATE OR REPLACE VIEW Customers AS
SELECT DISTINCT p.last_name, p.first_name, p.phone, p.address
FROM person p
         JOIN owner ON p.person_id = owner.person_id
         JOIN order1 o ON owner.owner_id = o.owner_id;

-- | last\_name | first\_name | phone | address |
-- | :--- | :--- | :--- | :--- |
-- | Sokolov | S. | +7678901234 | Srednii pr VO, 27-1 |
-- | Ivanov | Vano | +7789012345 | Malyi pr VO, 33-2 |
-- | Vasiliev | Vasia | +7345678901 | Nevskii pr, 9-11 |
-- | Petrov | Petia | +79234567890 | Sadovaia ul, 17\\2-23 |
-- | Galkina | Galia | +7567890123 | 10 linia VO, 35-26 |

-- Так как все заказчики у нас с адресами, уберём это поле из нескольких, чтобы проверить
-- Работоспособность оператора.
-- Уберём поле адреса у Petrov Petia и Galkina Galia и обновим представление

UPDATE person
SET address = ''
WHERE last_name IN ('Petrov', 'Galkina');

-- | last\_name | first\_name | phone | address |
-- | :--- | :--- | :--- | :--- |
-- | Sokolov | S. | +7678901234 | Srednii pr VO, 27-1 |
-- | Petrov | Petia | +79234567890 |  |
-- | Ivanov | Vano | +7789012345 | Malyi pr VO, 33-2 |
-- | Vasiliev | Vasia | +7345678901 | Nevskii pr, 9-11 |
-- | Galkina | Galia | +7567890123 |  |


-- Теперь уже напишем оператор, позволяющий добавить вопросительный знак в пустое поле адресса представления
-- К сожалению, в postgresql нельзя писать update на представления, в которых есть логика group by или distinct
-- Мы можем написать триггер, который будет срабатывать в случае обновления строк в view Customers

CREATE OR REPLACE FUNCTION update_customers()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.address = '' THEN
        NEW.address = '?';
    END IF;

    -- Update the row in the actual table
    UPDATE person
    SET address = NEW.address
    WHERE last_name = NEW.last_name AND first_name = NEW.first_name;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instead_of_update_customers
    INSTEAD OF UPDATE ON Customers
    FOR EACH ROW
EXECUTE FUNCTION update_customers();


-- Пример SQL-запроса обновления строки в представлении "Customers"
-- При изменении адресса у Petrov Petia триггер будет срабатывать и ставить ? вместо пустой строки

UPDATE Customers
SET address = ''
WHERE last_name = 'Petrov' AND first_name = 'Petia';

-- | last\_name | first\_name | phone | address |
-- | :--- | :--- | :--- | :--- |
-- | Sokolov | S. | +7678901234 | Srednii pr VO, 27-1 |
-- | Ivanov | Vano | +7789012345 | Malyi pr VO, 33-2 |
-- | Vasiliev | Vasia | +7345678901 | Nevskii pr, 9-11 |
-- | Galkina | Galia | +7567890123 |  |
-- | Petrov | Petia | +79234567890 | ? |