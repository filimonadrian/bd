-- Sa se acorde o prima pentru fiecare sef, care are cel putin 3 subalterni: numele, 
-- denumirea departamentului din care face parte, PRIMA, numarul subalternilor.
-- Prima se calculeaza ca fiind jumatate din salariu, truncheata la valori intregi.
-- Lista se va afisa cu antetul:
-- Sef, Denumire departament, PRIMA, Nr subalterni
-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE

-- metoda 1
SELECT
    a.ename AS "Nume sef",
    d.dname AS "Dept name",
    trunc(a.sal / 2) AS "Prima",
    b.count AS "Nr. subalterni"
FROM
    emp a,
    (SELECT mgr, count(mgr) count FROM emp group by mgr) b,
    dept d
WHERE
    a.empno = b.mgr AND
    b.count >= 3 AND
    a.deptno = d.deptno;

-- metoda 2
-- join in loc de where
SELECT
    a.ename AS "Nume sef",
    d.dname AS "Dept name",
    trunc(a.sal / 2) AS "Prima",
    b.count AS "Nr. subalterni"
FROM
    emp a
    INNER JOIN dept d
            ON a.deptno = d.deptno,
    (SELECT mgr, count(mgr) count FROM emp group by mgr) b
WHERE
    a.empno = b.mgr AND
    b.count >= 3;


-- metoda 3
select
    a.ename,
    d.dname,
    trunc (a.sal / 2),
    count (a1.mgr) as "Nr subalterni"
from
    emp a
    INNER JOIN dept d
            ON a.deptno = d.deptno,
    emp a1
where
    a1.mgr = a.empno
group by
    a.ename,
    d.dname,
    a.sal
having
    count(a1.mgr) >= 3;


-- cristi
select a.ename Sef,
    d.dname as "Denumire departament",
    trunc(a.sal / 2) PRIMA,
    count(a1.mgr ) as "Nr subalterni"
from
    emp a,
    dept d,
    emp a1
 where
    a1.mgr = a.empno and d.deptno = a.deptno
 group by
    a.ename,
    d.dname,
    a.sal
 having count(a1.mgr) >= 3;


-- Sa se efectueze o lista de premiere pentru angajatii care nu primesc comision si care au
-- venit in firma cu cel putin 2 luni dupa sefii lor directi.
-- Astfel:
-- - daca gradul salarial al angajatului este 1, prima va fi 500
-- - daca gradul salarial al angajatului este 2, prima va fi 300
-- - daca gradul salarial al angajatului este 3, prima va fi 100
-- - restul angajatilor nu primesc prima
-- Antetul listei va fi:
-- Nume ang, Comision ang, Data angajare, Data angajare sef, Grad salarial, PRIMA
-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.


-- NUME         COMISION DATA_ANG  DATA_ASEF       GRAD      Prima
-- ---------- ---------- --------- --------- ---------- ----------
-- FORD                0 03-DEC-81 02-APR-81          4          0
-- JAMES               0 03-DEC-81 01-MAY-81          1        500
-- MILLER              0 23-JAN-82 09-JUN-81          2        300
-- SCOTT               0 19-APR-87 02-APR-81          4          0
-- TURNER              0 08-SEP-81 01-MAY-81          3        100

select
    a.ename,
    nvl(a.comm, 0),
    a.hiredate as "Data ang",
    a1.hiredate as "Data ang sef",
    g.grade Grad,
    case
        when g.grade = 1 then 500 
        when g.grade = 2 then 300
        when g.grade = 3 then 100
        else 0
    end "Prima"
from
    emp a,
    emp a1,
    salgrade g
where
    a.mgr = a1.empno AND
    a.sal >= g.losal AND a.sal <= g.hisal AND
    months_between(a.hiredate, a1.hiredate) >= 2 AND
    nvl (a.comm, 0) = 0;

-- metoda cristi
select
    a.ename Nume,
    nvl(a.comm,0) Comision,
    a.hiredate Data_ang,
    a1.hiredate Data_aSef,
    g.grade Grad,
    case 
      when months_between(a.hiredate, a1.hiredate) >= 2 
      then
        case 
          when g.grade = 1 then 500
          when g.grade = 2 then 300
          when g.grade = 3 then 100
          else 0
        end
      else 0
    end "Prima"
  from emp a,
  emp a1,
  salgrade g
 where a.mgr = a1.empno and 
    a.sal >= g.losal and a.sal <= g.hisal and 
    months_between(a.hiredate, a1.hiredate) >= 2 and 
    nvl(a.comm,0) = 0
order by a.ename, 
a.hiredate,
g.grade;



-- Pentru fiecare angajat, care are salariul in unul din gradele 3, 4 sau 5, sa se calculeze un calificativ, astfel:
-- - daca data angajarii este anterioara datei angajarii lui BLAKE, atunci calificativul este FOARTE APRECIAT
-- - daca data angajarii este ulterioara sau egala cu data angajarii lui BLAKE, atunci calificativul este APRECIAT
-- - daca angajatul primeste comision, atunci calificativul este PREMIAT
-- Lista se va afisa cu antetul:
-- Nume, Comision, Grad salarial, Data angajare, Data angajare BLAKE, Calificativ
-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select
    a.ename,
    nvl(a.comm, 0) Comision,
    g.grade Grad,
    a.hiredate Data_ang,
    b.data_blk,
    case
        when g.grade = 3 or g.grade = 4 or g.grade = 5 then
            case
                when a.hiredate < b.data_blk then 'Foarte Apreciat'
                when a.hiredate >= b.data_blk then 'Apreciat'
                when nvl(a.comm, 0) > 0 then 'Apreciat'
                else '-'
            end
        else '-'
    end "Calificativ"
from
    emp a,
    salgrade g,
    (select hiredate data_blk from emp where ename = 'BLAKE') b
where
    a.sal >= g.losal AND a.sal <= g.hisal;




-- cristi
select a.ename Nume,
    nvl(a.comm,0) Comision,
    g.grade Grad,
    a.hiredate Data_ang,
    b.Data_ang_BLK,
    case 
      when g.grade = 3 or g.grade = 4 or g.grade = 5 then
            case 
              when a.hiredate < b.Data_ang_BLK then 'Foarte Apreciat' 
              when a.hiredate >= b.Data_ang_BLK then 'Apreciat'
              when nvl(a.comm,0) > 0 then 'Apreciat' 
                else '-'
            end
      else '-'
    end "Calificativ"
  from (select hiredate Data_ang_BLK from emp where ename = 'BLAKE') b,
        emp a,
        SALGRADE g
where a.sal >= g.losal and a.sal <= g.hisal
group by a.ename,
        g.grade,
        a.hiredate,
        a.comm,
        b.Data_ang_BLK; 




-- Sa se afiseze pentru toti angajatii care s-au angajat inaintea sefului lor si
-- au gradul de salarizare mai mare sau egal cu 3, numarul intreg de zile de concediu
-- la care au dreptul,  calculat dupa formula  zile=abs(sin(sqrt(vec*grad))*150).
-- unde vec=vechime in ani nerotunjita
-- grad=gradul din grila de salarizare
-- Lista are antetul nume, grad, concediu si se ordoneaza alfabetic.
-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select a.ename Nume, 
    g.grade Grad,
    case 
        when a1.hiredate > a.hiredate and g.grade >= 3  then trunc(abs(sin(sqrt((sysdate - a.hiredate) * g.grade))*150))
    end Concediu
from
    emp a,
    emp a1,
    salgrade g
where a.sal >= g.losal and a.sal <= g.hisal and 
    a1.empno = a.mgr and a1.hiredate > a.hiredate and g.grade >= 3
order by a.ename;











-- Sa se scrie o cerere SQL care face o lista cu sefii de departament care au
-- salariul mai mare decat salariul mediu pe companie. Sefii de departament au ID-ul specificat pe coloana MGR. 
-- Antetul listei este urmatorul:
-- Den_part,  Nume_sef,  Salariu_sef,  Sal_mediu_comp
-- Obs. Salariul mediu se calculeaza prin trunchiere, fara zecimale.
-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select
    d.dname AS "Den dep",
    a1.ename AS "Nume sef",
    a1.sal AS "Salariu Sef",
    trunc(avg (a.sal)) AS "Salariu mediu companie"
from
    emp a,
    emp a1,
    dept d
    
where
    a.mgr = a1.empno AND
    a1.deptno = d.deptno; AND
    a1.sal > avg (a.sal);


-- metoda 1
select
    d.dname AS "Den dep",
    a1.ename AS "Nume sef",
    a1.sal AS "Salariu Sef",
    b.medie AS "Salariu mediu companie"
from
    emp a,
    emp a1,
    dept d,
    (select trunc(avg (sal)) medie from emp) b
where
    a.mgr = a1.empno AND
    a1.deptno = d.deptno AND
    a1.sal > b.medie
group by
    d.dname, a1.ename, a1.sal, b.medie;


-- metoda 2
-- 2 join uri
select
    d.dname AS "Den dep",
    a1.ename AS "Nume sef",
    a1.sal AS "Salariu Sef",
    b.medie AS "Salariu mediu companie"
from
    emp a
        INNER JOIN emp a1
                ON a.mgr = a1.empno
        INNER JOIN dept d
                ON a.deptno = d.deptno,
    (select trunc(avg (sal)) medie from emp) b
where
    a.mgr = a1.empno AND
    a1.deptno = d.deptno AND
    a1.sal > b.medie
group by
    d.dname, a1.ename, a1.sal, b.medie;



-- metoda 3

select
    d.dname AS "Den dep",
    a1.ename AS "Nume sef",
    a1.sal AS "Salariu Sef",
    (select trunc(avg (sal)) medie from emp) AS "Salariu mediu companie"
from
    emp a
        INNER JOIN emp a1
                ON a.mgr = a1.empno
        INNER JOIN dept d
                ON a.deptno = d.deptno
where
    a.mgr = a1.empno AND
    a1.deptno = d.deptno AND
    a1.sal > (select trunc(avg (sal)) medie from emp)
group by
    d.dname, a1.ename, a1.sal;