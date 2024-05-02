-- Exercises on HR database

USE hr_practice;

-- MySQL Aggregate Functions

-- 1. Write a query to list the number of jobs available in the employees table.

SELECT COUNT(DISTINCT job_id) AS NumberOFJobs
From employees;

-- 2. Write a query to get the total salaries payable to employees.

SELECT SUM(salary) AS TotalSalary
FROM employees;

-- 3. Write a query to get the minimum salary from employees table.

SELECT MIN(salary) AS MinimumSalary
FROM employees;

-- 4. Write a query to get the maximum salary of an employee working as a Programmer

SELECT MAX(e.salary) AS MaximumSalary
FROM employees e
	JOIN jobs j
	ON e.job_id = j.job_id
WHERE job_title = 'Programmer';

-- 5. Write a query to get the average salary and number of employees working at the department 90.

SELECT 	ROUND(AVG(salary),2) AS AverageSalary,
		COUNT(*)
FROM employees
WHERE department_id = 90;

-- 6. Write a query to get the highest, lowest, average, and sum salary of all employees.

SELECT 	COUNT(employee_id) AS Total_Employees,
		MAX(salary) AS Highest_Salary,
        MIN(salary) AS Lowest_Salary,
        AVG(salary) AS Averge_Salary,
        SUM(salary) AS Total_Salary
FROM employees;

-- 7. Write a query to get the number of employees with the same job.

SELECT 	j.job_title,
		COUNT(j.job_title) AS number_of_employees
FROM employees e
	JOIN jobs j
	ON e.job_id = j.job_id
GROUP BY j.job_title
ORDER BY number_of_employees DESC;

-- 8. Write a query to get the difference between the highest and lowest salaries.

SELECT 	MAX(salary) - MIN(salary) AS Difference
FROM employees;

-- 9. Write a query to find the manager ID and the salary of the lowest-paid employee for that manager.

SELECT 	manager_id,
		MIN(salary) AS MinimumSalary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY MinimumSalary ASC;

-- 10. Write a query to get the department ID and the total salary payable in each department.

SELECT 	manager_id,
		SUM(salary) AS TotalSalary
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
ORDER BY TotalSalary DESC;

-- 11. Write a query to get the average salary for each job ID excluding programmer.

SELECT 	e.job_id,
		j.job_title,
		ROUND(AVG(e.salary),2) AS AverageSalary
FROM employees e
	JOIN jobs j
	ON e.job_id = j.job_id
WHERE job_title <> 'Programmer'
GROUP BY e.job_id,
		 j.job_title
ORDER BY AverageSalary DESC ;

-- 12. Write a query to get the total salary, maximum, minimum, average salary of employees for department ID 90 only.

SELECT 	COUNT(employee_id) AS Total_Employees,
        SUM(salary) AS Total_Salary,
        MAX(salary) AS Highest_Salary,
        MIN(salary) AS Lowest_Salary,
        AVG(salary) AS Averge_Salary
FROM employees
WHERE department_id = 90;

-- 13. Write a query to get the job ID and maximum salary of the employees where maximum salary is greater than or equal to $4000.

SELECT 	job_id,
		MAX(salary) AS MaximumSalary
FROM employees
GROUP BY job_id
HAVING MaximumSalary >= 4000
ORDER BY MaximumSalary DESC;

-- 14. Write a query to get the average salary for all departments employing more than 5 employees.

SELECT 	department_id, 
		ROUND(AVG(salary),2) AS Average_Salary
FROM employees
GROUP BY department_id
HAVING COUNT(job_id) > 5
ORDER BY Average_Salary DESC; 

-- SubQueries

-- 1. Write a MySQL query to find the name (first_name, last_name) and the salary of the employees who have a higher salary than the employee whose last_name='Austin'.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary >
				(SELECT salary
		FROM employees
	WHERE last_name = 'Austin')
ORDER BY salary DESC; 

-- 2. Write a MySQL query to find the name (first_name, last_name) of all employees who works in the IT department.

-- Method 1
SELECT 	employees.first_name,
		employees.last_name
FROM employees
JOIN departments
ON employees.department_id = departments.department_id
WHERE department_name = (SELECT departments.department_name
FROM departments
WHERE department_name = 'IT');

-- Method 2
SELECT 	employees.first_name,
		employees.last_name
FROM employees
JOIN departments
ON employees.department_id = departments.department_id
WHERE department_name = 'IT';

-- Method 3
SELECT 	first_name,
		last_name
FROM employees
WHERE department_id IN 
	(SELECT department_id
	FROM departments
	WHERE department_name = 'IT');
    
-- 3. Write a MySQL query to find the name (first_name, last_name) of the employees who have a manager and worked in a USA based department.
-- Hint : Write single-row and multiple-row subqueries


SELECT 	first_name,
		last_name
FROM employees 
WHERE manager_id IN
	(SELECT employee_id 
	FROM employees
	WHERE department_id IN
		(SELECT department_id
		FROM departments
		WHERE location_id IN
			(SELECT location_id
            FROM locations
            WHERE country_id= 'US')));

-- 4. Write a MySQL query to find the name (first_name, last_name) of the employees who are managers.

-- Method 1
SELECT 	E.first_name,
		E.last_name
FROM employees E
JOIN employees D
ON E.employee_id = D.manager_id
GROUP BY E.first_name, E.last_name;

-- Method 2
SELECT first_name, last_name 
FROM employees 
WHERE (employee_id IN 
    (SELECT manager_id FROM employees)
);

-- 5. Write a MySQL query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary > (SELECT AVG(salary)
FROM employees)
ORDER BY salary DESC;

-- 6. Write a MySQL query to find the name (first_name, last_name), and salary of the employees whose salary is equal to the minimum salary for their job grade.
 
SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary = (SELECT min_salary
FROM jobs WHERE employees.job_id = jobs.job_id);

-- 7. Write a MySQL query to find the name (first_name, last_name), and salary of the employees who earns more than the average salary and works in any of the IT departments.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary > (SELECT AVG(salary)
FROM employees) AND
 department_id IN 
	(SELECT department_id
	FROM departments
	WHERE department_name LIKE '%IT%');
    
-- 8. Write a MySQL query to find the name (first_name, last_name), and salary of the employees who earns more than the earning of Mr. Bell.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary >
	(SELECT salary
	FROM employees
	WHERE last_name = 'Bell')
ORDER BY salary DESC;

-- 9. Write a MySQL query to find the name (first_name, last_name), and salary of the employees who earn the same salary as the minimum salary for all departments.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary = (SELECT MIN(salary)
FROM employees);

-- 10. Write a MySQL query to find the name (first_name, last_name), and salary of the employees whose salary is greater than the average salary of all departments.

SELECT 	first_name,
		last_name,
        salary
FROM employees
WHERE salary > (SELECT AVG(salary)
FROM employees)
ORDER BY salary DESC;

-- 11. Write a MySQL query to display the employee ID, first name, last name, and department names of all employees.

SELECT 	e.first_name,
		e.last_name,
		d.department_name
FROM employees e
	JOIN departments d
	ON e.department_id = d.department_id;
    
-- 12. Write a MySQL query to display the employee ID, first name, last name, salary of all employees whose salary is above average for their departments.

SELECT 
		employee_id,
		first_name,
		salary
FROM	employees
WHERE	salary > (SELECT 
					AVG(salary)
FROM 	employees
WHERE   department_id = employees.department_id);

-- 13. Write a MySQL query to find the 5th maximum salary in the employees table.

SELECT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 4 ;

-- 14.  Write a MySQL query to find the 4th minimum salary in the employees table.

SELECT salary
FROM employees
ORDER BY salary ASC
LIMIT 1 OFFSET 3;

-- 15. Write a MySQL query to select last 10 records from a table.

SELECT *
FROM employees
ORDER BY employee_id DESC
LIMIT 10;

-- 16. Write a MySQL query to list the department ID and name of all the departments where no employee is working.


SELECT D.department_id, D.department_name
FROM departments D
LEFT JOIN employees E ON D.department_id = E.department_id
WHERE E.department_id IS NULL;

-- 	17. Write a MySQL query to get 3 maximum salaries.

SELECT salary
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- 	18. Write a MySQL query to get 3 minimum salaries.

SELECT salary
FROM employees
ORDER BY salary ASC
LIMIT 3;

-- Joins

-- 1.	Write a MySQL query to find the addresses (location_id, street_address, city, state_province, country_name) of all the departments.

SELECT 
    D.DEPARTMENT_NAME,
    L.LOCATION_ID,
    L.STREET_ADDRESS,
    L.CITY,
    L.STATE_PROVINCE,
    C.COUNTRY_NAME
FROM
    departments D
        JOIN
    locations L ON D.LOCATION_ID = L.LOCATION_ID
        JOIN	
    countries C ON L.COUNTRY_ID = C.COUNTRY_ID;
    
-- 2. Write a MySQL query to find the name (first_name, last name), department ID and name of all the employees.

SELECT 
    D.DEPARTMENT_ID,
    E.FIRST_NAME,
    E.LAST_NAME
FROM
    employees E
        JOIN
    departments D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
    
-- 3. Write a MySQL query to find the name (first_name, last_name), job, department ID and name of the employees who works in London.
    
SELECT 
    e.first_name,
    e.last_name,
    e.job_id,
    e.department_id,
    d.department_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
        JOIN
    locations l ON d.location_id = l.location_id
WHERE
    l.city = 'London';

-- 4. Write a MySQL query to find the employee id, name (last_name) along with their manager_id and name (last_name)

SELECT 
    E1.EMPLOYEE_ID AS Emp_Id,
    E1.LAST_NAME AS Employee,
    E2.EMPLOYEE_ID AS Mgr_Id,
    E2.LAST_NAME AS Manager
FROM
    employees E1
        JOIN
    employees E2 ON E1.MANAGER_ID = E2.EMPLOYEE_ID;

-- 5. Write a MySQL query to find the name (first_name, last_name) and hire date of the employees who was hired after 'Jones'.

-- Method 1
SELECT 
	FIRST_NAME,
	LAST_NAME,
	HIRE_DATE
FROM employees
WHERE HIRE_DATE >
		(SELECT HIRE_DATE
		FROM employees
WHERE LAST_NAME = 'Jones');

-- Method 2
SELECT 
    E.FIRST_NAME,
    E.LAST_NAME,
    E.HIRE_DATE
FROM
    employees E
        JOIN
    employees D ON D.LAST_NAME = 'Jones'
WHERE
    D.HIRE_DATE < E.HIRE_DATE;

-- 6. Write a MySQL query to get the department name and number of employees in the department.

SELECT 
    departments.DEPARTMENT_NAME,
    COUNT(employees.EMPLOYEE_ID) AS employees_count
FROM
    employees
        JOIN
    departments
WHERE
    employees.DEPARTMENT_ID = departments.DEPARTMENT_ID
GROUP BY departments.DEPARTMENT_NAME
ORDER BY employees_count DESC;

-- 7. Write a MySQL query to find the employee ID, job title, number of days between ending date and starting date for all jobs in department 90.

SELECT 
    employees.EMPLOYEE_ID,
    jobs.JOB_TITLE,
    DATEDIFF(job_history.END_DATE,
            job_history.START_DATE) AS days
FROM
    employees
        JOIN
    jobs ON employees.JOB_ID = jobs.JOB_ID
        JOIN
    job_history ON employees.EMPLOYEE_ID = job_history.EMPLOYEE_ID
WHERE
    job_history.DEPARTMENT_ID = 90;

-- 8. Write a MySQL query to display the department ID and name and first name of manager

SELECT 
    D.DEPARTMENT_ID, M.FIRST_NAME
FROM
    employees M
        JOIN
    departments D ON M.MANAGER_ID = D.MANAGER_ID;

-- 9. Write a MySQL query to display the department name, manager name, and city.

SELECT 
    d.department_name,
    e.first_name AS ManagerName,
    l.CITY
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
        JOIN
    locations l ON d.location_id = l.location_id;
    
-- 10. Write a MySQL query to display the job title and average salary of employees.

SELECT 
    jobs.JOB_TITLE,
    ROUND(AVG(employees.SALARY), 2) AS average_salary
FROM
    employees
        JOIN
    jobs ON employees.JOB_ID = jobs.JOB_ID
GROUP BY jobs.JOB_TITLE
ORDER BY average_salary DESC;

-- 11. Write a MySQL query to display job title, employee name, and the difference between salary of the employee and minimum salary for the job.

SELECT 
    e.FIRST_NAME,
    j.JOB_TITLE,
    (e.SALARY - j.MIN_SALARY) AS salary_difference
FROM
    employees e
JOIN
    jobs j ON e.JOB_ID = j.JOB_ID
    ORDER BY salary_difference DESC;
    
-- 12. Write a MySQL query to display the job history that were done by any employee who is currently drawing more than 10000 of salary.

SELECT 
    employees.FIRST_NAME,
    employees.LAST_NAME,
    job_history.START_DATE,
    job_history.END_DATE,
    job_history.JOB_ID
FROM
    employees
        JOIN
    job_history ON employees.EMPLOYEE_ID = job_history.EMPLOYEE_ID
WHERE
    employees.SALARY > 10000
ORDER BY job_history.START_DATE , job_history.END_DATE;

-- 13. Write a MySQL query to display department name, name (first_name, last_name), hire date, salary of the manager for all managers whose experience is more than 15 years.

SELECT 
    first_name,
    last_name,
    hire_date,
    salary,
    (DATEDIFF(NOW(), hire_date)) / 365 Experience
FROM
    departments d
        JOIN
    employees e ON d.manager_id = e.employee_id
WHERE
    (DATEDIFF(NOW(), hire_date)) / 365 > 15;
    
-- String Functions

-- 1. Write a MySQL query to get the job_id and related employee's id.

SELECT JOB_ID, EMPLOYEE_ID
FROM employees;

-- 2. Write a MySQL query to update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'.

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

-- 3. Write a MySQL query to get the details of the employees where the length of the first name greater than or equal to 8.

SELECT *
FROM employees
WHERE LENGTH(FIRST_NAME) >= 8;

-- 4. Write a MySQL query to get the employee id, first name and hire month.

SELECT EMPLOYEE_ID, FIRST_NAME, MONTH(HIRE_DATE) AS hire_month
FROM employees;

-- 5. Write a MySQL query to find all employees where first names are in upper case.

SELECT FIRST_NAME
FROM employees
WHERE FIRST_NAME = UPPER(FIRST_NAME);

-- 6. Write a MySQL query to extract the last 4 character of phone numbers.

SELECT PHONE_NUMBER, SUBSTRING(PHONE_NUMBER,9,4)
FROM employees;

-- 7. Write a MySQL query to get the locations that have minimum street length.

SELECT *
FROM locations
WHERE LENGTH(street_address) <=
		(SELECT 
            MIN(LENGTH(street_address))
        FROM
            locations);
            
-- 8. Write a MySQL query to display the length of first name for employees where last name contain character 'c' after 2nd position.

SELECT FIRST_NAME
FROM employees
WHERE LAST_NAME LIKE '__c%';

-- Write a MySQL query that displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.

SELECT 
    FIRST_NAME AS Employee_First_Name,
    LENGTH(FIRST_NAME) AS First_Name_Length
FROM 
    employees
WHERE 
    FIRST_NAME LIKE 'A%' OR FIRST_NAME LIKE 'J%' OR FIRST_NAME LIKE 'M%'
ORDER BY 
    FIRST_NAME;