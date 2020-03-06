--------------------------
-- Create schema objects
--------------------------

CONNECT app_data/appdatapassword

CREATE TABLE jobs#
(
    job_id      VARCHAR2(10)
                CONSTRAINT  jobs_pk PRIMARY KEY,
    job_title   VARCHAR2(35)
                CONSTRAINT  jobs_job_title_not_null NOT NULL,
    min_salary  NUMBER(6)
                CONSTRAINT  jobs_min_salary_not_null NOT NULL,
    max_salary  NUMBER(6)
                CONSTRAINT  jobs_max_salary_not_null NOT NULL
)

CREATE TABLE departments#
(
    department_id   NUMBER(4)
                    CONSTRAINT  departments_pk PRIMARY KEY,
    department_name VARCHAR2(20)
                    CONSTRAINT  dept_department_name_not_null NOT NULL
                    CONSTRAINT  dept_department_name_unique UNIQUE,
    manager_id      NUMBER(6)
)

CREATE TABLE employees#
(
    employee_id     NUMBER(6)
                    CONSTRAINT  employees_pk PRIMARY KEY,
    first_name      VARCHAR2(20)
                    CONSTRAINT  emp_first_name_not_null NOT NULL,
    last_name       VARCHAR2(25)
                    CONSTRAINT  emp_last_name_not_null NOT NULL,
    email_address   VARCHAR2(25)
                    CONSTRAINT  emp_email_address_not_null NOT NULL,
    hire_date       DATE DEFAULT TRUNC(SYSDATE)
                    CONSTRAINT  emp_hire_date_not_null NOT NULL
                    CONSTRAINT  emp_hire_date_check CHECK(TRUNC(HIRE_DATE) = hire_date),
    country_code    VARCHAR2(5)
                    CONSTRAINT  emp_country_code_not_null NOT NULL,
    phone_number    VARCHAR2(20)
                    CONSTRAINT  emp_phone_number_not_null NOT NULL,
    job_id          CONSTRAINT  emp_job_id_not_null NOT NULL
                    CONSTRAINT  emp_to_jobs_fk REFERENCES jobs#,
    job_start_date  DATE
                    CONSTRAINT  emp_job_start_date_not_null NOT NULL
                    CONSTRAINT  emp_job_start_date_check CHECK(TRUNC(JOB_START_DATE) = job_start_date)),
    salary          NUMBER(6)
                    CONSTRAINT  emp_salary_not_null NOT NULL,
    manager_id      CONSTRAINT  emp_mgrid_to_emp_empid_fk REFERENCES employees#,
    department_id   CONSTRAINT  emp_to_dept_fk REFERENCES departments#
)

CREATE TABLE job_history#
(
    employee_id     CONSTRAINT job_hist_to_emp_fk REFERENCES employees#,
    job_id          CONSTRAINT job_hist_to_jobs_fk REFERENCES jobs#,
    start_date      DATE
                    CONSTRAINT job_hist_start_date_not_null NOT NULL,
    end_date        DATE
                    CONSTRAINT job_hist_end_date_not_null NOT NULL,
    department_id   CONSTRAINT job_hist_to_dept_fk REFERENCES departments#
                    CONSTRAINT job_hist_dept_id_not_null NOT NULL,
                    CONSTRAINT job_history_pk PRIMARY KEY(employee_id, start_date),
                    CONSTRAINT job_history_date_check CHECK(start_date < end_date)
)

CREATE EDITIONING VIEW jobs AS SELECT * FROM jobs#

CREATE EDITIONING VIEW departments AS SELECT * FROM departments#

CREATE EDITIONING VIEW employees AS SELECT * FROM employees#

CREATE EDITIONING VIEW job_history AS SELECT * FROM job_history#

--------------
-- Load data
--------------

INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
SELECT job_id, job_title, min_salary, max_salary
FROM HR.JOBS

INSERT INTO departments(department_id, department_name, manager_id)
SELECT department_id, department_name, manager_id
FROM HR.DEPARTMENTS

--------------------------------
-- Add foreign key constraints
--------------------------------

------------------------------------------------
-- Grant privileges on schema objects to users
------------------------------------------------