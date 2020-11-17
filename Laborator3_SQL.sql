/*LABORATORUL 3*/


/*EXERCITII JOIN*/

/*ex1*/
SELECT t1.last_name, TO_CHAR(t1.hire_date, 'MON-YYYY') AS hire
FROM employees t1, employees t2
WHERE  (t1.last_name != 'Gates')  AND (t1.department_id = t2.department_id)  AND (t2.last_name = 'Gates')  AND (INSTR(t1.last_name, 'a') != 0);
/*varianta2*/
SELECT t1.last_name, TO_CHAR(t1.hire_date, 'MON-YYYY') AS data_angajare
FROM employees t1
JOIN employees t2
USING (department_id)
WHERE (t1.last_name != 'Gates')  AND (t2.last_name = 'Gates')  AND (t1.last_name LIKE '%a%');

/*ex2*/
SELECT DISTINCT t1.employee_id, t1.last_name
FROM employees t1, employees t2
WHERE (t1.department_id = t2.department_id) AND (t2.last_name LIKE '%t%') 
ORDER BY t1.last_name
/*varianta2*/
SELECT DISTINCT t1.employee_id, t1.last_name
FROM employees t1
INNER JOIN employees t2
USING (department_id)
WHERE (t2.last_name LIKE '%t%')
ORDER BY t1.last_name

/*ex3*/
SELECT t1.last_name, t1.salary, t2.job_title, t4.city, t5.country_name
FROM employees t1
INNER JOIN jobs t2 ON t1.job_id = t2.job_id
INNER JOIN departments t3 ON t1.department_id = t3.department_id
INNER JOIN locations t4 ON t3.location_id = t4.location_id
INNER JOIN countries t5 ON t4.country_id = t5.country_id
WHERE t1.manager_id = (SELECT employee_id FROM employees WHERE first_name LIKE 'Steven' AND last_name LIKE 'King');

/*ex4*/
SELECT t1.department_id, t1.department_name, t2.last_name, t2.job_id, TO_CHAR(t2.salary, '$99,999.99') AS salary
FROM departments t1
INNER JOIN employees t2 ON t1.department_id = t2.department_id
WHERE t1.department_name LIKE '%ti%' ORDER BY t1.department_name, t2.last_name;

/*ex5*/
SELECT t1.last_name, t1.department_id, t2.department_name, t3.city, t1.job_id
FROM employees t1
INNER JOIN departments t2 ON t1.department_id = t2.department_id
INNER JOIN locations t3 ON t2.location_id = t3.location_id
WHERE t3.city = 'Oxford';

/*ex6*/
SELECT t1.employee_id, t1.last_name, t1.salary
FROM employees t1
INNER JOIN jobs t2 ON (t1.job_id = t2.job_id) AND (t1.salary >= (t2.max_salary + t2.min_salary) / 2)
INNER JOIN departments t3 ON t1.department_id = t3.department_id
WHERE t3.department_id IN ( SELECT t1.department_id FROM departments t1 INNER JOIN employees t2 ON t1.department_id = t2.department_id WHERE t2.last_name LIKE '%t%');

/*ex7*/
SELECT t2.last_name, t1.department_name
FROM departments t1
RIGHT OUTER JOIN employees t2 ON t1.department_id = t2.department_id;
/*varianta2*/
SELECT t2.last_name, t1.department_name
FROM departments t1, employees t2
WHERE t1.department_id = t2.department_id
UNION
SELECT last_name, NULL
FROM employees
WHERE department_id IS NULL;

/*ex8*/
SELECT t2.last_name, t1.department_name
FROM departments t1
LEFT OUTER JOIN employees t2 ON t1.department_id = t2.department_id;
/*varianta2*/
SELECT t1.department_name, t2.last_name
FROM departments t1, employees t2
WHERE t1.department_id = t2.department_id
UNION
SELECT department_name, NULL
FROM departments;

/*ex9*/
/*CU SINTAXA DIN SQL99:*/
SELECT *
FROM employees t1
FULL OUTER JOIN employees t2 ON t1.commission_pct = t2.commission_pct;
/*CU REUNIUNE LEFT AND RIGHT*/
SELECT *
FROM employees t1
LEFT JOIN employees t2 ON t1.commission_pct = t2.commission_pct
UNION ALL
SELECT *
FROM employees t1
RIGHT JOIN employees t2 ON t1.commission_pct = t2.commission_pct;


/*EXERCITII OPERATORI PE MULTIMI*/

/*ex10*/
/*REZULTATUL ESTE ORDONAT CRESCATOR*/
SELECT department_id
FROM departments
WHERE department_name LIKE '%re%'
UNION
SELECT DISTINCT t1.department_id
FROM departments t1
INNER JOIN employees t2 ON t1.department_id = t2.department_id
WHERE t2.job_id = 'SA_REP';

/*ex11*/
/*NU SE MAI ORDONEAZA CRESCATOR*/
SELECT department_id
FROM departments
WHERE department_name LIKE '%re%'
UNION ALL
SELECT DISTINCT t1.department_id
FROM departments t1
INNER JOIN employees t2 ON t1.department_id = t2.department_id
WHERE t2.job_id = 'SA_REP';

/*ex12*/
SELECT department_id
FROM departments
WHERE department_id NOT IN(SELECT DISTINCT department_id FROM employees WHERE department_id IS NOT NULL);

/*ex13*/
SELECT department_id
FROM departments
WHERE department_name LIKE '%Re%'AND department_id = ANY (SELECT department_id FROM employees WHERE job_id = 'HR_REP');

/*ex14*/
SELECT employee_id, job_id, last_name
FROM employees
WHERE salary >= 3000
UNION
SELECT t1.employee_id, t1.job_id, t1.last_name
FROM employees t1
INNER JOIN jobs t2 ON t1.job_id = t2.job_id
WHERE t1.salary = (t2.min_salary + t2.max_salary) / 2;


/*EXERCITII SUBCERERI NECORELATE*/

/*ex15*/
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date FROM employees WHERE last_name = 'Gates');

/*ex16*/
SELECT last_name, salary
FROM employees
WHERE department_id IN (SELECT department_id FROM employees WHERE last_name = 'Gates');

/*ex17*/
SELECT last_name, salary
FROM employees
WHERE manager_id = (SELECT employee_id FROM employees WHERE manager_id IS NULL);

/*ex18*/
SELECT last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, salary FROM employees WHERE commission_pct IS NOT NULL);

/*ex19*/
SELECT employee_id, last_name, salary
FROM employees
WHERE salary >= (SELECT (min_salary + max_salary) / 2 FROM jobs WHERE job_id = employees.job_id)
AND department_id IN (SELECT t1.department_id FROM departments t1 INNER JOIN employees t2 ON t1.department_id = t2.department_id WHERE t2.last_name LIKE '%t%');

/*ex20*/
SELECT *
FROM employees
WHERE salary >= ALL (SELECT salary FROM employees WHERE job_id LIKE '%CLERK%')
ORDER BY salary DESC;

/*ex21*/
SELECT t1.last_name, t2.department_name, t1.salary
FROM employees t1
INNER JOIN departments t2 ON t1.department_id = t2.department_id
WHERE t1.manager_id = ANY (SELECT employee_id FROM employees WHERE commission_pct IS NOT NULL);

/*ex22*/
SELECT last_name, department_id, salary, job_id
FROM employees
WHERE (salary, commission_pct) IN (SELECT t1.salary, t1.commission_pct FROM employees t1 INNER JOIN departments t2 ON t1.department_id = t2.department_id INNER JOIN locations t3 ON t2.location_id = t3.location_id WHERE t3.city LIKE 'Oxford');

/*ex23*/
SELECT last_name, department_id, job_id
FROM employees
WHERE department_id = (SELECT department_id FROM departments WHERE location_id = ( SELECT location_id 
                                                                                   FROM locations
                                                                                  WHERE city LIKE 'Toronto' )
);