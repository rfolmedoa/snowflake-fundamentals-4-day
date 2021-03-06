USE ROLE TRAINING_ROLE;
CREATE WAREHOUSE IF NOT EXISTS INSTRUCTOR1_WH;
USE WAREHOUSE INSTRUCTOR_WH;
CREATE DATABASE IF NOT EXISTS INSTRUCTOR1_DB;
CREATE SCHEMA TT_DEMO;
USE INSTRUCTOR1_DB.TT_DEMO;


-- NO TABLE... NO MAGIC HERE.
DESC TABLE T1;

-- CREATE A BASIC TABLE
CREATE TABLE T1 (C1 STRING, C2 STRING);

-- EMPTY TABLE
SELECT * FROM T1;

-- INSERT FIRST ROW
INSERT INTO T1 VALUES ('A', 'B');

-- INSERT SECOND ROW AND MAKE NOTE OF THE QUERY ID
INSERT INTO T1 VALUES ('C', 'D'); // 01902FDF-01DD-DF25-0000-328500C879EE 

-- INSERT THIRD ROW
INSERT INTO T1 VALUES ('E', 'F');

-- SELECT THE TABLE AND NOTE THERE HAVE BEEN 4 VERSIONS OF OF THE TABLE
SELECT * FROM T1;

-- COPY AND QID FOR THE C/D STATEMENT FROM ABOVE
-- NOTE THIS IS THE VERSION OF THE TABLE AFTER THE ABOVE FINISHED
SELECT * FROM T1 AT(STATEMENT => '01902FDF-01DD-DF25-0000-328500C879EE');
-- NOTE THAT THIS IS THE VERSION OF THE TABLE RIGHT BEFORE THE STATEMENT ABOVE
SELECT * FROM T1 BEFORE(STATEMENT => '01902FDF-01DD-DF25-0000-328500C879EE');

-- MIX THEM BOTH IN THE SAME QUERY TO FIND THINGS THAT HAVE CHANGED!
SELECT * FROM T1
MINUS 
SELECT * FROM T1 AT(STATEMENT => '01902FDF-01DD-DF25-0000-328500C879EE');



-- OOOOOPS... SILLY DBA, YOU DROPPED THE TABLE
DROP TABLE T1;
SELECT * FROM T1;
-- ANGRY USERS!!!!

-- HOW TO FIND THE TABLE WE DROPPED IF IT'S GONE?
SHOW TABLES HISTORY;
-- LET'S GET IT BACK
UNDROP TABLE T1;

-- HAPPY USERS
SELECT * FROM T1;

-- HOW TO FIX THE PROBLEM YOUR "FRIEND" CREATED WITH THEIR ERRANT ETL PROCESS?
-- NOTE THIS ISN'T PERFECT LOSES TT HISTORY IN CLONED OBJECT
-- LET'S CREATE A CLONE FOR A PARTICULAR POINT IN TIME.
CREATE TABLE T2 CLONE T1 AT(STATEMENT => '01902FDF-01DD-DF25-0000-328500C879EE');
-- LOOKS GOOD, BEFORE THE ISSUE
SELECT * FROM T2;
DROP TABLE T1;
ALTER TABLE T2 RENAME TO T1;
-- OR
ALTER TABLE T2 SWAP WITH T1;
SELECT * FROM T1;
SELECT * FROM T2;

-- REPLAY THE ETL NOW FROM THIS POINT IN TIME.
-- DROP DATABASE INSTRUCTOR1_DB;


