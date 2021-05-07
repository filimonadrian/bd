spool C:\Users\Adrian\Documents\bd\lab8\spool_bd_lab9_7mai2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab9', user, sysdate, null, null);
select * from login_lab_bd;


-- ex1
--  Să se determine care departament are cei mai mulți angajați pe aceeași funcție.
--metoda 1
select
    d.den_dep,
    a.functie,
    COUNT(a.id_ang) nr_ang
from
    angajati a
    NATURAL JOIN departamente d
GROUP BY
    d.den_dep,
    a.functie
HAVING COUNT(a.id_ang) = (select MAX(count(id_ang))
                            from angajati
                            group by id_dep, functie);

-- metoda 2

-- pasul 1

select MAX((select (count (id_ang))
            from angajati
            where
                id_dep = s.id_dep AND
                functie = s.functie
            group by
                id_dep,
                functie)) max_count
from angajati s;

-- pasul 2

select
    d.den_dep,
    a.functie,
    count(a.id_ang) nr_ang
from
    angajati a
    NATURAL JOIN departamente d
GROUP BY d.den_dep, a.functie
having count(a.id_ang) = (select
                            max((select (count(id_ang))
                          from angajati
                          where
                            id_dep = s.id_dep AND
                            functie = s.functie
                          group by
                            id_dep,
                            functie)) max_count
                          from angajati s);

-- ex 2

define id_dep = 30;

select
    d.den_dep,
    a.nume,
    a.functie,
    a.comision
from
    angajati a
    inner join departamente d
            on a.id_dep = d.id_dep
group by
    d.den_dep,
    a.nume,
    a.functie,
    a.comision
having
    max(a.comision) IN (select max(comision)
                        from angajati
                        where id_dep = &id_dep
                        group by id_dep)
order by 2;


-- ex 3
select
    a.nume,
    a.functie,
    a.data_ang,
    a.salariu
from
    angajati a,
    (SELECT id_dep, MAX(salariu) sal_MAX_dep
    from angajati
    group by id_dep) b
group by
    a.nume,
    a.functie,
    a.data_ang,
    a.salariu
having a.salariu = MAX(b.sal_MAX_dep)
order by a.nume;

--ex 4
-- Să se afișeze șefii angajaților din departamentul 20.

select
    nume Nume_ang,
    (select nume
    from angajati
    where id_ang = a.id_sef) Nume_sef
from angajati a
where id_dep = 20
order by nume;

-- ex 5
-- Să se facă o listă cu angajații din departamentele 10 și 20
-- ordonați descrescător după numărul de angajați din fiecare departament.
select
    id_dep,
    nume,
    functie
from
    angajati a
where
    id_dep IN (10, 20)
order by
    (select count(*)
    from angajati b
    where a.id_dep = b.id_dep) desc;


-- ex 6

select
    id_dep,
    nume,
    functie,
    salariu
from angajati
where
    salariu > SOME(select distinct salariu
                    from angajati
                    where functie = 'SALESMAN')
order by
    id_dep,
    nume;


-- ex 7

select
    id_dep,
    nume,
    functie,
    salariu
from angajati
where
    salariu >= ALL(select distinct salariu
                    from angajati
                    where functie = 'SALESMAN')
order by
    id_dep,
    nume;


-- ex 8

select
    d.id_dep,
    d.den_dep
from departamente d
where
    EXISTS(select nume
            from angajati
            where id_dep = d.id_dep)
order by
    id_dep;

-- ex 9

select
    id_dep,
    id_ang,
    nume,
    functie,
    id_sef
from angajati a
where
    NOT EXISTS(select id_sef
            from angajati
            where id_ang = a.id_sef)
order by
    id_dep;


--ex 10

select
    id_dep,
    id_ang,
    nume,
    functie,
    id_sef
from angajati a
where
    id_sef NOT IN (select distinct id_sef
                    from angajati)
order by id_dep;




-- exercitii ocw

--ex 1
-- Să se calculeze și afișeze funcția și venitul mediu lunar
-- pentru fiecare funcție.
-- Să se folosească o subcerere în clauza select.

select
    distinct a.functie,
    (select avg(salariu)
    from angajati
    where functie = a.functie) salariu_mediu
from angajati a;


-- ex 2
-- Să se facă o listă cu funcție, gradul salarial, salariul mediu
-- al angajaților calculat după funcție și grad unde
-- salariul mediu angajați este mai mare sau egal cu salariu mediu pentru grad.

---- !!GRESIT!!
select
    a.functie,
    (select grade 
    from salgrade
    where a.salariu > losal AND a.salariu < hisal) AS "grad_salarial"
from
    angajati a,
    (select avg(salariu) salariu_mediu
    from angajati
    where functie = a.functie) b
group by b.salariu_mediu;
having salariu_mediu >= (select (hisal + losal)/2 AS "med"
                        from sal_grade
                        where grade = grad_salarial);



--- exercitiu final


-- nr de angajati fara comision
select
    id_dep,
    count(*) nr_ang
from angajati
where
    comision = 0 or comision is NULL
group by id_dep;


-- care departament are cei mai mulți angajați pe aceeași funcție.
select
    d.den_dep,
    a.functie,
    COUNT(a.id_ang) nr_ang
from
    angajati a
    NATURAL JOIN departamente d
GROUP BY
    d.den_dep,
    a.functie
HAVING COUNT(a.id_ang) = (select MAX(count(id_ang))
                            from angajati
                            group by id_dep, functie);




-- care departament are cei mai multi angajati fara comision

select
    d.den_dep,
    a.functie,
    COUNT(a.id_ang) nr_ang
from
    angajati a
    NATURAL JOIN departamente d
group by
    d.den_dep,
    a.functie
having
    COUNT (a.id_ang) = 
    (SELECT
        MAX(count(id_ang)) nr
    from angajati
    group by id_dep, functie, comision
    having
        comision = 0 OR
        comision IS NULL);



-- soolutia NICU
SELECT 
	d.den_dep Denumire_dep,
	a.nume Nume_ang,
	a.functie Functie,
	a.comision Comision
FROM (SELECT d.den_dep,
					   a.functie,
					   COUNT(a.id_ang) nr_ang
				FROM angajati a
					NATURAL JOIN departamente d
				GROUP BY d.den_dep, a.functie
				HAVING COUNT(a.id_ang) = (SELECT MAX((SELECT (COUNT(id_ang))
											FROM angajati
											WHERE id_dep = s.id_dep AND
												  functie = s.functie AND
												  nvl(comision, 0) = 0
											GROUP BY id_dep,
													 functie, comision)) max_count
										FROM angajati s)) c
	JOIN (angajati a JOIN departamente d ON a.id_dep = d.id_dep)
		ON a.functie = c.functie
WHERE d.den_dep = c.den_dep;

-- solutia proprie
SELECT 
	d.den_dep Denumire_dep,
	a.nume Nume_ang,
	a.functie Functie,
	a.comision Comision
FROM (select
    d.den_dep,
    a.functie,
    COUNT(a.id_ang) nr_ang
    from
        angajati a
        NATURAL JOIN departamente d
    group by
        d.den_dep,
        a.functie
    having
        COUNT (a.id_ang) = 
        (SELECT
            MAX(count(id_ang)) nr
        from angajati
        group by id_dep, functie, comision
        having
            comision = 0 OR
            comision IS NULL)) c
	JOIN (angajati a JOIN departamente d ON a.id_dep = d.id_dep)
		ON a.functie = c.functie
WHERE d.den_dep = c.den_dep;





update login_lab_bd set data_sf= sysdate where laborator='Lab9';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab9';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 