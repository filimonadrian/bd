-- Sa se afiseze toti angajatii ce au sosit in firma in anul 1981, care au un venit 
-- mai mare decat cel al sefului lor, afisand o lista cu antetul :

-- Nume angajat, Den departament, Nume sef, Venit angajat, Venit sef, Ultima zi luna angajare

-- Venitul lunar este egal cu suma dintre salariu si comision.

-- Sa se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele 
-- EMP, DEPT si SALGRADE.

--- METODA 1 ---
select a.ename as "Nume angajat",
	d.dname as "Den departament",
	a1.ename as "nume sef",
	a.sal+nvl(a.comm,0) as "Venit angajat",
	a1.sal+nvl(a1.comm,0) as "Venit sef",
	LAST_DAY(a.hiredate) as  "Ultima zi luna angajare"
  from emp a,
	emp a1,
	DEPT d
 where a.mgr = a1.empno and 
	d.DEPTNO = a.DEPTNO and 
	a.sal+nvl(a.comm,0) > a1.sal+nvl(a1.comm,0) and 
	EXTRACT(YEAR from a.hiredate) = 1981;

-----------------------------------------

-- Sa se selecteze, pentru toti angajatii care au un grad salarial mai mare de 2 
-- si care nu castiga niciun comision lunar : numele, denumirea departamentului 
-- din care face parte, gradul salarial, numarul zilei din data in care s-au angajat, 
-- venitul total lunar.

-- Se va afisa o lista sub forma :

-- Nume angajat, Den departament, Grad salarial, Ziua, Venit total

-- Venitul lunar este egal cu suma dintre salariu si comision.

-- Sa se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.

-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele 
-- EMP, DEPT si SALGRADE.

--- METODA 1 ---
select a.ename as "Nume Angajat",
	d.dname as "Denumire Departament",
	s.grade as "Grad salarial",
	EXTRACT(DAY from a.hiredate) as "Ziua",
	a.sal+nvl(a.comm,0) as "Venit lunar"
  from emp a,
	dept d,
	salgrade s
 where a.sal between s.LOSAL and s.HISAL and 
	nvl(a.comm,0) = 0 and 
	s.grade > 2 and 
	a.DEPTNO = d.DEPTNO;


-----------------------------------------------

-- Selectati numele angajatilor, functia, numele departamentului, data angajarii si 
-- salariul pentru toti angajatii care au acelasi salariu, s-au angajat intre anii 
-- 1981 si 1983 (inclusiv) si primesc comision. Se va ordona alfabetic dupa nume.
-- Se se rezolve prin doua metode distincte folosind JOIN-uri si functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele 
-- EMP, DEPT si SALGRADE.

--- METODA 1 ---
select a.ename as "Nume Angajat",
	a.job as "Functie",
	d.dname as "dept Number",
	a.hiredate as "data angajarii",
	a.sal as "Salariu"
  from emp a,
	emp a1,
	dept d
 where nvl(a.comm,0) <> 0 and 
	a.sal = a1.sal and 
	a.ename <> a1.ename and 
	EXTRACT(YEAR from a.hiredate) between 1981 and 1983 and 
	a.DEPTNO = d.DEPTNO
order by a.ename;

-----------------------------------------------

-- lista cu toti angajatii care nu castiga un venit lunar mai mare decat sefii lor, in
-- care sa se afiseze o apreciere daca angajatul respectiv are un venit salarial foarte
-- bun sau doar bun.
-- - venit anual > 20000 => FOARTE BUN
-- - venit anual <= 200000 => BUN
-- Antet:
-- Nume angajat, den departament, venit anual angajat, venit anual sef, apreciere venit
-- ordonare descrescator dupa venitul angajatului.

--- METODA 1 ---
select  a.ename as "Nume angajat",
	d.dname as "Den departament",
	(a.sal + nvl(a.comm, 0)) * 12 as "Venit anual angajat",
	(s.sal + nvl(s.comm, 0)) * 12 as "Venit anual sef",
	'FOARTE BUN' as "Apreciere venit"
from emp a, dept d, emp s
where   a.mgr = s.empno
    and a.deptno = d.deptno
    and (a.sal + nvl(a.comm, 0) < s.sal + nvl(s.comm, 0))
    and (a.sal + nvl(a.comm, 0)) * 12 > 20000
union
select  a.ename as "Nume angajat",
	d.dname as "Den departament",
	(a.sal + nvl(a.comm, 0)) * 12 as "Venit anual angajat",
	(s.sal + nvl(s.comm, 0)) * 12 as "Venit anual sef",
	'BUN' as "Apreciere venit"
from emp a, dept d, emp s
where   a.mgr = s.empno
    and a.deptno = d.deptno
    and (a.sal + nvl(a.comm, 0) < s.sal + nvl(s.comm, 0))
    and (a.sal + nvl(a.comm, 0)) * 12 <= 20000
order by "Venit anual angajat" desc;


--- METODA 2 ---
select  a.ename as "Nume angajat",
	d.dname as "Den departament",
	(a.sal + nvl(a.comm, 0)) * 12 as "Venit anual angajat",
	(s.sal + nvl(s.comm, 0)) * 12 as "Venit anual sef",
	'FOARTE BUN' as "Apreciere venit"
from emp a
	JOIN emp s ON a.mgr = s.empno and (SIGN((a.sal + nvl(a.comm, 0)) - (s.sal + nvl(s.comm, 0))) < 0)
	JOIN dept d ON a.deptno = d.deptno
where (a.sal + nvl(a.comm, 0)) * 12 > 20000
union
select  a.ename as "Nume angajat",
	d.dname as "Den departament",
	(a.sal + nvl(a.comm, 0)) * 12 as "Venit anual angajat",
	(s.sal + nvl(s.comm, 0)) * 12 as "Venit anual sef",
	'BUN' as "Apreciere venit"
from emp a
	JOIN emp s ON a.mgr = s.empno and (SIGN((a.sal + nvl(a.comm, 0)) - (s.sal + nvl(s.comm, 0))) < 0)
	JOIN dept d ON a.deptno = d.deptno
where (a.sal + nvl(a.comm, 0)) * 12 <= 20000
order by "Venit anual angajat" desc;

----------------------------------------------------

-- Afisati diferentele dintre gradele salariale ale angajatilor fata de cele ale sefilor lor.
-- Pentru fiecare angajat care are venitul lunar mai mare decat cel al sefului lui, afisati:
-- numele lui "nume ang"
-- venitul lui lunar "Venit ang"
-- gradul lui salarial "Grad ang"
-- numele sefului lui "Nume sef"
-- venitul lunar al sefului "Venit sef"
-- gradul salarial al sefului "Grad sef"
-- ordonati dupa gradul angajatului si dupa gradul sefului, crescator.

--- METODA 1 ---
select a.ename"Nume ang",
	a.sal + nvl(a.comm, 0) "Venit ang",
	s.grade "Grad ang",
	a2.ename "Nume sef",
	a2.sal + nvl(a2.comm, 0) "Venit sef",
	s2.grade "Grad sef"
from emp a
	join salgrade s
		on a.sal between s.losal and s.hisal
	full join emp a2
		on a.mgr = a2.empno
	join salgrade s2
		on a2.sal between s2.losal and s2.hisal
where a.sal + nvl(a.comm, 0) > a2.sal + nvl(a2.comm, 0)
order by s.grade, s2.grade asc

--- METODA 2 ---
define venit_ang = a.sal + nvl(a.comm, 0)
define venit_sef = a2.sal + nvl(a2.comm, 0)
select a.ename "Nume ang",
	&venit_ang "Venit ang",
	s.grade "Grad ang",
	a2.ename "Nume sef",
	&venit_sef "Venit sef",
	s2.grade "Grad sef"
from emp a
	right outer join salgrade s
		on a.sal between s.losal and s.hisal
	full outer join emp a2
		on a.mgr = a2.empno
	right outer join salgrade s2
		on a2.sal between s2.losal and s2.hisal
where a.sal + nvl(a.comm, 0) > a2.sal + nvl(a2.comm, 0)
order by s.grade, s2.grade asc;

undefine venit_ang
undefine venit_sef

-------------------------------------------------------

-- Sa se selecteze toti angajatii ce primesc un comision si au gradul salarial > 1, 
-- afisand si un indicator cu privire la venitul lor 
-- (BUN, FOARTE BUN)
-- Daca venitul unui angajat este <=2500, atunci venitul este BUN. 
-- Daca venitul este > 2500, atunci venitul este FOARTE BUN
-- Lista va fi afisata sub forma:
-- ANGAJAT  COMISION  GRAD SALARIAL VENIT     CALIFICATIV VENIT

select  a.ename as "ANGAJAT",
	nvl(a.comm, 0) as "COMISION",
	g.grade as "GRAD SALARIAL",
	a.sal + nvl(a.comm, 0) as "VENIT",
	'BUN' as "CALIFICATIV VENIT"
from emp a, salgrade g
where
	nvl(a.comm, 0) > 0
    and a.sal between  g.LOSAL AND g.HISAL
    and a.sal + nvl(a.comm, 0) <= 2500
    and g.grade > 1
union
select  a.ename as "ANGAJAT",
	nvl(a.comm, 0) as "COMISION",
	g.grade as "GRAD SALARIAL",
	a.sal + nvl(a.comm, 0) as "VENIT",
	'FOARTE BUN' as "CALIFICATIV VENIT"
from emp a, salgrade g
where
	nvl(a.comm, 0) > 0
    and a.sal between  g.LOSAL AND g.HISAL
    and a.sal + nvl(a.comm, 0) > 2500
 and g.grade > 1;

