


spool C:\Users\Adrian\Documents\bd\lab7\spool_bd_lab7_16apr2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab7', user, sysdate, null, null);
select * from login_lab_bd;


--testare functii

select to_char(sysdate, 'DD-MM-YYYY') data_curenta
from dual;

select to_date('15112006', 'DD-MM-YYYY') data_ex
from dual;

select to_char(-10000, '$999999.99MI') valoare
from dual;

select to_number('$10000.00-', '$999999.99MI') valoare
from dual;


-- Ex 1. Să se selecteze toți angajații care au venit în firmă în 1982.


SELECT
    nume,
    to_char(data_ang, 'dd-mm-yyyy') data_ang
FROM angajati
WHERE to_char(data_ang, 'YYYY') like '1982';

SELECT
    nume,
    to_char(data_ang, 'dd-mm-yyyy') data_ang
FROM angajati
WHERE
    to_date(to_char(data_ang, 'YYYY'), 'YYYY') =
    to_date(to_char(1982), 'YYYY');



-- 123
column numar format 99999
select 123.14 numar from dual;

--123.14
column numar format 999.99
select 123.14 numar from dual;

--$123.13
column numar format $999.99
select 123.13 numar from dual;

-- 00123.13 si 00000.14
column numar format 00999.99
select 123.14 numar from dual;
select 0.14 numar from dual;

-- GRESITA!!!!!
-- 123.14 si 0.14
column numar format 9990.99
select 123.14 numar format from dual;
select 0.14 numar from dual;

-- 00123.14 si 00000.14
column numar format 09990.99
select 123.14 numar from dual;
select 0.14 numar from dual;

-- 123,123,123.14
column numar format 999,999,999.99
select 123123123.14 numar from dual;

-- 123.14
column numar format 999.99MI
select -123.14 numar from dual;

-- <123.14> si 123.14
column numar format 999.99PR
select -123.14 numar from dual;
select 123.14 numar from dual;

-- 1.23E+02
column numar format 999.99EEEE
select 123.14 numar from dual;

-- 123.00
column numar format B99999.99
select 123 numar from dual;

-- .14 si 123.10
column numar format 99999D00
select 0.14 numar from dual;
select 123.1 numar from dual;

select greatest (23, 12, 34, 77, 89, 52) gr
from dual;

select least (23, 12, 34, 77, 89, 52) lst
from dual;

select greatest ('15-JAN-1985', '23-AUG-2001') gr
from dual;

select least ('15-JAN-1985', '23-AUG-2001') lst
from dual;

-- ex 2

SELECT
    nume,
    functie,
    salariu,
    decode (functie, 'MANAGER', salariu * 1.25, 
                        'ANALYST', salariu * 1.24,
                        salariu / 4) prima
FROM angajati
where id_dep = 20
order by functie;

-- ex 3
--  Să se calculeze o primă în funcție de vechime pentru angajații din departamentul 20.

SELECT
    nume,
    functie,
    salariu,
    to_char (data_ang, 'YYYY') an_ang
    decode (sign (data_ang - to_date('1-JAN-1982')),
        -1, salariu * 1.25, 
        salariu * 1.10) prima
from angajati
where id_dep = 20
order by functie;


select
    case lower (sediu)
        when 'new-york' then 1
        when 'dallas' then 2
        when 'chicago' then 3
        when 'boston' then 4
    end cod_dep
from departamente;

SELECT
    case
        when lower(sediu) = 'nwe york' then 1
        when id_dep = 20
            or lower(sediu) = 'dallas' then 2
        when lower(sediu) = 'chicago' then 3
        when id_dep = 40 then 4
        else 5
    end cod_dep
from departamente;

select nume
from angajati
where
    id_ang = (case functie
        when 'SALESMAN' then 7844
        when 'CLERK' then 7900
        when 'ANALYST' then 7902
        else 7839
    end);

select nume
from angajati
where id_ang = (case
        when functie = 'SALESMAN' then 7844
        when functie = 'CLERK' then 7900
        when functie = 'ANALYST' then 7902
        else 7839
    end);


set null NULL
select
    nume,
    comision
    nvl(comision, 0) nvl_com,
    salariu + comision "Sal + COM",
    salariu + nvl(comision, 0) "sal + nvl_com"
from angajati
where id_dep = 30;
set null ''


-- pentru a afla userul curent
SELECT USER FROM dual;

-- functii de grup

-- Gruparea se face folosind clauza GROUP BY într-o comandă SELECT
-- în acest caz toate elementele listei, cu exceptia funcțiilor de grupare,
-- trebuie cuprinse în clauza de grupare. Pentru a se pune condiții folosind
-- funcțiile de grup acestea trebuie să apară în clauza HAVING,
-- nu în clauza WHERE

-- EX 4
-- media salariilor pe ALL si pe DISTINCT

select avg (salariu) salariu from angajati;
select avg (all salariu) salariu from angajati;
select avg (distinct salariu) salariu from angajati;

-- ex 5
-- salariul mediu pe fiecare departament

select id_dep, avg(salariu)
from angajati
group by id_dep
order by 1;

-- ex 6
-- venitul lunar mediu pentur fiecare dep
-- aplicam doar pentru venit mediu > 2000

select
    id_dep,
    avg(salariu + nvl(comision, 0))
from angajati
group by id_dep
having avg (salariu + nvl(comision, 0)) > 2000;

-- ex 7
-- numarul ang care au primit salariu pentru fiecare dep

select
    id_dep,
    count(*) nr_ang,
    count(all salariu) count_all,
    count (distinct salariu) count_disctinct
from angajati
group by id_dep
order by 1;

-- ex 8
-- departamente cu cel putin 2 functii distinte ptr angajati

select
    id_dep,
    count(functie) count,
    count(distinct functie) count_disctinct
from angajati
group by id_dep
having count (distinct functie) >= 2
order by 1;

-- ex 9
-- salariul minim, maxim si suma salariilor ptr. fiecare dep
select
    d.den_dep,
    min(a.salariu) sal_min,
    min(distinct a.salariu) sal_min_d,
    max(a.salariu) sal_max,
    max(distinct a.salariu) sal_max_d,
    sum(a.salariu) sal_sum,
    sum(distinct a.salariu) sal_sum_d
from angajati a natural join departamente d
group by d.den_dep
order by d.den_dep;

-- ex 10
-- variatia standard si deviatia standard pentru fiecare departament

select
    id_dep,
    variance(salariu) sal_varstd,
    variance (distinct salariu) sal_varstd_d,
    stddev(salariu) sal_devstd,
    stddev(distinct salariu) sal_devstd_d,
    stddev(comision) com_devstd
from angajati
group by id_dep
order by 1;


-- exercitiu individual


-- metoda 1 - union
SELECT
    den_dep,
    nume,
    salariu,
    (select avg (all salariu) salariu from angajati) AS "sal_med_comp",
    20/100 * salariu AS "BONUS"
FROM
    angajati
    NATURAL JOIN departamente
WHERE
    salariu + nvl(comision, 0) > (select avg (all salariu) salariu from angajati) AND
    functie <> 'PRESIDENT' AND
    functie <> 'MANAGER'
UNION
SELECT
    den_dep,
    nume,
    salariu,
    (select avg (all salariu) salariu from angajati) AS "sal_med_comp",
    10/100 * salariu AS "BONUS"
FROM
    angajati
    NATURAL JOIN departamente
WHERE
    salariu + nvl(comision, 0) <= (select avg (all salariu) salariu from angajati) AND
    functie <> 'PRESIDENT' AND
    functie <> 'MANAGER';


-- metoda 2
-- subcerere si case

SELECT
    d.den_dep,
    a.nume,
    a.salariu,
    (select avg (all a.salariu) salariu from angajati) AS "sal_med_comp",
case
    when a.functie = 'PRESIDENT' or a.functie = 'MANAGER' then 0
    when (select avg (all a.salariu) salariu from angajati) < a.salariu
        then
            a.salariu * 0.2
        else
            a.salariu * 0.1
    end Bonus
FROM
    angajati a
    NATURAL JOIN departamente d;

-- metoda 3
-- fara subcerere

SELECT
    d.den_dep,
    a.nume,
    a.salariu,
    avg (b.salariu) "Salariu mediu", 
    case
    when upper(a.functie) = 'PRESIDENT' or upper(a.functie) = 'MANAGER' then 0
    when a.salariu > avg (b.salariu) then a.salariu * 0.2
        else a.salariu * 0.1
    end "Bonus"
FROM
    angajati b, angajati a
    NATURAL JOIN departamente d
group by d.den_dep, a.nume, a.salariu, a.functie
order by 1, 2;


-- metoda 4

select
	den_dep Den_depart,
	nume Nume,
	salariu Salariu,
	(select avg (salariu) salariu from angajati) Sal_med_comp,
	(case
		when functie = 'MANAGER' then 0
		when functie = 'PRESIDENT' then 0
		else (decode (sign (salariu - (select avg (salariu) salariu from angajati)), 
			-1, salariu * 0.1, salariu * 0.2))
			end) Bonus
from angajati natural join departamente;

--metoda 4
select
	d.den_dep Den_depart,
	a.nume Nume,
	a.salariu Salariu,
	avg(a1.salariu) Sal_med_comp,
	(case
		when a.functie = 'MANAGER' then 0
		when a.functie = 'PRESIDENT' then 0
		else (decode (sign (a.salariu - avg(a1.salariu)), 
			-1, a.salariu * 0.1, a.salariu * 0.2))
			end) Bonus
from angajati a natural join departamente d,
	angajati a1
group by d.den_dep, a.nume, a.salariu, a.functie;

update login_lab_bd set data_sf= sysdate where laborator='Lab7';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab7';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 