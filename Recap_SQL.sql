select employee_id, last_name, salary * 12 "ANNUAL SALARY"
from employees

select employee_id, last_name, salary * 12 as sal
from employees
where salary * 12>7000 -- in WHERE nu putem pune aliasul unei coloane, ADICA:
order by 3 desc -- 3 = Numarul coloanei. Putem pune numele ei sau aliasul

select employee_id, last_name, salary * 12 as sal
from employees
where sal >7000 -- NU MERGE
order by sal desc 

desc employees

--3. S? se afi?eze numele salaria?ilor ?i codul departamentelor pentru toti angaja?ii din departamentele 10 ?i 30 în ordine alfabetic? a numelor.
select last_name, department_id
from employees
where department_id in (10, 30)
order by last_name

--4. Care este data curent?? Afi?a?i diferite formate ale acesteia.
select sysdate
from dual
--
select 1+2
from dual

select sysdate
from jobs -- afiseaza data de azi pentru fiecare rand din jobs

select to_char(sysdate, 'DD')-- ziua din data (exemplu: 14)
from dual

select to_char(sysdate, 'DAY')-- ziua din saptamana (exemplu: wednesday)
from dual

select to_char(sysdate, 'DD-MM-YYYY')
from dual

select last_name, hire_date
from employees
where hire_date like('%87')

select last_name, hire_date
from employees
where to_char (hire_date, 'YYYY') = '1987'

--6. S? se afi?eze numele ?i job-ul pentru to?i angaja?ii care nu au manager.
select last_name
from employees
where manager_id is null

--afis angajatii care contin litera d in nume
select last_name
from employees
where lower(last_name) like '%d%' 

--7. S? se afi?eze numele, salariul ?i comisionul pentru toti salaria?ii care câ?tig? comision.
--S? se sorteze datele în ordine descresc?toare a salariilor ?i comisioanelor.
select last_name, salary, commission_pct
from employees
where commission_pct is not null
order by salary desc, commission_pct desc

--8. Elimina?i clauza WHERE din cererea anterioar?. Unde sunt plasate valorile NULL în ordinea descresc?toare?
select last_name, salary, commission_pct
from employees
order by salary desc, commission_pct desc 
            -- Raspuns: le afiseaza random pentru ca e si ordonarea dupa salariu. Daca era ordonare doar dupa comision, le punea la inceput, ca si cum ar fi cea mai mare valoare
            
--10. S? se listeze numele tuturor angajatilor care au 2 litere ‘L’ in nume ?i lucreaz? în departamentul 30 sau managerul lor este 102.
select first_name, department_id, manager_id
from employees
where lower(first_name) like '%ll%' and (department_id = 30 or manager_id = 102)

--11. S? se afiseze numele, job-ul si salariul pentru toti salariatii al caror job con?ine ?irul “CLERK” sau “REP” ?i salariul nu este egal cu 1000, 2000 sau 3000. (operatorul NOT IN)
select first_name, job_id, salary
from employees 
where (lower(job_id) like lower('%CLERK%') or lower(job_id) like lower('%REP%')) and salary not in (1000, 2000, 3000)
     -- sau cu upper()
     
--12.S? se afi?eze numele salaria?ilor ?i numele departamentelor în care lucreaz?. Se vor afi?a ?i salaria?ii care nu au asociat un departament. 
select e.first_name, d.*
from employees e, departments d
where e.department_id = d.department_id(+)
     --pt mine: cand lucrez cu mai multe tabele, trebuie sa pun si conditia de legatura.. cumva legatura dintre astea doua e cheia department_id
     -- de vazut ce-i cu (+)
     
--13.S? se afi?eze numele departamentelor ?i numele salaria?ilor care lucreaz? în ele. Se vor afi?a ?i departamentele care nu au salaria?i. 
select d.department_name, e.first_name
from departments d, employees e
where e.department_id(+) = d.department_id

select employee_id,first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID(+)
union 
select employee_id, first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID; 
   -- DE VAZUT CARE E FAZA CU ASTA. CARE E DIFERENTA
   
--14. S? se afi?eze codul angajatului ?i numele acestuia, împreun? cu numele ?i codul ?efului s?u direct.
select e.employee_id, e.first_name, e.manager_id, f.first_name, f.employee_id --cumva manager_id in 'e' pt ca e tot legat de angajat. am nevoie de managerul angajatului din 'e'
from employees e, employees f
where e.manager_id = f.employee_id

--15. S? se modifice cererea anterioar? pentru a afi?a to?i salaria?ii, inclusiv cei care nu au ?ef.
select e.employee_id, e.first_name, e.manager_id, f.first_name, f.employee_id --cumva manager_id in 'e' pt ca e tot legat de angajat. am nevoie de managerul angajatului din 'e'
from employees e, employees f
where e.manager_id = f.employee_id(+)

--16. S? se ob?in? codurile departamentelor în care nu lucreaza nimeni (nu este introdus nici un salariat în tabelul employees).
select e.department_id
from departments e
where (select count(f.employee_id)
from employees f
where e.department_id = f.department_id) = 0
--??????

select department_id
 from departments
 minus
 select  department_id
 from employees; 
--17. S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i media salariilor tuturor angaja?ilor. Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. Sa se rotunjeasca rezultatele.
select min(salary) Minim, max(salary) Maxim, sum(salary) Suma, round(avg(salary),2) Media
from employees;

--18. S? se afi?eze minimul, maximul, suma ?i media salariilor pentru fiecare job
select job_id, min(salary) Minim, max(salary) Maxim, sum(salary) Suma, round(avg(salary),2) Media
from employees
group by job_id;

--19. S? se afi?eze num?rul de angaja?i pentru fiecare job
select count(employee_id), job_id
from employees
group by job_id

--job-urile care nu au angajati
--(+) e pt outer join

 insert into jobs values ('TEST', 'Test', 1000, 2000);
 commit
 
 --count(*) ia in considerare si valorile de null
 
 
 --20. Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, num?rul de angaja?i ?i salariul mediu pentru angaja?ii din acel departament. Coloanele vor fi etichetate corespunz?tor.
select d.department_name, l.city, count(e.employee_id), avg(e.salary)
from departments d join employees e on e.department_id = d.department_id
group by 

-- ce nu se afla in select in count, avg, max... pun in group by

--21. S? se afi?eze codul ?i numele angaja?ilor care câstiga mai mult decât salariul mediu din firm?. Se va sorta rezultatul în ordine descresc?toare a salariilor.
--all intoarce mai multe informatii