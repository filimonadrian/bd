--Sa se scrie o cerere SQL care face o lista cu toti angajatii al carui
--nume contine in interior litera A, care fac parte dintr-un departament
--citit de la tastatura si nu primesc comision.  Numele angajatului
--se va afisa concatenat cu ID-ul lui intr-un sir in forma de mai jos.
--Antetul listei este:
--DEPTNO    Angajatul ENAME are id-ul EMPNO           COMM                   SAL
--Pentru testarea solutiilor se va folosi tabela EMP


------------------ FIRST METHOD -----------------------
SELECT DEPTNO,
    'Angajatul ' || ENAME || ' cu id-ul ' || EMPNO,
    COMM,
    SAL
FROM EMP
WHERE (COMM IS NULL OR COMM = 0) AND
    (ENAME LIKE '%A%') AND
    (DEPTNO = &VAL);


------------------ SECOND METHOD -----------------------
SELECT
    &&DEPTNO,
    'Angajatul ' || ENAME || ' cu id-ul ' || EMPNO,
    COMM,
    SAL
FROM EMP
WHERE (COMM IS NULL OR COMM = 0) AND
    (ENAME LIKE '%A%') AND
    (DEPTNO = &DEPTNO);

undefine DEPTNO

------------------ THIRD METHOD -----------------------
accept VAL char prompt 'Introduceti ID-ul departamentului:'
SELECT
    DEPTNO,
    'Angajatul ' || ENAME || ' cu id-ul ' || EMPNO,
    COMM,
    SAL
FROM EMP
WHERE (COMM IS NULL OR COMM = 0) AND
    (ENAME LIKE '%A%') AND
    (DEPTNO = &VAL);


------------------ FORTH METHOD -----------------------
define VAL = 10
SELECT
DEPTNO,
'Angajatul ' || ENAME || ' cu id-ul ' || EMPNO,
COMM,
SAL
FROM EMP
WHERE (COMM IS NULL OR COMM = 0) AND (ENAME LIKE '%A%') AND (DEPTNO = &VAL);
undefine VAL



--Sa se scrie o cerere SQL care face o lista, care sa contina:
--a) O coloana denumita "Info angajat", formata din urmatoarele siruri,
--concatenate: numele angajatului, sirul ' cu functia ' si job-ul angajatului.
--b) Venitul anual al angajatului, cu titlul "Venit anual", pentru angajatii
--care au venitul anual mai mare decat un numar introdus de la tastatura si al
--caror nume NU se termina cu o litera, introdusa de la tastatura.
--Pentru testarea solutiilor se va folosi tabela EMP.
--Sa se rezolve prin cel putin 4 metode distincte folosind cereri cu variabile
--substituite.
--Antetul listei este: Info angajat, Venit anual

------------------ FIRST METHOD ------------------------
SELECT
ENAME || ' cu functia ' || JOB AS "Info Angajat",
SAL + nvl(COMM, 0) AS "Venit Anual"
FROM EMP
WHERE (SAL + nvl(COMM, 0) > &VAL) AND (ENAME NOT LIKE '%&LETTER');


------------------ SECOND METHOD -----------------------
SELECT
ENAME || ' cu functia ' || JOB AS "Info Angajat",
SAL + nvl(COMM, 0) AS "Venit Anual"
FROM EMP
WHERE (SAL + nvl(COMM, 0) > &1) AND (ENAME NOT LIKE '%&2');


------------------ THIRD METHOD ------------------------
accept VAL number prompt 'Introduceti venitul minim: '
accept LETTER char prompt 'Introduceti ultima litera: '

SELECT
ENAME || ' cu functia ' || JOB AS "Info Angajat",
SAL + nvl(COMM, 0) AS "Venit Anual"
FROM EMP
WHERE (SAL + nvl(COMM, 0) > &VAL) AND (ENAME NOT LIKE '%&LETTER');

------------------ FOURTH METHOD -----------------------
define VAL = 1000
define LETTER = N

SELECT
ENAME || ' cu functia ' || JOB AS "Info Angajat",
SAL + nvl(COMM, 0) AS "Venit Anual"
FROM EMP
WHERE (SAL + nvl(COMM, 0) > &VAL) AND (ENAME NOT LIKE '%&LETTER');

undefine VAL
undefine LETTER

--Sa se efectueze un SELECT SQL prin care se acorda un bonus lunar
--angajaților al caror nume incepe cu o litera de la A-E, fac parte
--dintr-un departament al carui ID se introduce de la tastatura si s-au
--angajat in primele trei luni ale anului. Bonusul va fi calculat ca
--fiind egal cu comisionul plus 25% din salariul lunar. Se vor afisa
--numele angajatului, salariu si o coloana numita BONUS care va afisa
--sirul format din salariu concatenat cu  sirul „SI BONUS”, cu bonusul
--si apoi simbolul $.
--Ex: ’1600 si bonus 1500$

------------------ FIRST METHOD -------------------------
SELECT
ENAME Nume_ang,
SAL Salariu,
SAL||' si bonus '||(COMM + (25/100) * sal) AS Bonus
FROM EMP
WHERE ENAME BETWEEN 'A%' AND 'E%' AND DEPTNO = &id_dep AND
	EXTRACT(MONTH from hiredate) IN (1, 2, 3);

------------------ SECOND METHOD ------------------------
accept VAL number prompt 'Introduceti id departament: '

SELECT
ENAME Nume_ang,
SAL Salariu,
SAL||' si bonus '||(COMM + (25/100) * sal) || '$' AS Bonus
FROM EMP
WHERE ENAME BETWEEN 'A%' AND 'E%' AND DEPTNO = &VAL AND
	EXTRACT(MONTH from hiredate) IN (1, 2, 3);

------------------ THIRD METHOD -------------------------
define VAL 30

SELECT
ENAME Nume_ang,
SAL Salariu,
SAL||' si bonus '||(COMM + (25/100) * sal) || '$' AS Bonus
FROM EMP
WHERE ENAME BETWEEN 'A%' AND 'E%' AND DEPTNO = &VAL AND
	EXTRACT(MONTH from hiredate) IN (1, 2, 3);

undefine VAL
------------------ FOURTH METHOD ------------------------
SELECT
ENAME Nume_ang,
SAL Salariu,
SAL||' si bonus '||(COMM + (25/100) * sal) || '$' AS Bonus
FROM EMP
WHERE ENAME BETWEEN 'A%' AND 'E%' AND DEPTNO = &1 AND
	EXTRACT(MONTH from hiredate) IN (1, 2, 3);




--Sa se scrie o cerere SQL care face o lista cu toti angajatii ce nu fac
--parte dintr-un departament cu ID-ul citit de la tastatura, care au un
--salariu mai mare decat o valoare citita de la tastatura si care nu
--primesc comision.  Numele angajatului se va concatena cu data angajarii
--in forma de mai jos. Antetul listei este:

-- DEPTNO      ENAME s-a angajat in data de HIREDATE   SAL     COMM

------------------ FIRST METHOD -------------------------
SELECT
DEPTNO Departament,
ENAME || ' s-a angajat in data de ' || HIREDATE AS Detalii,
SAL Salariu,
COMM Comision
FROM EMP
WHERE (DEPTNO != &VAL1) AND (SAL > &VAL2) AND (COMM IS NULL OR COMM = 0);

------------------ SECOND METHOD ------------------------
accept VAL1 number prompt 'Introduceti id departament: '
accept VAL2 number prompt 'Introduceti salariu: '

SELECT
DEPTNO Departament,
ENAME || ' s-a angajat in data de ' || HIREDATE AS Detalii,
SAL Salariu,
COMM Comision
FROM EMP
WHERE (DEPTNO != &VAL1) AND (SAL > &VAL2) AND (COMM IS NULL OR COMM = 0);

------------------ THIRD METHOD -------------------------
define VAL1 = 10
define VAL2 = 2000

SELECT
DEPTNO Departament,
ENAME || ' s-a angajat in data de ' || HIREDATE AS Detalii,
SAL Salariu,
COMM Comision
FROM EMP
WHERE (DEPTNO != &VAL1) AND (SAL > &VAL2) AND (COMM IS NULL OR COMM = 0);

undefine VAL1
undefine VAL2


------------------ FOURTH METHOD ------------------------
SELECT
DEPTNO Departament,
ENAME || ' s-a angajat in data de ' || HIREDATE AS Detalii,
SAL Salariu,
COMM Comision
FROM EMP
WHERE (DEPTNO != &1) AND (SAL > &2) AND (COMM IS NULL OR COMM = 0);





select ename||' cu functia '||job as "Info angajat",
       12*sal  as "Venit anual"
from EMP
where 12*sal > &sal_anual and 
       ename not like '%&char_intr';



select
    DEPTNO,  
    ENAME||' s-a angajat in data de '||hiredate,
    sal,
    comm
from EMP
where deptno <> &id_dep and 
       sal > &sal_max and
       nvl(comm,0) = 0;


SELECT
	ename nume_ang,
	sal salariu,
	sal||' si bonus '||(COMM + (25/100) * sal) AS BONUS
FROM emp
WHERE ename BETWEEN 'A%' AND 'E%' AND deptno = &id_dep AND
	EXTRACT(MONTH from hiredate) IN (1, 2, 3);



select DEPTNO,  'Angajatul '||ENAME||' are id-ul '||EMPNO, comm, sal
  from EMP
 where deptno = &id_dep and 
       INSTR(ename,'A') <> 0 and
       nvl(comm,0) = 0;




SELECT ENAME AS nume_angajat,
        SAL AS salariu,
        sal || ' si bonus ' || (nvl(comm, 0) + (25/100) * sal) AS BONUS
FROM EMP
WHERE
    ename BETWEEN 'A%'AND 'E%' AND 
    deptno = &id_dep AND
    EXTRACT(month from hiredate) IN (1, 2, 3);
