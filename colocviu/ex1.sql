-- Sa se selecteze angajatul care are cel mai mare venit din randul subordonatilor angajatului cu cei mai multi subordonati.  
-- Se va afisa o lista cu antetul:

-- Nume, Nume sef, Venit

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

select mgr , count(empno) count_per_mgr  
  from emp
 group by mgr;

 select max(d.count_per_mgr) Max_nr_ang
 from (select mgr , count(empno) count_per_mgr  
            from emp
            group by mgr) d;
select mgr 
  from emp
  having count(empno) =  (select max(d.count_per_mgr) Max_nr_ang
                                            from (select mgr , count(empno) count_per_mgr  
                                                        from emp
                                                        group by mgr) d) 
 group by mgr;

 select max(a.sal + nvl(a.comm,0)) max_ang
   from emp a
  where a.mgr = (select mgr 
                        from emp
                        having count(empno) =  (select max(d.count_per_mgr) Max_nr_ang
                                                                    from (select mgr , count(empno) count_per_mgr  
                                                                                from emp
                                                                                group by mgr) d) 
                        group by mgr);



select a.ename, a1.ename, a.sal + nvl(a.comm,0)
  from emp a, emp a1 
 where a.sal + nvl(a.comm,0) = (select max(a.sal + nvl(a.comm,0)) max_ang
                                    from emp a
                                    where a.mgr = (select mgr 
                                                            from emp
                                                            having count(empno) =  (select max(d.count_per_mgr) Max_nr_ang
                                                                                                        from (select mgr , count(empno) count_per_mgr  
                                                                                                                    from emp
                                                                                                                    group by mgr) d) 
                                                            group by mgr)) and
        a.mgr = a1.empno;


-- Sa se scrie o cerere  SQL*Plus  care face o lista cu departamentul in care s-au facut cele mai multe angajari intr-un an.
-- Lista va contine denumirea de departament, anul in care s-au facut cele mai multe angajari in departamentul respectiv si numarul de angajari.
-- Antetul listei este urmatorul :

--             DEN_DEP        AN       NR_ANG

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

select deptno, count(ename) nr_ang, extract(YEAR from hiredate) year
    from emp
group by deptno, extract(YEAR from hiredate);


select d.deptno, max(d.nr_ang) max_nr
  from (select deptno, count(ename) nr_ang, extract(YEAR from hiredate) year
        from emp
        group by deptno, extract(YEAR from hiredate)) d
 group by d.deptno;

select dpt.dname, d.max_nr , d1.year
    from emp a, dept dpt,
         (select d.deptno, max(d.nr_ang) max_nr
                from (select deptno, count(ename) nr_ang, extract(YEAR from hiredate) year
                        from emp
                        group by deptno, extract(YEAR from hiredate)) d
                group by d.deptno) d,
        (select deptno, count(ename) nr_ang, extract(YEAR from hiredate) year
                from emp
            group by deptno, extract(YEAR from hiredate)) d1
    where d.deptno = d1.deptno and d1.nr_ang = d.max_nr and  dpt.deptno = d.deptno
group by dpt.dname, d.max_nr, d1.year
order by dpt.dname;



-- Afisati, pentru angajatii care fac parte din departamentul cu cei mai multi angajati cu acelasi grad salarial:

-- a. Numele angajatului cu prima litera mare si restul mici: NUME_ANG
-- b. Anul angajarii cu 2 cifre, caracterul * si luna angajarii in format text: AN_LUNA_ANG
-- c. Numele departamentului cu litere mici: NUME_DEPT

-- Antetul listei este urmatorul: NUME_ANG, AN_LUNA_ANG, NUME_DEPT
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- count pers per grad per dept 
select a.deptno, count(a.ename) nr_sal, g.grade
  from emp a, SALGRADE g
 where a.sal between  g.LOSAL and g.HISAL
 group by a.deptno ,g.grade
 order by a.deptno;

-- nr maxim de pers 
 select max(d.nr_sal) max_sal
   from (select a.deptno, count(a.ename) nr_sal, g.grade
            from emp a, SALGRADE g
            where a.sal between  g.LOSAL and g.HISAL
            group by a.deptno ,g.grade
            order by a.deptno) d;

-- get dept 

select d1.deptno 
  from (select a.deptno, count(a.ename) nr_sal, g.grade
            from emp a, SALGRADE g
            where a.sal between  g.LOSAL and g.HISAL
            group by a.deptno ,g.grade
            order by a.deptno) d1,
        (select max(d.nr_sal) max_sal
            from (select a.deptno, count(a.ename) nr_sal, g.grade
                        from emp a, SALGRADE g
                        where a.sal between  g.LOSAL and g.HISAL
                        group by a.deptno ,g.grade
                        order by a.deptno) d) d2
 where d1.nr_sal = d2.max_sal;


 -- 
 select initCAP(a.ename),
    substr(extract(year from a.hiredate),3,2)||'*'||to_char(to_date(extract(MONTH from a.hiredate), 'MM'),'MONTH') as "AN_LUNA_ANG",
    lower(d.dname) NUME_DEPT
   from emp a, dept d
  where d.deptno = a.deptno and  d.deptno = (select d1.deptno 
                                                    from (select a.deptno, count(a.ename) nr_sal, g.grade
                                                                from emp a, SALGRADE g
                                                                where a.sal between  g.LOSAL and g.HISAL
                                                                group by a.deptno ,g.grade
                                                                order by a.deptno) d1,
                                                            (select max(d.nr_sal) max_sal
                                                                from (select a.deptno, count(a.ename) nr_sal, g.grade
                                                                            from emp a, SALGRADE g
                                                                            where a.sal between  g.LOSAL and g.HISAL
                                                                            group by a.deptno ,g.grade
                                                                            order by a.deptno) d) d2
                                                    where d1.nr_sal = d2.max_sal);


-- Sa se selecteze angajatul care are cel mai mare venit din randul subordonatilor angajatului cu cei mai multi subordonati.  
-- Se va afisa o lista cu antetul:

-- Nume, Nume sef, Venit
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- same ca primul ex


-- Sa se creeze o tabela, denumita PRIMII_VENITI cu toti angajatii care au venit in firma primii din departamentul lor. 
-- Structura tabelei este urmatoarea :
-- Nume_angajat, Den_departament, Data_angajare, Ani_vechime

create table PRIMII_VENITI
(
    Nume_angajat varchar2(20),
    Den_departament varchar2(20),
    Data_angajare DATE,
    Ani_vechime Number(3)
)

select deptno, min(hiredate)
  from emp
group by deptno;

select a.ename Nume_angajat,
    d.dname Den_departament,
    a.hiredate Data_angajare,
    extract(year from (sysdate)) - extract(year from (a.hiredate)) Ani_vechime
  from emp a, dept d, 
    (select deptno, min(hiredate) hdate
        from emp
        group by deptno) d1
 where d1.deptno = d.deptno and d1.hdate = a.hiredate;


-- Iuli Version 
 -- Sa se selecteze angajatii din departamentul lui
-- SCOTT, care au salariul in gradul salarial din care
-- fac parte cele mai multe salarii din firma.
 
-- Se va afisa :
-- Nume angajat Salariu Venit Grad salarial
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.
 
-- gradul salarial al fiecarui angajat
SELECT
    ENAME,
    GRADE
FROM EMP
    INNER JOIN SALGRADE
    ON SAL >= LOSAL AND SAL <= HISAL;
 
 
-- gradul salarial cu nr maxim de salarii
SELECT
    GRADE
FROM
    SALGRADE
    INNER JOIN EMP
    ON SAL >= LOSAL AND SAL <= HISAL
GROUP BY GRADE HAVING COUNT(*) =
    (SELECT
        MAX(COUNT (GRADE))
    FROM(  SELECT
                ENAME,
                GRADE
            FROM EMP
                INNER JOIN SALGRADE
                ON SAL >= LOSAL AND SAL <= HISAL)
    GROUP BY GRADE);
 
--angajatii din departamentul lui SCOTT
SELECT
    ENAME,
    DEPTNO
FROM EMP
WHERE DEPTNO = (SELECT 
        DEPTNO
    FROM EMP
    WHERE ENAME LIKE 'SCOTT');
 
--Final
SELECT
    ENAME,
    SAL,
    12 * (SAL + NVL(COMM, 0)) AS "Venit",
    GRADE
FROM EMP
    INNER JOIN SALGRADE
    ON SAL >= LOSAL AND SAL <= HISAL
WHERE DEPTNO = (SELECT 
        DEPTNO
    FROM EMP
    WHERE ENAME LIKE 'SCOTT')
    AND GRADE = (
        SELECT
            GRADE
        FROM
            SALGRADE
            INNER JOIN EMP
            ON SAL >= LOSAL AND SAL <= HISAL
        GROUP BY GRADE HAVING COUNT(*) =
            (SELECT
                MAX(COUNT (GRADE))
            FROM(  SELECT
                        ENAME,
                        GRADE
                    FROM EMP
                        INNER JOIN SALGRADE
                        ON SAL >= LOSAL AND SAL <= HISAL)
            GROUP BY GRADE)
    );


-- Selectati toti angajatii din departamentul cu cei mai putini angajati care se incadreaza in gradatia (grad) 1 din grila de salariu.
-- Se va afisa : denumire department, nume angajat, salariu.
-- Ordonati lista dupa salariu, crescator.

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


select a.deptno, count(a.ename) nr_per ,g.grade  
  from emp a, salgrade g
 where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
 group by a.deptno, g.grade;

select min(d.nr_per) min_nr
  from (select a.deptno, count(a.ename) nr_per, g.grade  
            from emp a, salgrade g
            where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
            group by a.deptno, g.grade) d;

select d1.deptno 
  from (select a.deptno, count(a.ename) nr_per ,g.grade  
        from emp a, salgrade g
        where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
        group by a.deptno, g.grade) d1
 where d1.nr_per = (select min(d.nr_per) min_nr
                        from (select a.deptno, count(a.ename) nr_per, g.grade  
                                    from emp a, salgrade g
                                    where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
                                    group by a.deptno, g.grade) d) ;


select d.dname, a.ename, a.sal
  from dept d, emp a
 where d.deptno = (select d1.deptno 
                    from (select a.deptno, count(a.ename) nr_per ,g.grade  
                            from emp a, salgrade g
                            where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
                            group by a.deptno, g.grade) d1
                    where d1.nr_per = (select min(d.nr_per) min_nr
                                            from (select a.deptno, count(a.ename) nr_per, g.grade  
                                                        from emp a, salgrade g
                                                        where a.sal between g.LOSAL and g.HISAL and g.grade = 1 
                                                        group by a.deptno, g.grade) d)) and a.deptno = d.deptno 
    order by a.sal ;



-- Sa se creeze o tabela, denumita PRIMII_VENITI cu toti angajatii care au venit in firma primii din departamentul lor. 
-- Structura tabelei este urmatoarea :
-- Nume_angajat, Den_departament, Data_angajare, Ani_vechime

-- Se vor lua in considerare doar departamentele unde primii veniti au o vechime de cel putin 40 de ani.
-- Vechimea se va calcula ca si numar natural.
-- La final, veti afisa inregistrarile din tabela creata si, apoi, tabela va fi stearsa.

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

create table PRIMII_VENITI
(
    Nume_angajat varchar2(20),
    Den_departament varchar2(20),
    Data_angajare DATE,
    Ani_vechime Number(3)
)

select a.ename Nume_angajat,
    d.dname Den_departament,
    a.hiredate Data_angajare,
    extract(year from (sysdate)) - extract(year from (a.hiredate)) Ani_vechime
  from emp a, dept d, 
    (select deptno, min(hiredate) hdate
        from emp
        group by deptno) d1
 where d1.deptno = d.deptno and d1.hdate = a.hiredate and extract(year from (sysdate)) - extract(year from (a.hiredate)) >= 40;

 insert into PRIMII_VENITI select a.ename Nume_angajat,
    d.dname Den_departament,
    a.hiredate Data_angajare,
    extract(year from (sysdate)) - extract(year from (a.hiredate)) Ani_vechime
  from emp a, dept d, 
    (select deptno, min(hiredate) hdate
        from emp
        group by deptno) d1
 where d1.deptno = d.deptno and d1.hdate = a.hiredate and extract(year from (sysdate)) - extract(year from (a.hiredate)) >= 40;

 select * from PRIMII_VENITI;

 drop table PRIMII_VENITI;



-- Sa se creeze un VIEW, denumit PRIMII, care sa contina  angajatul/angajatii care are/au cel mai mare venit din firma. 
-- Nu se iau in consideratie angajatii din departamentul lui ALLEN.
-- Structura VIEW-ului este:
-- Nume_ang, Venit, Den_depart
-- Se vor afisa inregistrarile din VIEW-ul creat. La final VIEW-ul va fi sters.
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

select deptno 
from emp 
where ename = 'ALLEN';

select max(sal + nvl(comm,0)) venit_max
  from emp 
 where deptno <> (select deptno 
                    from emp 
                    where ename = 'ALLEN');

select a.ename Nume_ang, a.sal + nvl(a.comm,0) Venit, d.dname Den_depart
  from emp a, dept d
 where a.deptno <> (select deptno 
                        from emp 
                        where ename = 'ALLEN') 
        and a.sal + nvl(a.comm,0) = (select max(sal + nvl(comm,0)) venit_max
                                        from emp 
                                        where deptno <> (select deptno 
                                                            from emp 
                                                            where ename = 'ALLEN') ) and d.deptno = a.deptno;

CREATE VIEW PRIMII AS select a.ename Nume_ang, a.sal + nvl(a.comm,0) Venit, d.dname Den_depart
                        from emp a, dept d
                        where a.deptno <> (select deptno 
                                                from emp 
                                                where ename = 'ALLEN') 
                                and a.sal + nvl(a.comm,0) = (select max(sal + nvl(comm,0)) venit_max
                                                                from emp 
                                                                where deptno <> (select deptno 
                                                                                    from emp 
                                                                                    where ename = 'ALLEN') ) and d.deptno = a.deptno;

drop view PRIMII;
                                                                                