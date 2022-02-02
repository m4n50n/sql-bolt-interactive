/* SQL Lesson 1: SELECT queries 101 */
--1. Find the title of each film
SELECT Title
FROM Movies;

--2. Find the director of each film
SELECT Director
FROM Movies;

--3. Find the title and director of each film
SELECT Title, Director
FROM Movies;

--4. Find the title and year of each film
SELECT Title, Year
FROM Movies;

--5. Find all the information about each film
SELECT *
FROM Movies;

/* SQL Lesson 2: Queries with constraints (Pt. 1) */
--1. Find the movie with a row id of 6
SELECT *
FROM Movies
WHERE Id = 6;

--2. Find the movies released in the years between 2000 and 2010
SELECT *
FROM Movies
WHERE Year BETWEEN 2000 AND 2010;

--3. Find the movies not released in the years between 2000 and 2010
SELECT *
FROM Movies
WHERE Year NOT BETWEEN 2000 AND 2010;

--4. Find the first 5 Pixar movies and their release year
SELECT *
FROM Movies
LIMIT 5;

/* SQL Lesson 3: Queries with constraints (Pt. 2) */
--1. Find all the Toy Story movies
SELECT *
FROM Movies
WHERE Title LIKE '%Toy Story%';

--2. Find all the movies directed by John Lasseter
SELECT *
FROM Movies
WHERE Director = 'John Lasseter';

--3. Find all the movies (and director) not directed by John Lasseter
SELECT *
FROM Movies
WHERE Director <> 'John Lasseter';

--4. Find all the WALL-* movies
SELECT *
FROM Movies
WHERE Title LIKE 'WALL-%';

/* SQL Lesson 4: Filtering and sorting Query results */
--1. List all directors of Pixar movies (alphabetically), without duplicates
SELECT DISTINCT Director
FROM Movies
ORDER BY Director ASC;

--2. List the last four Pixar movies released (ordered from most recent to least)
SELECT *
FROM Movies
ORDER BY Year DESC
LIMIT 4;

--3. List the first five Pixar movies sorted alphabetically
SELECT *
FROM Movies
ORDER BY Title ASC
LIMIT 5;

--4. List the next five Pixar movies sorted alphabetically
SELECT *
FROM Movies
ORDER BY Title ASC
LIMIT 5
OFFSET 5;

/* SQL Review: Simple SELECT Queries */
--1. List all the Canadian cities and their populations
SELECT *
FROM North_american_cities
WHERE Country = 'Canada';

--2. Order all the cities in the United States by their latitude from north to south
SELECT *
FROM North_american_cities
WHERE Country = 'United States'
ORDER BY Latitude DESC;

--3. List all the cities west of Chicago, ordered from west to east
SELECT *
FROM North_american_cities
WHERE Longitude < (SELECT Longitude FROM North_american_cities WHERE City = 'Chicago')
ORDER BY Longitude ASC;

--4. List the two largest cities in Mexico (by population)
SELECT *
FROM North_american_cities
WHERE Country = 'Mexico'
ORDER BY Population DESC
LIMIT 2;

--5. List the third and fourth largest cities (by population) in the United States and their population
SELECT *
FROM North_american_cities
WHERE Country = 'United States'
ORDER BY Population DESC
LIMIT 2
OFFSET 2;

/* SQL Lesson 6: Multi-table queries with JOINs */
--1. Find the domestic and international sales for each movie
SELECT m.Title, b.International_sales, b.Domestic_sales
FROM Movies m
INNER JOIN Boxoffice b ON b.Movie_id = m.Id;

--2. Show the sales numbers for each movie that did better internationally rather than domestically
SELECT m.Title, b.International_sales, b.Domestic_sales
FROM Movies m
INNER JOIN Boxoffice b ON b.Movie_id = m.Id
WHERE b.International_sales > b.Domestic_sales;

--3. List all the movies by their ratings in descending order
SELECT m.Title, b.Rating
FROM Movies m
INNER JOIN Boxoffice b ON b.Movie_id = m.Id
ORDER BY b.Rating DESC;

/* SQL Lesson 7: OUTER JOINs */
--1. Find the list of all buildings that have employees
SELECT DISTINCT e.Building
FROM Employees e
LEFT JOIN Buildings b ON b.Building_name = e.Building
WHERE e.Years_employed NOT NULL;

--2. Find the list of all buildings and their capacity
SELECT *
FROM Buildings;

--3. List all buildings and the distinct employee roles in each building (including empty buildings)
SELECT DISTINCT b.Building_name, e.Role 
FROM Buildings b
LEFT JOIN Employees e ON e.Building = b.Building_name;

/* SQL Lesson 8: A short note on NULLs */
--1. Find the name and role of all employees who have not been assigned to a building
SELECT *
FROM Employees e
LEFT JOIN Buildings b ON b.Building_name = e.Building
WHERE e.Building IS NULL;

--2. Find the names of the buildings that hold no employees
SELECT *
FROM Buildings b
LEFT JOIN Employees e ON e.Building = b.Building_name
WHERE e.Building IS NULL;

/* SQL Lesson 9: Queries with expressions */
--1. List all movies and their combined sales in millions of dollars
SELECT m.Title, (b.Domestic_sales + b.International_sales) / 1000000 AS Total
FROM Movies m
LEFT JOIN Boxoffice b ON b.Movie_id = m.ID;

--2. List all movies and their ratings in percent
SELECT m.Title, b.Rating * 10 AS Percent
FROM Movies m
LEFT JOIN Boxoffice b ON b.Movie_id = m.ID;

--3. List all movies that were released on even number years
SELECT m.Title, m.Year
FROM Movies m
WHERE m.Year % 2 = 0;

/* SQL Lesson 10: Queries with aggregates (Pt. 1) */
--1. Find the longest time that an employee has been at the studio
SELECT MAX(Years_employed)
FROM Employees;

--2. For each role, find the average number of years employed by employees in that role
SELECT Role, AVG(Years_Employed) 
FROM Employees
GROUP BY Role;

--3. Find the total number of employee years worked in each building
SELECT Building, SUM(Years_Employed) 
FROM Employees
GROUP BY Building;

/* SQL Lesson 11: Queries with aggregates (Pt. 2) */
--1. Find the number of Artists in the studio (without a HAVING clause)
SELECT Role, COUNT(*) AS Total
FROM Employees
WHERE Role = 'Artist';

--2. Find the number of Employees of each role in the studio
SELECT Role, COUNT(*)
FROM Employees
GROUP BY Role;

--3. Find the total number of years employed by all Engineers
SELECT Role, SUM(Years_Employed)
FROM Employees
GROUP BY Role
HAVING Role = 'Engineer';

/* SQL Lesson 12: Order of execution of a Query */
--1. Find the number of movies each director has directed
SELECT Director, COUNT(*)
FROM Movies
GROUP BY Director;

--2. Find the total domestic and international sales that can be attributed to each director
SELECT m.Director, SUM(b.Domestic_sales + b.International_Sales) as Total
FROM Movies m
INNER JOIN Boxoffice b ON b.Movie_id = m.ID
GROUP BY m.Director;

/* SQL Lesson 13: Inserting rows */
--1. Add the studio's new production, Toy Story 4 to the list of movies (you can use any director)
INSERT INTO Movies (Id, Title, Director, Year, Length_minutes)
VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM Movies) , 'Toy Story 4', 'Peter Jackson', 2022, 666);

--2. Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.
INSERT INTO Boxoffice (Movie_id, Rating, Domestic_sales, International_Sales)
VALUES ((SELECT COALESCE(MAX(Movie_id), 0) + 1 FROM Boxoffice), 8.7, 340000000, 270000000);

/* SQL Lesson 14: Updating rows */
--1. The director for A Bug's Life is incorrect, it was actually directed by John Lasseter
UPDATE Movies
SET Director = 'John Lasseter'
WHERE Id = 2;

--2. The year that Toy Story 2 was released is incorrect, it was actually released in 1999
UPDATE Movies
SET Year = '1999'
WHERE Id = 3;

--3. Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by Lee Unkrich
UPDATE Movies
SET Title = 'Toy Story 3', Director = 'Lee Unkrich'
WHERE Id = 11;

/* SQL Lesson 15: Deleting rows */
--1. This database is getting too big, lets remove all movies that were released before 2005.
DELETE FROM Movies
WHERE Year < 2005;

--2. Andrew Stanton has also left the studio, so please remove all movies directed by him.
DELETE FROM Movies
WHERE Director = 'Andrew Stanton';

/* SQL Lesson 16: Creating tables */
/*
Create a new table named Database with the following columns:
    – Name A string (text) describing the name of the database
    – Version A number (floating point) of the latest version of this database
    – Download_count An integer count of the number of times this database was downloaded

This table has no constraints.
*/
CREATE TABLE Database (
    Name TEXT,
    Version FLOAT,
    Download_Count INTEGER
);

/* SQL Lesson 17: Altering tables */
--1. Add a column named Aspect_ratio with a FLOAT data type to store the aspect-ratio each movie was released in.
ALTER TABLE Movies
ADD COLUMN Aspect_ratio FLOAT;

--2. Add another column named Language with a TEXT data type to store the language that the movie was released in. Ensure that the default for this language is English.
ALTER TABLE Movies
ADD COLUMN Language TEXT DEFAULT 'English';

/* SQL Lesson 18: Dropping tables */
--1. We've sadly reached the end of our lessons, lets clean up by removing the Movies table
DROP TABLE Movies;

--2. And drop the BoxOffice table as well
DROP TABLE BoxOffice;
