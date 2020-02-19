DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS title;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS dept_manager;


CREATE TABLE departments (
  dept_no varchar not null primary key,
  dept_name varchar);

CREATE TABLE dept_emp (
  "emp_no" varchar not null,
  "dept_no" varchar not null,
  "from_date" varchar,
  "to_date" varchar,
   foreign key (emp_no) references employees (emp_no),
   foreign key (dept_no) references departments (dept_no));

CREATE TABLE dept_manager (
  dept_no varchar not null,
  emp_no varchar not null,
  from_date varchar,
  to_date varchar,
  FOREIGN KEY (emp_no) references employees (emp_no),
  FOREIGN KEY (dept_no) references departments (dept_no));


CREATE TABLE employees (
    emp_no varchar not null primary key,
    birth_date varchar,
    first_name varchar,
    last_name varchar,
    gender varchar,
    hire_date date);
   
create table salaries (
	emp_no varchar not null,
	salary varchar not null,
	from_date varchar,
	to_date varchar,
    FOREIGN KEY (emp_no) references employees (emp_no));

CREATE TABLE title (
    emp_no varchar not null,
    title varchar,
    from_date varchar,
    to_date varchar,
    FOREIGN KEY (emp_no) references employees (emp_no));
   
   
COPY departments from '/Users/Shared/data/departments.csv' delimiter ',' csv HEADER;
copy employees(emp_no, birth_date, first_name, last_name, gender, hire_date) from '/Users/Shared/data/employees.csv' delimiter ',' csv header;

COPY dept_emp(emp_no, dept_no, from_date, to_date) FROM '/Users/Shared/data/dept_emp.csv' DELIMITER ',' csv header;
copy dept_manager(dept_no, emp_no, from_date, to_date) from '/Users/Shared/data/dept_manager.csv' DELIMITER ',' csv HEADER;
copy salaries(emp_no, salary, from_date, to_date) from '/Users/Shared/data/salaries.csv' delimiter ',' csv header;
copy title(emp_no, title, from_date, to_date) from '/Users/Shared/data/titles.csv' delimiter ',' csv header;


--List the following details of each employee: employee number, last name, first name, gender, and salary
SELECT employees.emp_no, employees.last_name, employees.first_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

--List employees who were hired in 1986
SELECT last_name,first_name,hire_date
FROM employees
WHERE hire_date BETWEEN '1986/1/1' AND '1986/12/31';

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name, 
--and start and end employment dates
SELECT dept_manager.dept_no,departments.dept_name,employees.emp_no,employees.first_name,employees.last_name,dept_manager.from_date,dept_manager.to_date
FROM dept_manager
JOIN departments
	ON dept_manager.dept_no = departments.dept_no
JOIN employees
	ON dept_manager.emp_no = employees.emp_no;
	
--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
WHERE to_date IN
(
	SELECT to_date
	FROM dept_emp
	WHERE to_date ='9999-01-01'
);

--List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM employees
WHERE first_name ='Hercules'
AND last_name LIKE 'B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name
SELECT dept_emp.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM dept_emp
JOIN departments
	ON dept_emp.dept_no = departments.dept_no
JOIN employees
	ON dept_emp.emp_no = employees.emp_no
WHERE dept_emp.dept_no IN
(
	SELECT dept_no
	FROM departments
	WHERE dept_name ='Sales'
);

--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name
SELECT dept_emp.emp_no,employees.last_name,employees.first_name,departments.dept_name
FROM dept_emp
JOIN departments
	ON dept_emp.dept_no = departments.dept_no
JOIN employees
	ON dept_emp.emp_no = employees.emp_no
WHERE dept_emp.dept_no IN
(
	SELECT dept_no
	FROM departments
	WHERE dept_name ='Sales' OR dept_name ='Development'
);

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name
SELECT last_name, COUNT(last_name) AS "Count of Last Name"
FROM employees
GROUP BY last_name;