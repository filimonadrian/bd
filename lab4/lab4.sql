spool C:\Users\Adrian\Documents\bd\lab4\spool_bd_lab4_26mar2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab4', user, sysdate, null, null);
select * from login_lab_bd;


SELECT id_dep, den_dep
FROM departamente;

SELECT 
	id_ang||'-'||nume angajat,
	functie,
	data_ang
FROM angajati
ORDER BY id_ang DESC; 

-- exercitiul 6
SELECT 
	id_ang||'-'||nume angajat,
	functie,
	salariu + nvl(comision, 0) AS "venit lunar",
	'            ' AS semnatura
FROM angajati
ORDER BY id_dep;

--exercitiul 7
SELECT nume, 'cu functie', functie
FROM angajati;

--ex7 modificat
SELECT nume || ' cu functia '|| functie as ANGAJATI
FROM angajati;

-- exercitiul 8
SELECT
	den_dep ||' are codul '|| id_dep "Lista Departamente"
FROM departamente
ORDER BY den_dep ASC;

-- exercitiul 9
SELECT 
	a.id_ang ecuson,
	a.nume,
	a.data_ang AS "Data Angajarii",
	a.salariu
FROM angajati a
WHERE id_dep = 10;

-- exercitiul 10
SELECT 
	id_dep "Nr. departament",
	nume,
	functie,
	salariu,
	data_ang AS "Data Angajarii"
FROM angajati
WHERE LOWER(functie) = 'manager'
ORDER BY id_dep;

-- exercitiul 11
SELECT 
	id_dep departament,
	functie,
	nume,
	data_ang AS "Data Angajarii"
FROM angajati
WHERE data_ang BETWEEN '1-MAY-1981' AND '31-DEC-1981'
ORDER BY 1, 2 DESC;

SELECT 
	id_dep departament,
	functie,
	nume,
	data_ang AS "Data Angajarii"
FROM angajati
WHERE data_ang >= '1-MAY-1981' AND data_ang <= '31-DEC-1981'
ORDER BY 1, 2 DESC;

-- exercitiul 12
SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	salariu + nvl(comision, 0) "Venit lunar"
FROM angajati
WHERE id_ang IN (7499,7876, 7902)
ORDER BY nume;

SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	salariu + nvl(comision, 0) "Venit lunar"
FROM angajati
WHERE id_ang = 7499 OR id_ang = 7876 OR id_ang = 7902
ORDER BY nume;

-- exercitiul 13
SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	data_ang AS "Data Angajarii"
FROM angajati
WHERE data_ang LIKE '%80';

-- exercitiul 14
SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	data_ang AS "Data Angajarii"
FROM angajati
WHERE nume LIKE 'F%' AND functie LIKE '_______';

-- exercitiul 15
SELECT
	id_ang AS ecuson,
	nume,
	functie,
	salariu,
	comision
FROM angajati
WHERE 
	(comision = 0 OR comision IS NULL) AND id_dep = 20
ORDER BY nume;

-- exercitiul 16
SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	salariu,
	comision
FROM angajati
WHERE
	(comision != 0 AND comision IS NOT NULL) AND functie = UPPER('salesman')
ORDER BY nume;

-- exercitiul 17
SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	salariu,
	id_dep departament
FROM angajati
WHERE 
	salariu > 1500 AND 
	LOWER(functie) = 'manager' OR 
	UPPER(functie) = 'ANALYST'
ORDER BY functie, nume DESC;

--exercitii individuale:
--1.

SELECT
    id_ang,
    nume,
    functie,
    id_sef,
    data_ang,
    salariu,
    id_dep
FROM angajati
WHERE data_ang < '1-JAN-1982' AND (comision = 0 OR comision IS NULL);

---2.


SELECT
    id_ang,
    nume, 
    salariu
FROM ANGAJATI
WHERE 
    salariu > 3000 AND
    id_sef IS NULL
order by id_dep;

--- sau 

SELECT 
	id_ang AS ecuson,
	nume,
	functie,
	salariu,
	id_dep departament
FROM angajati
WHERE
	salariu > 3000 AND
	id_sef IS NULL 
ORDER BY id_dep;

-- 3.
SELECT
    nume,
    functie,
    salariu * 12 AS "Venit anual"
FROM angajati
WHERE
    lower(functie) <> 'manager' AND
    id_dep = &id_dep;

--4.
SELECT
	id_dep,
	nume,
	data_ang,
	salariu
FROM angajati
WHERE 
	data_ang LIKE '%81' AND 
	(id_dep = &id_dep1 OR id_dep = &id_dep2);





-- exercitiu de sfarsit
--metoda 1
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract (YEAR FROM HIREDATE) LIKE ('%&&an_angajare_manager');


--metoda 2
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    (SAL + nvl(COMM, 0) BETWEEN 0 AND 2000) AND
    extract (YEAR FROM HIREDATE) LIKE ('%&&an_angajare_manager');

-- metoda 3
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    HIREDATE LIKE ('%&&an_angajare_manager');

-- metoda 4
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract (YEAR FROM TO_DATE(HIREDATE, 'DD-MON-YYYY')) = &an_angajare_manager;


-- metoda 5
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract(YEAR from data_ang) = (
        SELECT EXTRACT(YEAR FROM HIREDATE)
        FROM EMP
        WHERE 
            DEPTNO = 30 AND
            LOWER(JOB) = 'manager');



SELECT EXTRACT(YEAR FROM HIREDATE)
SELECT EXTRACT (YEAR FROM TO_DATE(HIREDATE, 'DD-MON-YYYY'))
FROM EMP
WHERE 
    DEPTNO = 30 AND
    LOWER(JOB) = 'manager';


update login_lab_bd set data_sf= sysdate where laborator='Lab4';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab4';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 