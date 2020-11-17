/*ex1
a) Nu, ele nu iau in calcul valorile NULL
b) Clauza HAVING a fost adaugata la SQL, deoarece cuvantul cheie WHERE poate fi utilizat cu functii de agregare.
  Intai se aplica WHERE pe date inainte de agregare!!!! HAVING filtreaza grupurile formate*/

/*ex2*/
SELECT
    ROUND(MIN(salary)) AS MINIM,
    ROUND(MAX(salary)) AS MAXIM,
    ROUND(SUM(salary)) AS SUMA,
    ROUND(AVG(salary)) AS MEDIA
FROM employees
/*ROUND E PENTRU ROTUNJIRE*/

/*ex3*/
SELECT
    job_id AS JOB,
    MIN(salary), MAX(salary), SUM(salary), AVG(salary) 
FROM employees
GROUP BY job_id

/*ex4*/
SELECT job_id AS JOB/*imi afiseaza fiecare job*/, COUNT(employee_id) AS NumarAngajati
FROM employees
GROUP BY job_id

/*ex5*/
SELECT COUNT(DISTINCT manager_id) AS Nr. manageri
FROM employees

/*ex6*/
SELECT MAX(salary) - MIN(salary) AS DiferentaSalarii
FROM employees

/*ex7*/
SELECT department_name AS Departament,
    location_id AS Locatie,
    COUNT(employee_id) AS NumarAngajati,
    ROUND(AVG(salary)) AS SalariuMediu
FROM departments
JOIN employees
USING (department_id)
JOIN locations
USING (location_id)
GROUP BY department_name, location_id

/*ex8*/
SELECT employee_id, last_name
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC

/*ex9*/
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL/*fara managerii al caror cod e necunoscut*/
GROUP BY manager_id
HAVING MIN(salary) >- 1000
ORDER BY MIN(salary) desc

/*ex10*/
SELECT department_id, department_name, MAX(salary) AS SalariuMaxim
FROM departments
JOIN employees USING (department_id)
GROUP BY department_id, department_name
HAVING MAX(salary) > 3000

/*ex11*/

SELECT MIN(AVG(salary)) AS SalariuMediuMinim
FROM employees
GROUP BY job_id;

/*ex12*/
SELECT department_id, department_name, SUM(salary)
FROM departments
JOIN employees USING (department_id)
GROUP BY department_name, department_id

/*ex13*/
SELECT department_id
FROM departments
WHERE department_name LIKE '%Re%'
AND department_id=ANY(SELECT department_id
                         FROM employees
                         WHERE job_id = 'HR_REP')

/*ex14*/
SELECT employee_id, last_name, job_id
FROM employees
WHERE salary>3000
UNION

SELECT t1.employee_id, t1.job_id, t1.last_name
FROM employees t1
INNER JOIN jobs t2 ON t1.job_id=t2.job_id
WHERE t1.salary=(t2.min_salary+t2.max_salary)/2


/*ex15*/
SELECT AVG(salary)
FROM employees
HAVING AVG(salary) > 2500

/*ex16*/
SELECT department_id, job_id, SUM(salary)
FROM departments
JOIN employees USING (department_id)
GROUP BY department_id, job_id

/*ex17*/
SELECT last_name, salary
FROM employees
WHERE manager_id=(SELECT employee_id
                    FROM employees
                    WHERE manager_id IS NULL)
