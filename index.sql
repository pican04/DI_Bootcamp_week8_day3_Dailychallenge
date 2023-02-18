-- PART I
-- 1- Create 2 tables: Customer and Customer Profile. They have a One to One relationship.

-- table Customer 
CREATE TABLE Customer (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL
);

-- Table Customer profile 
CREATE TABLE Customer_profile (
  id SERIAL PRIMARY KEY,
  isLoggedIn BOOLEAN DEFAULT false,
  customer_id INTEGER REFERENCES Customer(id)
);

-- 2- Insert these clients (Jean, biche), (Jérôme, Lalu), (Léa, Rive)
INSERT INTO Customer (first_name, last_name) VALUES
('John', 'Doe'),
('Jerome', 'Lalu'),
('Lea', 'Rive');

-- 3- Insert these customer profiles, use subqueries
INSERT INTO Customer_profile (isLoggedIn, customer_id) VALUES
(true, (SELECT id FROM Customer WHERE first_name = 'John')),
(false, (SELECT id FROM Customer WHERE first_name = 'Jerome')));

-- 4- Use the relevant join types to display 
-- Le prénom des clients connectés
SELECT c.first_name 
FROM Customer c
JOIN Customer_profile cp ON c.id = cp.customer_id 
WHERE cp.isLoggedIn = true;

-- All first_name and isLoggedIn columns of clients - even clients who do not have a profile.
SELECT c.first_name, cp.isLoggedIn 
FROM Customer c
LEFT JOIN Customer_profile cp ON c.id = cp.customer_id;

-- The number of unconnected customers
SELECT COUNT(*) 
FROM Customer c
LEFT JOIN Customer_profile cp ON c.id = cp.customer_id
WHERE cp.id IS NULL OR cp.isLoggedIn = false;


--PART II
-- 1- Create a table named Book , with the columns: book_id SERIAL PRIMARY KEY, title NOT NULL,author NOT NULL
CREATE TABLE Book (
  book_id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL
);

-- 2- Insert these books:
--Alice In Wonderland, Lewis Carroll
--Harry Potter, JK Rowling
--To kill a mockingbird, Harper Lee
INSERT INTO Book (title, author) VALUES
('Alice In Wonderland', 'Lewis Carroll'),
('Harry Potter', 'J.K Rowling'),
('To kill a mockingbird', 'Harper Lee');

-- 3- Create a table named Student , with the columns: student_id SERIAL PRIMARY KEY, name NOT NULL UNIQUE, age. Make sure the age is never greater than 15 years (Look for an SQL method);
CREATE TABLE Student (
  student_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  age INTEGER CHECK (age <= 15)
);

-- 4- Insert these students :
-- Jean, 12 ans
-- Léra, 11 ans
-- Patrick, 10 ans
-- Bob, 14 ans
INSERT INTO Student (name, age) VALUES
('John', 12),
('Lera', 11),
('Patrick', 10),
('Bob', 14);

-- 5- Create a table named Library , with the columns :
-- book_fk_id ON DELETE CASCADE ON UPDATE CASCADE
-- student_id ON DELETE CASCADE ON UPDATE CASCADE
-- borrowed_date
CREATE TABLE Library (
  book_fk_id INTEGER REFERENCES Book(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
  student_fk_id INTEGER REFERENCES Student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
  borrowed_date DATE,
  PRIMARY KEY (book_fk_id, student_fk_id)
);

-- 6- Ajoutez 4 enregistrements dans la table de jonction, utilisez des sous-requêtes.
INSERT INTO Library (book_fk_id, student_fk_id, borrowed_date) VALUES
((SELECT book_id FROM Book WHERE title = 'Alice In Wonderland'), (SELECT student_id FROM Student WHERE name = 'John'), '2022-02-15'),
((SELECT book_id FROM Book WHERE title = 'To kill a mockingbird'), (SELECT student_id FROM Student WHERE name = 'Bob'), '2021-03-03'),
((SELECT book_id FROM Book WHERE title = 'Alice In Wonderland'), (SELECT student_id FROM Student WHERE name = 'Lera'), '2021-05-23'),
((SELECT book_id FROM Book WHERE title = 'Harry Potter'), (SELECT student_id FROM Student WHERE name = 'Bob'), '2021-08-12');

-- 7- Afficher les données
SELECT * FROM Library;

SELECT s.name, b.title 
FROM Student;
