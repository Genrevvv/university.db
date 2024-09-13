-- Represent people that you met in the university (instructors, classmates, etc.)
CREATE TABLE "people" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "gender" TEXT NOT NULL CHECK("gender" IN ('male', 'female')),
    "birthdate" NUMERIC,
    "role" TEXT NOT NULL CHECK("role" IN ('instructor', 'classmate', 'other')),
    PRIMARY KEY("id")
);

-- Represent the courses you took or will take
CREATE TABLE "courses" (
    "id" INTEGER,
    "course_code" TEXT UNIQUE NOT NULL,
    "title" TEXT NOT NULL,
    "units" REAL CHECK("units" > 0) NOT NULL,
    "semester" INTEGER NOT NULL,
    "year_level" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    UNIQUE("course_code", "title", "semester", "year_level")
);

-- Represent a relationship for instructors and courses
CREATE TABLE "teaches" (
    "instructor_id" INTEGER,
    "course_id" INTEGER,
    PRIMARY KEY("instructor_id", "course_id"),
    FOREIGN KEY("instructor_id") REFERENCES "people"("id") ON DELETE CASCADE,
    FOREIGN KEY("course_id") REFERENCES "courses"("id") ON DELETE CASCADE
);

-- Represent the coursework you completed
CREATE TABLE "courseworks" (
    "id" INTEGER,
    "course_id" INTEGER,
    "title" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "grade" REAL CHECK("grade" >= 0 AND "grade" <= 1),
    "date" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id") ON DELETE CASCADE
);

-- Represent your educational expenses during your time at the university
CREATE TABLE "expenses" (
    "id" INTEGER,
    "course_id" INTEGER DEFAULT NULL,
    "year_level" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "amount" REAL NOT NULL CHECK("amount" > 0),
    "date" NUMERIC NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id") ON DELETE SET NULL
);

-- Create indexes to speed up common searches
CREATE INDEX "people_name_search" ON "people"("first_name", "last_name");
CREATE INDEX "people_role_search" ON "people"("role");
CREATE INDEX "course_title_search" ON "courses"("title");
CREATE INDEX "coursework_search" ON "courseworks"("type", "date");

-- View to fetch data about instructors
CREATE VIEW "instructors" AS
    SELECT "id", "first_name", "last_name", "gender", "birthdate"
    FROM "people"
    WHERE "role" = 'instructor';

-- View to fetch data about classmates
CREATE VIEW "classmates" AS
    SELECT "id", "first_name", "last_name", "gender", "birthdate"
    FROM "people"
    WHERE "role" = 'classmate';

-- View to fetch total expenses by year level
CREATE VIEW "expenses_by_year_level" AS
    SELECT "year_level", SUM("amount") as "total_expenses"
    FROM "expenses"
    GROUP BY "year_level"
    ORDER by "year_level" DESC, "total_expenses" DESC;

-- View to fetch total expenses by course
CREATE VIEW "expenses_by_course" AS
    SELECT "title","courses"."year_level" AS "year_level", "semester", SUM("amount") as "total_expenses"
    FROM "expenses"
    JOIN "courses" ON "courses"."id" = "expenses"."course_id"
    GROUP BY "courses"."id"
    ORDER by "title" DESC, "total_expenses" DESC;

/*
DROP TABLE "teaches";
DROP TABLE "people";
DROP TABLE "courses";
DROP TABLE "courseworks";
DROP TABLE "expenses";

DROP INDEX "people_name_search";
DROP INDEX "people_role_search";
DROP INDEX "course_title_search";
DROP INDEX "coursework_search";

DROP VIEW "instructors";
DROP VIEW "classmates";
DROP VIEW "total_expenses_by_year_level";
DROP VIEW "total_expenses_by_course";
*/
