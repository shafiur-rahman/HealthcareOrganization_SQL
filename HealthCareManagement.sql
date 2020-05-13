drop table Treatment;
drop table Doctor;
drop table Patient_release;
drop table Patient;


---create table operation
create table Doctor(
D_id number(10) not null,
name varchar(20) not null,
speciality varchar(20) not null,
qualification varchar(20)
);

create table Patient(
P_id number(10) not null,
name varchar(10) not null,
age number not null,
address varchar(20) not null
);

create table Treatment(
Doctor_id number(10) not null,
Patient_id number(10) not null,
treatment_result varchar(20) not null,
treatment_date   VARCHAR(30)
);

create table Patient_release(
Patient_release_id number,
condition varchar(20) not null,
bill_paid varchar(10) not null,
bill_amount number (10)
);



--setting primary keys
ALTER TABLE Doctor ADD CONSTRAINT Doctor_id
	PRIMARY KEY (D_id);
ALTER TABLE Patient ADD CONSTRAINT Patient_id
	PRIMARY KEY (P_id);

ALTER TABLE Treatment ADD CONSTRAINT Treatment_foreign_key_doctor
	FOREIGN KEY (Doctor_id) REFERENCES Doctor (D_id) on delete cascade;

--setting foreign keys
ALTER TABLE Treatment ADD CONSTRAINT Treatment_foreign_key_patient
	FOREIGN KEY (Patient_id) REFERENCES Patient (P_id) on delete cascade;

ALTER TABLE Treatment ADD CONSTRAINT Treatment_primary_key
    PRIMARY KEY (Patient_id,Doctor_id);

ALTER TABLE Patient_release ADD CONSTRAINT release_foreign_key
	FOREIGN KEY (Patient_release_id) REFERENCES Patient (P_id) on delete cascade;



--using alter table commands
ALTER TABLE Patient 
ADD description VARCHAR(10); 
ALTER TABLE Patient 
MODIFY description VARCHAR(30);




---inserting values into tables
INSERT INTO Doctor(D_id, name, speciality, qualification) 
VALUES (1,'Dr. Abdur Rahman','Child Specialist', 
'MBBS'); 
INSERT INTO Doctor(D_id, name, speciality, qualification) 
VALUES (2,'Dr. Abir Hasan','Medicine Specialist', 
'FCPS'); 
INSERT INTO Doctor(D_id, name, speciality, qualification) 
VALUES (3,'Hasan Masud','Eye Specialist',
'MBBS'); 

INSERT INTO Doctor(D_id, name, speciality, qualification) 
VALUES (4,'Samiha Samad','Eye Specialist',
'MBBS'); 

INSERT INTO Doctor(D_id, name, speciality, qualification) 
VALUES (5,'Samiha Samad','Eye Specialist',
'MBBS'); 

INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (101,'Salam',21,'Dhaka', 
'Having fever,hedeach');

INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (102,'Kalam',21,'Dhaka', 
'Having fever,hedeach,rash,pain');

INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (103,'Rahim',12,'Khulna', 
'Having fever');

INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (104,'karim',13,'Mymensingh', 
'Having fever,hedeach');

INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (105,'Rahman',21,'Dhaka',
'Eye Problem');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (1,101,'10 days rest','12/12/15');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (1,102,'Medicine pescribed','13/12/15');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (2,103,'Medicine pescribed','6/6/15');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (2,104,'1 week rest ','9/2/15');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (1,104,'1 week rest ','11/2/15');

INSERT INTO Treatment(Doctor_id,Patient_id,treatment_result,treatment_date) 
VALUES (3,105,'revisit after 1 month','12/12/15');



--use of trigger
create or replace trigger check_bill before insert on Patient_release
    for each row
      declare
         bill_min constant integer := 0;
         bill_max constant integer := 15000;
      begin
          if :new.bill_amount > bill_max OR :new.bill_amount < bill_min THEN
          RAISE_APPLICATION_ERROR(-20000,'Bill is not valid');
      end if;
      end check_bill;
      /


INSERT INTO Patient_release(Patient_release_id,condition,bill_paid,bill_amount)
Values (101,'Ok','Yes',5000);
INSERT INTO Patient_release(Patient_release_id,condition,bill_paid,bill_amount)
Values (102,'Ok','Yes',15000);
INSERT INTO Patient_release(Patient_release_id,condition,bill_paid,bill_amount)
Values (103,'Not Ok','No',1000);
INSERT INTO Patient_release(Patient_release_id,condition,bill_paid,bill_amount)
Values (104,'Ok','No',0);
INSERT INTO Patient_release(Patient_release_id,condition,bill_paid,bill_amount)
Values (105,'Ok','Yes',5000);



---describe operation
describe Doctor;
describe Patient;
describe Treatment;
describe Patient_release;


---select operation
select * from Doctor;
select * from Patient;
select * from Treatment;

--update operation
update Patient_release set bill_amount = 20000 where bill_paid = 'No' and bill_amount=0;
update Treatment set treatment_result = 'revisit after 2 months' where treatment_result = 'revisit after 1 month';

--delete operation
 delete from Patient where P_id=105;


--use of group by,order by
select name,speciality from Doctor order by D_id asc;
select name,speciality from Doctor order by D_id desc;


--use of aggregate function
select COUNT(DISTINCT name) as number_of_doctor from Doctor;
select COUNT(DISTINCT name) as number_of_patient from Patient;
select max(bill_amount) from Patient_release;
select min(bill_amount) from Patient_release;
select sum(bill_amount) from Patient_release;
select avg(bill_amount) from Patient_release;
select name, COUNT(name) from Doctor group by name;



--use of query
select name,address as Children from Patient where age<=12;
SELECT name as Specialist from Doctor where speciality LIKE '%Eye Specialist%';
SELECT Patient_release_id from Patient_release where bill_amount IN (10000, 15000);
	


    
--use of subquery
select name as Doctors_giving_tretment from Doctor where D_id in
(select Doctor_id from Treatment where Doctor.D_id=Treatment.Doctor_id);

select name from Patient where P_id in 
(select Patient_release_id  from Patient_release where Patient.P_id=Patient_release.Patient_release_id);




---set operation
select D_id,name from Doctor where D_id=5 UNION select d.D_id,d.name from Doctor d where d.D_id IN 
(select  t.Doctor_id from Doctor d,Treatment t where d.D_id=t.Doctor_id);

select D_id,name from Doctor where D_id=1 intersect select d.D_id,d.name from Doctor d where d.D_id IN 
(select  t.Doctor_id from Doctor d,Treatment t where d.D_id=t.Doctor_id);

select p.P_id,p.name from Patient p  where  p.P_id IN 
(select  t.Patient_id from Patient p,Treatment t where p.P_id=t.Patient_id) minus select P_id,name from Patient where name='Rahim';


---use of join operation

SELECT  p.name, t.treatment_result,t.treatment_date
	FROM Patient p JOIN Treatment t
	ON p.P_id = t.Patient_id;

SELECT  p.name, r.bill_paid,r.bill_amount
	FROM Patient p INNER JOIN Patient_release r
	ON p.P_id = r.Patient_release_id;

SELECT  p.name, t.treatment_result,t.treatment_date
	FROM Patient p right OUTER JOIN Treatment t
	ON p.P_id = t.Patient_id;

SELECT  p.name, t.treatment_result,t.treatment_date
	FROM Patient p left OUTER JOIN Treatment t
	ON p.P_id = t.Patient_id;

SELECT  p.name, t.treatment_result,t.treatment_date
	FROM Patient p FULL OUTER JOIN Treatment t
	ON p.P_id = t.Patient_id;

SELECT  p.name, d.name
	FROM Patient p CROSS JOIN Doctor d;


---use of pl/sql
SET SERVEROUTPUT ON
DECLARE
   max_bill  Patient_release.bill_amount%type;
   p_name    Patient.name%type;
BEGIN
      SELECT MAX(bill_amount)  INTO max_bill  
   FROM Patient_release;

   SELECT name  INTO p_name 
   from Patient,Patient_release 
   where Patient.P_id=Patient_release.Patient_release_id and bill_amount=max_bill;
   DBMS_OUTPUT.PUT_LINE('The maximum bill is : ' || max_bill || ' and paid by ' || p_name );
 END;
/



--use of cursor
SET SERVEROUTPUT ON
DECLARE
CURSOR patient_cursor IS SELECT P_id, name FROM Patient;
patient_record patient_cursor%ROWTYPE;
BEGIN
OPEN patient_cursor;
LOOP
FETCH patient_cursor INTO patient_record;
EXIT WHEN patient_cursor%ROWCOUNT > 3;
DBMS_OUTPUT.PUT_LINE ('Patient Id : ' || patient_record.P_id || ' Patient name: ' || 
patient_record.name);
END LOOP;
CLOSE patient_cursor;
END;
/


--use of procedure
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE doctorname IS 
d_id1 Doctor.D_id%type := 2;
d_name Doctor.name%type;

BEGIN

select name into d_name 
 from Doctor where D_id=d_id1;
DBMS_OUTPUT.PUT_LINE('Doctors: '||d_name);
END doctorname;
/
SHOW ERRORS;
BEGIN
   doctorname;
END;
/



--use of function
CREATE OR REPLACE FUNCTION total_bill RETURN NUMBER IS
t_bill Patient_release.bill_amount%type;
BEGIN
SELECT SUM(bill_amount) INTO t_bill
FROM Patient_release;
RETURN t_bill;
END;
/
SET SERVEROUTPUT ON
BEGIN
dbms_output.put_line('Total bill: ' || total_bill);
END;
/



--use of rollback

select * from Patient;
   delete from Patient;
   rollback;
   select * from Patient;
   INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (106,'Sakib',21,'Mymensingh',
'Eye Problem');
   savepoint  cont_6;
   INSERT INTO Patient(P_id, name, age, address,description) 
VALUES (107,'Akib',21,'Dhaka',
'Having Fever');
   savepoint  cont_7;
   rollback to cont_7;
   select * from Patient;

   commit;
