

use Hospitals
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'sy')
BEGIN
    EXEC('CREATE SCHEMA sy')

END
GO

IF OBJECT_ID('sy.Doctor', 'U') IS NULL
BEGIN

create table sy.Doctor
(
Doctor_ID int primary key,
Doctor_Name varchar(20),
Doctor_Age int,
Doctor_Email varchar(70),
DoctorSpecialty varchar (30),
Doctor_Years_Of_Experience int
)
end

IF OBJECT_ID('sy.Patient', 'U') IS NULL
BEGIN

create table sy.Patient
(
Patient_UR int primary key,
Patient_Health_Numbers int , 
Patient_Age int,
Patient_Address varchar(20),
Patient_Name varchar(20),
Patient_Number int,
Doctor_ID int ,
CONSTRAINT FK_Patient_Doctor
FOREIGN KEY (Doctor_ID)
REFERENCES sy.Doctor(Doctor_ID)
)
end
alter table sy.Patient
add Patient_Email varchar(50)

IF OBJECT_ID('sy.Medications', 'U') IS NULL
BEGIN
create table sy.Medications
(
Medications_DrugName varchar(20) primary key,
Medications_strength varchar(20)
)
end 

IF OBJECT_ID('sy.company', 'U') IS NULL
BEGIN 

create table sy.company
(
Company_Name varchar (25),
Company_Number int ,
Company_Address varchar (30),
Medications_DrugName varchar (20),

CONSTRAINT FK_company_Medications
FOREIGN KEY (Medications_DrugName)
REFERENCES sy.Medications(Medications_DrugName)
)
end

IF OBJECT_ID('sy.Prescription', 'U') IS NULL
BEGIN 

create table sy.Prescription
(
Prescription_ID int primary key,
Date datetime ,
Quantity int,
Doctor_ID int ,
Patient_UR int ,
Medications_DrugName varchar (20), 
CONSTRAINT FK_Prescription_Doctor
FOREIGN KEY (Doctor_ID)
REFERENCES sy.Doctor(Doctor_ID),

CONSTRAINT FK_Prescription_Patient
FOREIGN KEY (Patient_UR)
REFERENCES sy.Patient(Patient_UR),

CONSTRAINT FK_Prescription_Medications
FOREIGN KEY (Medications_DrugName)
REFERENCES sy.Medications(Medications_DrugName)
)
end
-- 1 SELECT: Retrieve all columns from the Doctor table

select *
from sy.Doctor

-- 2 ORDER BY: List patients in the Patient table in ascending order of their ages.

select *
from sy.Patient 
order by Patient_Age asc

-- 3 OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.'\

select *
from sy.Patient
order by Patient_UR
offset 4 rows
fetch next 10 rows only

-- 4 SELECT TOP: Retrieve the top 5 doctors from the Doctor table.

select top 5* 
from sy.Doctor 
order by Doctor_ID 

-- 5 SELECT DISTINCT: Get a list of unique address from the Patient table.

select DISTINCT Patient_Address
from sy.Patient

-- 6 WHERE: Retrieve patients from the Patient table who are aged 25.

select *
from sy.Patient
where Patient_Age = 25 

-- 7 NULL: Retrieve patients from the Patient table whose email is not provided.

select * 
from sy.Patient
where Patient_Number is null

-- 8 AND: Retrieve doctors from the Doctor table who have experience
--greater than 5 years and specialize in 'Cardiology'.

select *
from sy.Doctor 
where Doctor_Years_Of_Experience = 5 
and DoctorSpecialty = 'Cardiology'

-- 9 IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'. 

select *
from sy.Doctor 
where DoctorSpecialty in ('Dermatology' , 'Oncology')

-- 10 BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.

select *
from sy.Patient
where Patient_Age >= 18 and Patient_Age <= 30

select *
from sy.Patient
where Patient_Age between 18 and 30

-- 11 LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.

select * 
from sy.Doctor 
where Doctor_Name like 'Dr%'

-- 12 Column & Table Aliases: Select the name and email of doctors, aliasing them as 
--'DoctorName' and 'DoctorEmail'.

select Doctor_Name  'Doctor_Names', Doctor_Email 'Doctor_Emails'
from sy.Doctor

-- 13 Joins: Retrieve all prescriptions with corresponding patient names.

select p.Prescription_ID,  p.Date, p.Quantity , pa.Patient_Name
from sy.Prescription p
join sy.Patient pa
on p.Patient_UR = pa.Patient_UR

-- 14 GROUP BY: Retrieve the count of patients grouped by their cities.

select Patient_Address, COUNT(*) As patienofadress
from sy.Patient
GROUP BY Patient_Address

-- 15 HAVING: Retrieve cities with more than 3 patients.

select Patient_Address, COUNT(*) As Number_of_adress_Patients_in_city
from sy.Patient
GROUP BY Patient_Address
HAVING COUNT(*) > 3

-- 16 EXISTS: Retrieve patients who have at least one prescription.

select *
from sy.Patient p
where EXISTS
(
select 1
from sy.Prescription pr 
where p.Patient_UR = pr.Patient_UR 
)

-- 17 UNION: Retrieve a combined list of doctors and patients.

select Doctor_Name as name
from sy.Doctor
 
UNION 

select Patient_Name as name
from sy.Patient

-- 18 INSERT: Insert a new doctor into the Doctor table.

INSERT into sy.Doctor (Doctor_ID,Doctor_Name)
values (21,'Zeyad')

-- 19 INSERT Multiple Rows: Insert multiple patients into the Patient table.

INSERT into sy.Patient (Patient_UR,Patient_Health_Numbers,Patient_Age,Patient_Address,Patient_Name,Doctor_ID
,Patient_Number,Patient_Email)
VALUES(21,70,23,'fysal 141', 'Sid',5,2456,'fhgd@dth.com'),
(22,66,33,'Harm 252', 'khalel',7,6456,'fdthd@dth.com'),
(23,64,28,'Giza 321', 'ahmed',3,4483,'fjlknu@dth.com')


-- 20 UPDATE: Update the phone number of a doctor.

alter table sy.Doctor 
add Number int

update sy.Doctor
set Number = 5425534
where Doctor_ID = 6

-- 21 UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.

update sy.Patient
set Patient_Address = 'Egypt'
from sy.Patient p
join sy.Prescription pa 
on p.Patient_UR = pa.Patient_UR
where pa.Doctor_ID = 3

-- 22 DELETE: Delete a patient from the Patient table.

delete 
from sy.Patient
where Patient_UR = 23

delete 
from sy.Doctor
where Doctor_ID = 21

-- 23 Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.

begin Transaction

INSERT into sy.Doctor (Doctor_ID,Doctor_Name,Doctor_Age,DoctorSpecialty,Doctor_Years_Of_Experience,Number,Doctor_Email)
values (25,'Zeyad',30,'Katuscha Covely',3,57484676,'suidia@dkfb.com')

INSERT into sy.Patient (Patient_UR,Patient_Health_Numbers,Patient_Age,Patient_Address,Patient_Name,Doctor_ID
,Patient_Number,Patient_Email)
VALUES(25,45,23,'Giza 141', 'hesham',25,1843,'fsthduirgf.com')

 COMMIT TRANSACTION;
 'Good By'