create database CollegeManagementDB;

use CollegeManagementDB;

create table mst_Department(
	department_id INT identity(1,1) primary key,
	department_name varchar(100) not null,
	created_on datetime default current_timestamp
);

create table mst_Student(
	student_id int Identity(1,1) primary key,
	student_name varchar(100) not null,
	email varchar(150) unique not null,
	phone_number varchar(15) unique,
	department_id int not null,
	created_on datetime default current_timestamp,

	foreign key (department_id)
	references mst_department(department_id)
);

CREATE TABLE mst_course
(
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_fee DECIMAL(10,2) NOT NULL,
    department_id INT NOT NULL,
    created_on DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (department_id)
    REFERENCES mst_department(department_id)
);

create table tbl_Enrollment(
	enrollment_id int identity(1,1) primary key,
	student_id int not null,
	course_id int not null,
	enrollment_date datetime default current_timestamp,

	foreign key (student_id)
	references mst_Student(student_id),
	foreign key (course_id)
	references mst_course(course_id)
);

INSERT INTO mst_Department
(
    department_name
)
VALUES
('Computer Science'),
('Mechanical Engineering'),
('Civil Engineering'),
('Electronics');

INSERT INTO mst_Student
(
    student_name,
    email,
    phone_number,
    department_id
)
VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210', 1),

('Sneha Patil', 'sneha@gmail.com', '9876543211', 1),

('Amit Verma', 'amit@gmail.com', '9876543212', 2),

('Priya Nair', 'priya@gmail.com', '9876543213', 4);


INSERT INTO mst_course
(
    course_name,
    course_fee,
    department_id
)
VALUES
('Java Programming', 5000.00, 1),

('Database Management System', 4500.00, 1),

('Thermodynamics', 6000.00, 2),

('Digital Electronics', 5500.00, 4);


INSERT INTO tbl_Enrollment
(
    student_id,
    course_id
)
VALUES
(1, 1),

(1, 2),

(2, 1),

(3, 3),

(4, 4);

--view tables
SELECT
    student_id,
    student_name,
    email,
    phone_number,
    department_id
FROM mst_Student;

SELECT
    department_id,
    department_name,
    created_on
FROM mst_Department;

SELECT
    course_id,
    course_name,
    course_fee,
    department_id
FROM mst_course;

SELECT
    enrollment_id,
    student_id,
    course_id,
    enrollment_date
FROM tbl_Enrollment;

-- sql joins

-- inner join
SELECT
    s.student_name,
    d.department_name
FROM mst_Student s
INNER JOIN mst_Department d
ON s.department_id = d.department_id;

--left join
SELECT
    s.student_name,
    d.department_name
FROM mst_Student s
LEFT JOIN mst_Department d
ON s.department_id = d.department_id;

--right join
SELECT
    s.student_name,
    d.department_name
FROM mst_Student s
RIGHT JOIN mst_Department d
ON s.department_id = d.department_id;

-- full join
SELECT
    s.student_name,
    d.department_name
FROM mst_Student s
FULL JOIN mst_Department d
ON s.department_id = d.department_id;

-- cross join
SELECT
    s.student_name,
    c.course_name
FROM mst_Student s
CROSS JOIN mst_course c;

-- multi table join
SELECT
    s.student_name,
    c.course_name,
    d.department_name,
    e.enrollment_date
FROM tbl_Enrollment e

INNER JOIN mst_Student s
ON e.student_id = s.student_id

INNER JOIN mst_course c
ON e.course_id = c.course_id

INNER JOIN mst_Department d
ON s.department_id = d.department_id;


-- stored procedures

CREATE PROCEDURE usp_GetStudents
AS
BEGIN

    set nocount on;

    SELECT
        s.student_id,
        s.student_name,
        s.email,
        s.phone_number,
        d.department_name
    FROM mst_Student s
    INNER JOIN mst_Department d
    ON s.department_id = d.department_id;

END;

exec usp_GetStudents;


CREATE PROCEDURE usp_InsertStudent
    @student_name VARCHAR(100),
    @email VARCHAR(150),
    @phone_number VARCHAR(15),
    @department_id INT

AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO mst_Student
    (
        student_name,email,phone_number,department_id
    )
    VALUES
    (
        @student_name,@email,@phone_number,@department_id
    );

END;

EXEC usp_InsertStudent
    'Karan Mehta',
    'karan@gmail.com',
    '9876543222',
    1;


CREATE PROCEDURE usp_UpdateCourseFee

    @course_id INT,

    @new_fee DECIMAL(10,2)

AS
BEGIN

    SET NOCOUNT ON;

    UPDATE mst_course
    SET
        course_fee = @new_fee
    WHERE course_id = @course_id;

END;

EXEC usp_UpdateCourseFee
    1,
    7500.00;


CREATE PROCEDURE usp_GetEnrollmentDetails
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        s.student_name,
        c.course_name,
        d.department_name,
        e.enrollment_date
    FROM tbl_enrollment e

    INNER JOIN mst_student s
    ON e.student_id = s.student_id

    INNER JOIN mst_course c
    ON e.course_id = c.course_id

    INNER JOIN mst_department d
    ON s.department_id = d.department_id;

END;

EXEC usp_GetEnrollmentDetails;


-- errorLog_table
CREATE TABLE tbl_ErrorLog
(
    error_log_id INT IDENTITY(1,1) PRIMARY KEY,

    error_message VARCHAR(1000),

    error_procedure VARCHAR(200),

    error_line INT,

    error_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE PROCEDURE usp_InsertEnrollment

    @student_id INT,

    @course_id INT

AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO tbl_enrollment
        (
            student_id,
            course_id
        )
        VALUES
        (
            @student_id,
            @course_id
        );

        COMMIT;

    END TRY

    BEGIN CATCH

        ROLLBACK;

        INSERT INTO tbl_ErrorLog
        (
            error_message,
            error_procedure,
            error_line
        )
        VALUES
        (
            ERROR_MESSAGE(),
            ERROR_PROCEDURE(),
            ERROR_LINE()
        );

    END CATCH

END;

EXEC usp_InsertEnrollment
    1,
    1;

EXEC usp_InsertEnrollment
    999,
    1;

SELECT
    error_log_id,
    error_message,
    error_procedure,
    error_line,
    error_date
FROM tbl_ErrorLog;

-- CREATE USER DEFINED TABLE TYPE
CREATE TYPE StudentTableType AS TABLE
(
    student_name VARCHAR(100),

    email VARCHAR(150),

    phone_number VARCHAR(15),

    department_id INT
);


CREATE PROCEDURE usp_BulkInsertStudents

    @StudentData StudentTableType READONLY

AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO mst_student
    (
        student_name,
        email,
        phone_number,
        department_id
    )

    SELECT
        student_name,
        email,
        phone_number,
        department_id
    FROM @StudentData;

END;

DECLARE @Students StudentTableType;


INSERT INTO @Students
(
    student_name,
    email,
    phone_number,
    department_id
)
VALUES

('Karan Mehta', 'karan@gmail.com', '9876500001', 1),

('Anjali Sharma', 'anjali@gmail.com', '9876500002', 2),

('Rohit Verma', 'rohit@gmail.com', '9876500003', 1);


EXEC usp_BulkInsertStudents
    @Students;

SELECT
    student_id,
    student_name,
    email,
    department_id
FROM mst_student;