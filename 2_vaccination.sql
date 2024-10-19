CREATE TABLE IF NOT EXISTS Vaccination_Type
(
    Vaccination_Type_ID SERIAL,
    Name                VARCHAR(50) NOT NULL,
    CONSTRAINT Vaccination_Type_PK PRIMARY KEY (Vaccination_Type_ID)
    );

CREATE TABLE IF NOT EXISTS Vaccination
(
    Vaccination_ID      SERIAL,
    Pet_ID              INTEGER NOT NULL,
    Vaccination_Type_ID INTEGER NOT NULL,
    Vaccination_Date    DATE    NOT NULL,
    Document_Scan       BYTEA,
    -- Здесь будет храниться скан документа о прививке в виде байт.

    CONSTRAINT Vaccination_PK PRIMARY KEY (Vaccination_ID),
    CONSTRAINT FK_Vaccination_Pet FOREIGN KEY (Pet_ID) REFERENCES Pet (Pet_ID),
    CONSTRAINT FK_Vaccination_Type FOREIGN KEY (Vaccination_Type_ID) REFERENCES Vaccination_Type (Vaccination_Type_ID)
    );

---------------------------------------------------------------
-- Заполнение таблиц (2-5 записями)
---------------------------------------------------------------

INSERT INTO vaccination_type (name)
VALUES ('Pfizer'),
       ('Moderna'),
       ('AstraZeneca'),
       ('Janssen');


INSERT INTO vaccination (pet_id, vaccination_type_id, vaccination_date)
VALUES (6, 1, '2022-01-01'),
       (7, 3, '2022-05-12'),
       (8, 4, '2022-06-20');


---------------------------------------------------------------
-- Удаление таблиц
---------------------------------------------------------------

-- DROP TABLE Vaccination;
-- DROP TABLE Vaccination_type