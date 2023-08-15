/**************************************************************
* This script imports data into the stu_db database
***************************************************************/

USE stu_db;

# Visualizing the Schema
DESCRIBE med;
DESCRIBE edu;
DESCRIBE fam;
DESCRIBE parprof;
DESCRIBE time;
DESCRIBE courses;
DESCRIBE supp;
DESCRIBE alc;
DESCRIBE math;
DESCRIBE port;

# Importing the data
SELECT * FROM stu_math;
SELECT * FROM stu_port;

# Merging the data
SELECT * FROM stu_math
UNION
SELECT * FROM stu_port;

# FINALLY!!!!! query to see if part of tuple in one table exists in part of tuple in other table
SELECT school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences FROM stu_math m
WHERE EXISTS 
	(SELECT * FROM stu_port p
    WHERE (m.school, m.sex, m.age, m.address, m.famsize, m.Pstatus, m.Medu, m.Fedu, m.Mjob, 
m.Fjob, m.reason, m.guardian, m.traveltime, m.studytime, m.failures, m.schoolsup, m.famsup, 
m.paid, m.activities, m.nursery, m.higher, m.internet, m.romantic, m.famrel, m.freetime, 
m.goout, m.Dalc, m.Walc, m.health, m.absences) = 
(p.school, p.sex, p.age, p.address, p.famsize, p.Pstatus, p.Medu, p.Fedu, p.Mjob, 
p.Fjob, p.reason, p.guardian, p.traveltime, p.studytime, p.failures, p.schoolsup, p.famsup, 
p.paid, p.activities, p.nursery, p.higher, p.internet, p.romantic, p.famrel, p.freetime, 
p.goout, p.Dalc, p.Walc, p.health, p.absences)
    );

# see an example student who took both math and portuguese, so only G1, G2, and G3 attributes are different
SELECT * FROM stu_math
WHERE school='GP' AND sex='M' AND age=16 AND address='U' AND famsize='LE3' AND Pstatus='T' AND Medu=2 AND Fedu=2 AND reason='home'
UNION
SELECT * FROM stu_port
WHERE school='GP' AND sex='M' AND age=16 AND address='U' AND famsize='LE3' AND Pstatus='T' AND Medu=2 AND Fedu=2 AND reason='home';

-- GP	M	16	U	LE3	T	2	2	other	other	home	mother	1	2	0	no	no	no	no	yes	yes	yes	no	4	4	4	1	1	3	0	12	12	11
-- GP	M	16	U	LE3	T	2	2	other	other	home	mother	1	2	0	no	no	no	no	yes	yes	yes	no	4	4	4	1	1	3	0	13	12	13

# add a student id to the portuguese students table!!
ALTER TABLE stu_port ADD COLUMN sid INT NOT NULL PRIMARY KEY auto_increment;
DESCRIBE stu_port;
SELECT * FROM stu_port;

-- # turn all yes/no into y/n
-- SET SQL_SAFE_UPDATES = 0;
-- UPDATE stu_port
-- SET schoolsup =
-- 	CASE
-- 		WHEN schoolsup = 'y' THEN 'yes'
--         ELSE 'no'
--     END;
-- SELECT * FROM stu_port;
-- SET SQL_SAFE_UPDATES = 1;

# just change the y/n to allow five characters instead... easier to read
ALTER TABLE supp MODIFY COLUMN schoolsup VARCHAR(5);
ALTER TABLE supp MODIFY COLUMN famsup VARCHAR(5);
ALTER TABLE supp MODIFY COLUMN paid VARCHAR(5);
ALTER TABLE time MODIFY COLUMN activities VARCHAR(5);
ALTER TABLE edu MODIFY COLUMN nursery VARCHAR(5);
ALTER TABLE edu MODIFY COLUMN higher VARCHAR(5);
ALTER TABLE supp MODIFY COLUMN internet VARCHAR(5);
ALTER TABLE time MODIFY COLUMN romantic VARCHAR(5);

# insert values form portuguese students table!!
INSERT INTO med
SELECT sid, sex, age, health FROM stu_port;

INSERT INTO alc
SELECT sid, Dalc, Walc FROM stu_port;

INSERT INTO courses
SELECT sid, absences, failures FROM stu_port;

INSERT INTO edu
SELECT sid, nursery, school, reason, higher FROM stu_port;

INSERT INTO fam
SELECT sid, address, famsize, Pstatus, guardian, famrel FROM stu_port;

INSERT INTO port
SELECT sid, G1, G2, G3 FROM stu_port;

INSERT INTO parprof
SELECT sid, Medu, Fedu, Mjob, Fjob FROM stu_port;

INSERT INTO supp
SELECT sid, schoolsup, famsup, paid, internet FROM stu_port;

INSERT INTO time
SELECT sid, traveltime, studytime, activities, romantic, freetime, goout FROM stu_port;

# test it!
SELECT * FROM supp;
SELECT * FROM parprof;

# now the hard part--> adding the math table insert
# start with those with the same id
INSERT INTO math
SELECT sid, m.G1, m.G2, m.G3
FROM stu_math m
INNER JOIN
stu_port p
USING (school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences)
ORDER BY sid;

# add unique key (not primary, so it can start out null) sid to math
ALTER TABLE stu_math ADD COLUMN sid INT NULL UNIQUE auto_increment;
ALTER TABLE stu_math AUTO_INCREMENT = 650;
DESCRIBE stu_math;
SELECT * FROM stu_math;

# see who was not in the port class
SELECT sid, m.G1, m.G2, m.G3
FROM stu_math m
LEFT JOIN
stu_port p
USING (school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences)
WHERE sid IS NULL
ORDER BY sid;

# acquire IDs for everyone who didn't already get assigned one in the portuguese table!
SET @nextsid := 649;
UPDATE stu_math
SET sid =
CASE
	WHEN (school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences) 
	NOT IN (SELECT school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences FROM stu_port) 
	THEN @nextsid := @nextsid + 1
    
	ELSE NULL
END;
SET SQL_SAFE_UPDATES = 1;

# check that it worked!!! it did!!!!!!
SELECT m.sid msid, m.G1, m.G2, m.G3, p.sid psid, p.G1, p.G2, p.G3
FROM stu_math m
LEFT JOIN
stu_port p
USING (school, sex, age, address, famsize, Pstatus, Medu, Fedu, Mjob, 
Fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, 
paid, activities, nursery, higher, internet, romantic, famrel, freetime, 
goout, Dalc, Walc, health, absences)
ORDER BY p.sid, m.sid;

SELECT * FROM stu_port;
SELECT * FROM stu_math;  -- the students with null sid's have sid's in the port table!! ot

# get students in math but not in port class
SELECT sid, G1, G2, G3
FROM stu_math
WHERE sid IS NOT NULL;

# insert values form math students table!!
INSERT INTO med
SELECT sid, sex, age, health FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO alc
SELECT sid, Dalc, Walc FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO courses
SELECT sid, absences, failures FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO edu
SELECT sid, nursery, school, reason, higher FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO fam
SELECT sid, address, famsize, Pstatus, guardian, famrel FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO math
SELECT sid, G1, G2, G3 FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO parprof
SELECT sid, Medu, Fedu, Mjob, Fjob FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO supp
SELECT sid, schoolsup, famsup, paid, internet FROM stu_math
WHERE sid IS NOT NULL;

INSERT INTO time
SELECT sid, traveltime, studytime, activities, romantic, freetime, goout FROM stu_math
WHERE sid IS NOT NULL;

# see if there is the correct number of rows in each table
SELECT * FROM med LIMIT 1010;  -- 1005 total students
SELECT * FROM port;  -- 649 students in portuguese
SELECT * FROM math;   -- 395 students in math
SELECT * FROM supp WHERE sid IN (SELECT sid FROM math) AND sid IN (SELECT sid FROM port) LIMIT 1010;   -- 39 students in both