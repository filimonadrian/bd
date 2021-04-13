-- Sa se afiseze toti angajatii ce au sosit in firma in anul 1981, care au un venit mai mare decat cel al sefului lor, afisand o lista cu antetul :
-- Nume angajat, Den departament, Nume sef, Venit angajat, Venit sef, Ultima zi luna angajare
-- Venitul lunar este egal cu suma dintre salariu si comision.
-- Sa se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.


SELECT
    a1.ename AS "Nume Angajat",
    d.dname AS "Den Departament",
    a2.ename AS "Nume sef",
    a1.sal + nvl(a1.comm, 0) AS "Venit angajat",
    a2.sal + nvl(a2.comm, 0) AS "Venit sef",
    LAST_DAY(a1.hiredate) AS "Ultima Zi Luna de angajare"
FROM
    emp a1
        INNER JOIN emp a2
                ON a1.mgr = a2.empno
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    EXTRACT(YEAR from a1.hiredate) = 1981 AND
    a1.sal + nvl(a1.comm, 0) > a2.sal + nvl(a2.comm, 0);

-- Sa se selecteze, pentru toti angajatii care au un grad salarial mai mare de 2 si care nu castiga niciun comision lunar:
-- numele, denumirea departamentului din care face parte, gradul salarial, numarul zilei din data in care s-au angajat, venitul total lunar.
-- Se va afisa o lista sub forma :
-- Nume angajat, Den departament, Grad salarial, Ziua, Venit total
-- Venitul lunar este egal cu suma dintre salariu si comision.
-- Sa se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

SELECT
    a1.ename AS "Nume Angajat",
    d.dname AS "Den Departament",
    g.grade AS "Grad salarial",
    EXTRACT(DAY from a1.hiredate) AS "Zi angajare",
    a1.sal + nvl(a1.comm, 0) AS "Venit lunar"
FROM
    emp a1
        INNER JOIN SALGRADE g
                ON a1.sal + nvl(a1.comm, 0) >= g.LOSAL AND a1.sal + nvl(a1.comm, 0) <= HISAL
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    nvl(a1.comm, 0) = 0;

-- Selectati numele angajatilor, functia, numele departamentului, data angajarii si
-- salariul pentru toti angajatii care au acelasi salariu, s-au angajat intre anii 1981 si 1983
-- (inclusiv) si primesc comision. Se va ordona alfabetic dupa nume.
-- Se se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

        -- INNER JOIN dept d
        --         ON a1.deptno = d.deptno
        -- NATURAL JOIN emp

-- metoda 1
SELECT
    a1.ename AS "Nume Angajat",
    a1.job as "Functie",
    d.dname AS "Den Departament",
    a1.hiredate AS "Data angajare",
    a1.sal + nvl(a1.comm, 0) AS "Salariul"
FROM
    emp a1,
    emp a2,
    dept d
WHERE
    EXTRACT(YEAR FROM a1.hiredate) >= 1981 AND
    EXTRACT(YEAR FROM a1.hiredate) <= 1983 AND
    a1.sal = a2.sal AND
    a1.ename <> a2.ename AND
    nvl(a1.comm, 0) <> 0 AND
    a1.DEPTNO = d.DEPTNO
order by a1.ename;

-- Metoda 2
select a.ename as "Nume Angajat",
	a.job as "Functie",
	d.dname as "dept Number",
	a.hiredate as "data angajarii",
	a.sal as "Salariu"
  from emp a
	join emp a1 on a.sal = a1.sal and a.ename <> a1.ename  
	join dept d on a.DEPTNO = d.DEPTNO
 where EXTRACT(YEAR from a.hiredate) between 1981 and 1983	and 
	nvl(a.comm,0) <> 0
order by a.ename;


-- lista cu toti angajatii care nu castiga un venit lunar mai mare decat sefii lor, in
-- care sa se afiseze o apreciere daca angajatul respectiv are un venit salarial foarte
-- bun sau doar bun.
-- - venit anual > 20000 => FOARTE BUN
-- - venit anual <= 200000 => BUN
-- Antet:
-- Nume angajat, den departament, venit anual angajat, venit anual sef, apreciere venit
-- ordonare descrescator dupa venitul angajatului.

-- Metoda 1

SELECT
    a1.ename AS "Nume Angajat",
    d.dname AS "Den Dept",
    12 * (a1.sal + nvl(a1.comm, 0)) AS "Venit anual angajat",
    12 * (a2.sal + nvl(a2.comm, 0)) AS "Venit anual sef",
    'FOARTE BUN' AS "Apreciere venit"
FROM
    emp a1
        INNER JOIN emp a2
                ON a1.mgr = a2.empno
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    (a1.sal + nvl(a1.comm, 0)) < (a2.sal + nvl(a2.comm, 0)) AND
    12 * (a1.sal + nvl(a1.comm, 0)) > 20000
union
SELECT
    a1.ename AS "Nume Angajat",
    d.dname AS "Den Dept",
    12 * (a1.sal + nvl(a1.comm, 0)) AS "Venit anual angajat",
    12 * (a2.sal + nvl(a2.comm, 0)) AS "Venit anual sef",
    'BUN' AS "Apreciere venit"
FROM
    emp a1
        INNER JOIN emp a2
                ON a1.mgr = a2.empno
        INNER JOIN dept d
                ON a1.deptno = d.deptno
WHERE
    (a1.sal + nvl(a1.comm, 0)) < (a2.sal + nvl(a2.comm, 0)) AND
    12 * (a1.sal + nvl(a1.comm, 0)) <= 20000
ORDER BY "Venit anual angajat" desc;


