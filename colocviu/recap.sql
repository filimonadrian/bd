-- Creati un view (VIEW_EVALUARI) care sa arate situatia evaluarilor anuale ale angajatilor pe fiecare departament: stiind ca angajatii din fiecare departament sunt evaluati la 5 luni diferenta de luna in care s-au angajat, afisati, pentru fiecare angajat:

--             a. numele angajatului: NUME_ANG

--             b. functia lui: JOB_ANG

--             c. luna in care ar trebui evaluat: LUNA_EVAL

--             d. numele departamentului din care face parte: NUME_DEPT

--             e. numarul de angajati care trebuie evaluati in luna curenta, din departamentul din care face parte angajatul: NR_ANG_EVAL,

--             f. numarul total de angajati din departamentul din care face parte angajatul: NR_TOT_ANG

-- Ordonati dupa numele departamentului, crescator.

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- ex 3
-- Sa se scrie o cerere  SQL*Plus  care face o lista cu seful de departament care are cel mai mare salariu dintre toti sefii care au cel 
-- putin 2 subalterni care nu au primit comision.  
-- Sefii de departament sunt angajatii care au id-ul pe coloana mgr.
-- Antetul listei este urmatorul :
--     DEN_DEP_SEF     
--     NUME_SEF    
--     JOB_SEF    
--     SAL_SEF   
--     NUME_SUB     
--     COM_SUB
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari

-- ex 4
-- Sa se selecteze angajatii care au cele mai mari doua venituri din randul subordonatilor angajatului cu cei mai multi subordonati.  
-- Se va afisa, pentru fiecare angajat o lista cu antetul:

-- Nume, Nume sef, Venit

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.




-- ex 5
-- Sa se selecteze angajatul care are cel mai mare venit din randul
-- subordonatilor angajatului cu cei mai multi subordonati.
-- Se va afisa o lista cu antetul:
-- Nume, Nume sef, Venit
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- nr de angajati pentru fiecare sef
select 
    mgr,
    count(empno) "nr_angajati"
from emp
group by mgr;


-- numarrul maxim de angajati
select
    MAX(t.nr_ang) "nr_angajati"
from
    emp e,
    (select mgr, count(empno) nr_ang from emp group by mgr) t;



-- seful cu cei mai multi angajati

select
    mgr
from
    emp
having
    count(empno) = 
        (select
            MAX(t.nr_ang) "nr_angajati"
        from
            (select mgr, count(empno) nr_ang from emp group by mgr) t)
group by mgr;


-- cel mai mare salarii din subordonatii sefului cu cei mai multi angajati

select
    max(sal + nvl(comm, 0)) "sal_max_ang"
from emp
where
    mgr = ( select
                mgr
            from
                emp
            having
                count(empno) = 
                    (select
                        MAX(t.nr_ang) "nr_angajati"
                    from
                        (select mgr, count(empno) nr_ang from emp group by mgr) t)
            group by mgr);

-- final
select
    a.ename "nume",
    a1.ename "nume_sef",
    a.sal + nvl(a.comm, 0) "Venit"
from
    emp a
    INNER JOIN emp a1
            ON a.mgr = a1.empno
where
    a.sal + nvl(a.comm, 0) = 
    (select
        max(sal + nvl(comm, 0)) "sal_max_ang"
    from emp
    where
        mgr = ( select
                    mgr
                from
                    emp
                having
                    count(empno) = 
                        (select
                            MAX(t.nr_ang) "nr_angajati"
                        from
                            (select mgr, count(empno) nr_ang from emp group by mgr) t)
                group by mgr));



-- ex 6
-- Sa se scrie o cerere  SQL*Plus  care face o lista cu departamentul in care s-au facut cele mai multe
-- angajari intr-un an. Lista va contine denumirea de departament,
-- anul in care s-au facut cele mai multe angajari in departamentul respectiv si numarul de angajari.
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



-- ex 7
-- Afisati, pentru angajatii care fac parte din departamentul cu cei mai multi angajati cu acelasi grad salarial:
-- a. Numele angajatului cu prima litera mare si restul mici: NUME_ANG
-- b. Anul angajarii cu 2 cifre, caracterul * si luna angajarii in format text: AN_LUNA_ANG
-- c. Numele departamentului cu litere mici: NUME_DEPT
-- Antetul listei este urmatorul: NUME_ANG, AN_LUNA_ANG, NUME_DEPT
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- nr persoane cu acelasi grad salarial
select
    deptno,
    count(ename) nr_sal,
    grade
from 
    emp 
    inner join salgrade
            on sal >= LOSAL and sal <= hisal
group by deptno, grade;


select
    MAX(d.nr_sal)
from 
    (select
        deptno,
        count(ename) nr_sal,
        grade
    from 
        emp 
        inner join salgrade
                on sal >= LOSAL and sal <= hisal
    group by deptno, grade
    order by deptno) d;

NOT FINISHED



-- ex 8
-- Sa se selecteze angajatul care are cel mai mare venit din randul subordonatilor
-- angajatului cu cei mai multi subordonati.  Se va afisa o lista cu antetul:
-- Nume, Nume sef, Venit
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.

-- ex 9
-- Sa se creeze o tabela, denumita PRIMII_VENITI cu toti angajatii care au venit
-- in firma primii din departamentul lor. Structura tabelei este urmatoarea :
-- Nume_angajat, Den_departament, Data_angajare, Ani_vechime

-- ex 10

-- Sa se selecteze angajatii din departamentul lui SCOTT, care au salariul in gradul
-- salarial din care fac parte cele mai multe salarii din firma.
-- Se va afisa :
-- Nume angajat Salariu Venit Grad salarial
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- angajatii din departamentul lui Scott
select 
    ename
from
    emp
where
    deptno = (select deptno from emp where ename='SCOTT');


-- gradul salarial al angajatilor
select
    ename,
    grade
from
    emp 
    inner join salgrade
            on sal >= LOSAL and sal <= hisal;


-- gradul salarial cu cei mai multi angajati

select
    grade
from
    salgrade 
    inner join emp
            on sal >= LOSAL and sal <= hisal
group by grade
having count(*) = (SELECT MAX(count (grade))
                    FROM (select
                            ename,
                            grade
                        from
                            emp 
                            inner join salgrade
                                    on sal >= LOSAL and sal <= hisal)
                    GROUP BY grade);


        -- varianta clasica
select
    grade
from
    salgrade 
    inner join emp
            on sal >= LOSAL and sal <= hisal
group by grade
having count(grade) = (SELECT MAX(count (grade))
                        FROM (select
                                e.ename,
                                s.grade grade
                            from
                                emp e,
                                salgrade s
                            where e.sal >= s.losal AND e.sal <= s.hisal)
                    GROUP BY grade);

-- complet
select
    ename "Nume", 
    sal "Salariu",
    sal + nvl(comm, 0) "Venit",
    grade "Grad salarial"
from
    emp 
    inner join salgrade
            on sal >= LOSAL and sal <= hisal
WHERE
    deptno = (select deptno from emp where ename='SCOTT') AND
    grade =
        (select
            grade
        from
            salgrade 
            inner join emp
                    on sal >= LOSAL and sal <= hisal
        group by grade
        having count(*) = (SELECT MAX(count (grade))
                            FROM (select
                                    ename,
                                    grade
                                from
                                    emp 
                                    inner join salgrade
                                            on sal >= LOSAL and sal <= hisal)
                            GROUP BY grade));




    -- individual
select
    ename "Nume Angajat", 
    sal "Salariu",
    sal + nvl(comm, 0) "Venit",
    grade "Grad salarial"
from
    emp 
    inner join salgrade
            on sal >= LOSAL and sal <= hisal
WHERE
    deptno = (select deptno from emp where ename='SCOTT') AND
    grade =
        (select
            grade
        from
            salgrade 
            inner join emp
                    on sal >= LOSAL and sal <= hisal
        group by grade
        having count(*) = (SELECT MAX(count (grade))
                            FROM (select
                                    e.ename,
                                    s.grade grade
                                from
                                    emp e,
                                    salgrade s
                                where e.sal >= s.losal AND e.sal <= s.hisal)
                            GROUP BY grade));



-- ex 11
-- Sa se scrie o cerere  SQL*Plus  care face o lista cu departamentul in care
-- s-au facut cele mai multe angajari intr-un an. Lista va contine denumirea de departament,
-- anul in care s-au facut cele mai multe angajari in departamentul respectiv si numarul de angajari.

-- Antetul listei este urmatorul :

--             DEN_DEP        AN       NR_ANG
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- ex 12
-- Sa se creeze o tabela, denumita PRIMII_VENITI cu toti angajatii care au venit in
-- firma primii din departamentul lor. Structura tabelei este urmatoarea :
-- Nume_angajat, Den_departament, Data_angajare, Ani_vechime
-- Se vor lua in considerare doar departamentele unde primii veniti au o vechime de cel putin 40 de ani.
-- Vechimea se va calcula ca si numar natural.
-- La final, veti afisa inregistrarile din tabela creata si, apoi, tabela va fi stearsa.
-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- ex 13


-- Sa se creeze un VIEW, denumit PRIMII, care sa contina  angajatul/angajatii
-- care are/au cel mai mare venit din firma. Nu se iau in consideratie angajatii din departamentul lui ALLEN.

-- Structura VIEW-ului este:

-- Nume_ang, Venit, Den_depart

-- Se vor afisa inregistrarile din VIEW-ul creat. La final VIEW-ul va fi sters.

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- ex 14
-- Sa se creeze un VIEW, denumit PRIMII, care sa contina  angajatul/angajatii care are/au
-- cel mai mare venit din firma. Nu se iau in consideratie angajatii din departamentul lui ALLEN.

-- Structura VIEW-ului este:

-- Nume_ang, Venit, Den_depart

-- Se vor afisa inregistrarile din VIEW-ul creat. La final VIEW-ul va fi sters.

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.

-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.


-- ex 15
-- Sa se creeze un VIEW, denumit PRIMII, care sa contina  angajatul/angajatii care are/au cel
-- mai mare venit din firma. Nu se iau in consideratie angajatii din departamentul lui ALLEN.

-- Structura VIEW-ului este:

-- Nume_ang, Venit, Den_depart

-- Se vor afisa inregistrarile din VIEW-ul creat. La final VIEW-ul va fi sters.

-- Pentru rezolvare se vor folosi tabelele EMP, DEPT si SALGRADE.
-- Se vor incarca si rezolvarile etapelor/pasilor intermediari.