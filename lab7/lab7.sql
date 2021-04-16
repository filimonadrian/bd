
--testare functii

select to_char(sysdate, 'DD-MM-YYYY') data_curenta
from dual;

select to_date('15112006', 'DD-MM-YYYY') data_ex
from dual;

select to_char(-10000, '$999999.99MI') valoare
from dual;

select to_char('$10000.00-', '$999999.99MI') valoare
from dual;


Ex 1. Să se selecteze toți angajații care au venit în firmă în 1982.


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

SELECT
    nume,
    to_char(data_ang, 'dd-mm-yyyy') data_ang
FROM angajati
WHERE to_number (to_char (data_ang, 'YYYY')) = 1982;


-- 123
column numar format 99999
select 123.14 numar from dual;

--123.14
column numar format 999.99
select 123.14 numar from dual;

--$123.13
column numar format $999.99
select 123.13.numar from dual;

-- 00123.13 si 00000.14
column numar format 00999.99
select 123.14 numar from dual;
select 0.14 numar from dual;


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

select greatest (23, 12, 34, 77, 89, 52) greatest gr
from dual;

select least (23, 12, 34, 77, 89, 52) greatest lst
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
    decode (sign (data_ang - to_date('1 JAN 1982')),
        -1, salariu * 1.25, 
        salariu * 1.10) prima
from angajati
where id_dep = 20;
order by functie;


select
    case lower (locatie)
        when 'new-york' then 1
        when 'dallas' then 2
        when 'chicago' then 3
        when 'boston' then 4
    end cod_dep
from departamente;

SELECT
    case
        when lower(locatie) = 'nwe york' then 1
        when id_dep = 20
            or lower(locatie) = 'dallas' then 2
        when lower(locatie) = 'chicago' then 3
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
    salariu + +nvl(comision, 0) "sal + nvl_com"
from angajati
where id_dep = 30l
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
    min(dis)
