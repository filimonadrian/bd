-- Sa se scrie o cerere SQL care face o lista cu toti angajatii care au acelasi
-- departament cu cel al  sefului direct si au venit in companie in acelasi an
-- cu presedintele companiei.  Lista se ordoneaza dupa numele subalternilor si are urmatorul antet:  

-- Den_dep_subalt   Nume_subalt   Data_ang_subalt   Nume_sef   Data_ang_sef
-- Sa se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

-- metoda 1
SELECT
    d.dname AS "Den Dep_Subaltern",
    a1.ename AS "Nume subaltern",
    a1.hiredate AS "Data angajare subaltern",
    a2.ename AS "Nume sef",
    a2.hiredate AS "Data angajare sef"
FROM
    emp a1
        INNER JOIN emp a2
                ON a1.mgr = a2.empno
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    a1.deptno = a2.deptno AND
    EXTRACT(YEAR from a1.hiredate) = EXTRACT(YEAR from 
                                                        (SELECT hiredate
                                                        FROM emp
                                                        WHERE job = 'PRESIDENT'))
order by a1.ename;

-- metoda 2
SELECT
    d.dname AS "Den Dep_Subaltern",
    a1.ename AS "Nume subaltern",
    a1.hiredate AS "Data angajare subaltern",
    a2.ename AS "Nume sef",
    a2.hiredate AS "Data angajare sef"
FROM
    emp a1,
    emp a2,
    dept d
WHERE
    a1.mgr = a2.empno AND
    a1.deptno = d.deptno AND
    a1.deptno = a2.deptno AND
    EXTRACT(YEAR from a1.hiredate) = EXTRACT(YEAR from 
                                                        (SELECT hiredate
                                                        FROM emp
                                                        WHERE job = 'PRESIDENT'))
order by a1.ename;


-- metoda 3 -- 2 conditii in SELF JOIN
SELECT
    d.dname AS "Den Dep_Subaltern",
    a1.ename AS "Nume subaltern",
    a1.hiredate AS "Data angajare subaltern",
    a2.ename AS "Nume sef",
    a2.hiredate AS "Data angajare sef"
FROM
    emp a1
        INNER JOIN emp a2
                ON a1.mgr = a2.empno AND a1.deptno = a2.deptno
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    EXTRACT(YEAR from a1.hiredate) = EXTRACT(YEAR from 
                                                        (SELECT hiredate
                                                        FROM emp
                                                        WHERE job = 'PRESIDENT'))
order by a1.ename;


-- metoda 4 - intersect
SELECT
    d.dname AS "Den Dep_Subaltern",
    a1.ename AS "Nume subaltern",
    a1.hiredate AS "Data angajare subaltern",
    a2.ename AS "Nume sef",
    a2.hiredate AS "Data angajare sef"
FROM
    emp a1,
    emp a2,
    dept d
WHERE
    EXTRACT(YEAR from a1.hiredate) = EXTRACT(YEAR from 
                                                        (SELECT hiredate
                                                        FROM emp
                                                        WHERE job = 'PRESIDENT'))
INTERSECT
SELECT
    d.dname AS "Den Dep_Subaltern",
    a1.ename AS "Nume subaltern",
    a1.hiredate AS "Data angajare subaltern",
    a2.ename AS "Nume sef",
    a2.hiredate AS "Data angajare sef"
FROM
    emp a1,
    emp a2,
    dept d
WHERE
    a1.mgr = a2.empno AND
    a1.deptno = d.deptno AND
    a1.deptno = a2.deptno
order by "Nume subaltern";