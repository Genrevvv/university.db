-- Find all the instructors
SELECT * FROM "instructors";

-- Find all the classmates
SELECT * FROM "classmates";

-- Find all the people that are neither instructor or classmate
SELECT * FROM "people" WHERE "role" = 'other';

-- Find all the courseworks from a course
SELECT * FROM "courseworks"
WHERE "course_id" = (
    SELECT "course_id" FROM "teaches"
    WHERE "instructor_id" = (
        SELECT "id" FROM "people"
        WHERE "first_name" = 'Carter'
        AND "last_name" = 'Zenke'
        AND "role" = 'instructor'
    )
    AND "title" = 'Introduction to Databases with SQL'
);

-- Find all courses taught by Carter Zenke
SELECT "title", "semester", "year_level"
FROM "courses"
JOIN "teaches"
WHERE "instructor_id" = (
    SELECT "id" FROM "people"
    WHERE "role" = 'instructor'
    AND "first_name" = 'Carter'
    AND "last_name" = 'Zenke'
);

-- Check the total expenses by year_level
SELECT * FROM "total_expenses_by_year_level";

-- Check the total expenses by course
SELECT * FROM "total_expenses_by_course";

-- Add people
INSERT INTO "people" ("first_name", "last_name", "gender", "birthdate", "role")
VALUES  ('Carter', 'Zenke', 'male', NULL, 'instructor'),
        ('David', 'Malan', 'male', NULL, 'instructor'),
        ('Charlie', 'Card', 'male', NULL, 'classmate');

-- Add a course
INSERT INTO "courses" ("department", "title", "semester", "year_level")
VALUES ('Computer Science', 'Introduction to Databases with SQL', 1, 1);

-- Add a coursework
INSERT INTO "courseworks" ("course_id", "title", "type", "grade")
VALUES ((SELECT "id" FROM "courses"
         WHERE "department" = 'Computer Science'
         AND "title" = 'Introduction to Databases with SQL'
         AND "semester" = 1
         AND "year_level" = 1),
         'Act2', 'activity', 0.95);

-- Add an expense
INSERT INTO "expenses" ("course_id", "year_level", "name", "amount")
VALUES ((SELECT "id" FROM "courses"
         WHERE "department" = 'Computer Science'
         AND "title" = 'Introduction to Databases with SQL'
         AND "semester" = 1
         AND "year_level" = 1),
         1, 'charliecard', 281.50);

-- Update a person's birthdate
UPDATE "people"
SET "birthdate" = '2006-12-04'
WHERE "first_name" = 'Charlie'
AND "last_name" = 'Card'
AND "role" = 'classmate';

-- Remove a person
DELETE FROM "people"
WHERE "first_name" = 'Charlie'
AND "last_name" = 'Card'
AND "role" = 'classmate';

-- Remove a course
DELETE FROM "courses"
WHERE "department" = 'Computer Science'
AND "title" = 'Introduction to Databases with SQL'
AND "semester" = 1
AND "year_level" = 1

-- Remove a coursework
DELETE FROM "courseworks"
WHERE "course_id" = (
    SELECT "id" FROM "courses"
    WHERE "department" = 'Computer Science'
    AND "title" = 'Introduction to Databases with SQL'
    AND "semester" = 1
    AND "year_level" = 1
)
AND "title" = 'Act2'
AND "type" = 'activity';

-- Remove an expense
DELETE FROM "expenses"
WHERE "course_id" = (
    SELECT "id" FROM "courses"
    WHERE "department" = 'Computer Science'
    AND "title" = 'Introduction to Databases with SQL'
    AND "semester" = 1
    AND "year_level" = 1
)
AND "year_level" = 1
AND "name" = 'charliecard';
