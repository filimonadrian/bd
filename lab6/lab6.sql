
spool C:\Users\Adrian\Documents\bd\lab6\spool_bd_lab6_9apr2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab6', user, sysdate, null, null);
select * from login_lab_bd;


-- returneaza -1
SELECT SIGN(-12) from dual;

--returneaza 12
SELECT ABS(-12) from dual;

--returneaza 15
SELECT CEIL(14.2) from dual;

-- definire PI
DEFINE pi = '(select asin(1) * 2 from dual)';

-- returneaza 0.5
SELECT SIN(30 * &pi / 180) sin from dual;

-- returneaza .5
SELECT COS(60 * &pi / 180) cos from dual;

-- returneaza -1
SELECT TAN (135 * &pi / 180) tan from dual;

--retunreaza 1.175..
SELECT SINH(1) sinh from dual;

-- returneaza 1
SELECT COSH(0) cosh from dual;

-- return 0.462
SELECT TANH(0.5) tanh from dual;

-- return 0.52
SELECT ASIN(0.5) asin from dual;

-- returneaza 1.57
SELECT ACOS(0) acos from dual;

-- return 0.78
SELECT ATAN(1) atan from dual;

-- return 54.59
select EXP(4) exp from dual;

-- return 9
select POWER (3, 2) power from dual;

-- return 3
SELECT SQRT(9) sqrt from dual;

-- return 4.55
SELECT LN(95) ln from dual;

-- return 2
SELECT LOG(10, 100) log from dual;

-- return 4
SELECT MOD(14, 5) mod from dual;

-- return 15.2
SELECT ROUND (15.193, 1) from dual;

-- return 15
SELECT ROUND (15.193) from dual;

-- return 20
SELECT ROUND (15.193, -1) from dual;

-- return 15.1
SELECT TRUNC (15.193, 1) from dual;

-- return 15
SELECT TRUNC (15.193) from dual;

-- return 10
SELECT TRUNC (15.193, -1) from dual;



--functii pentru siruri de caractere
-- returneaza k
select CHR(75) from dual;

--returneaza KING este PRESIDENT
select CONCAT(CONCAT(nume, ' este '), functie ) ANG_FUNC
    from angajati
    where id_ang = 7839;

-- returneaza KING
select INITCAP(nume) ex_initcap
    from angajati
    where id_ang = 7839;

-- returneaza BLACK and BLUE
select REPLACE('JACK si JUE', 'J', 'BL') EX_REPLACE
    from dual;

select RPAD(nume, 10, '*') EX_RPAD
    from angajati where id_dep = 10;

select LPAD(nume, 10, '*') EX_LPAD
    from angajati where id_dep = 10;

-- returneaza POPE
select RTRIM ('Popescu', 'scu') from dual;

-- returneaza ope
SELECT SUBSTR('Popescu', 2, 3) from dual;

-- returneaza 7
select INSTR('Protopopescu', 'op', 3, 2) from dual;

-- returneaza 7
select LENGTH('analyst') from dual;

-- am inlocuit 0 cu spatiu si m cu p
SELECT TRANSLATE('Oana are mere', 'Om', ' p') from dual;


-- functii pentru date calendaristice
select nume, data_ang, ADD_MONTHS(data_ang, 3) data_mod
    from angajati 
    where id_dep = 10;

select nume, data_ang, LAST_DAY(data_ang) ultima_zi
    from angajati
    where id_dep = 10;

select NEXT_DAY('24-MAR-2014', 'MONDAY') urmatoarea_luni
    from dual;


select nume, data_ang,
    MONTHS_BETWEEN('01-JAN-2014', data_ang) luni_vechime1,
    MONTHS_BETWEEN(data_ang, '01-JAN-2014') luni_vechime2
from angajati
where id_dep = 10;


select
    data_ang,
    ROUND(data_ang, 'YEAR') rot_an
from angajati
where id_ang = 7369;


select data_ang,
    ROUND(data_ang, 'MONTH') rot_luna
from angajati
where id_ang = 7369;


select
    data_ang,
    TRUNC(data_ang, 'YEAR') rot_an
from angajati
where id_ang = 7369;

select data_ang,
    TRUNC(data_ang, 'MONTH') rot_luna
from angajati
where id_ang = 7369;

select SYSDATE from dual;

-- extrag ziua
select EXTRACT(DAY from SYSDATE) from dual;

-- extrag luna
select EXTRACT(MONTH from SYSDATE) from dual;

-- extrag anul
select EXTRACT(YEAR from SYSDATE) from dual;

SELECT
    data_ang,
    data_ang + 7,
    data_ang - 7,
    sysdate - data_ang
from angajati
where data_ang like '%JUN%';


-- PENTRU SCHIMBAREA DATEI LA NIVEL DE SESIUNE
-- TREBUIE SA SE MODIFICE PARAMETRUL DE SISTEM NLS_DATE_FORMAT
ALTER SESSION SET NLS_DATE_FORMAT = new_format

-- schimbam formatul datei la nivel de sesiune
-- in DD-MM-YYYY
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
select sysdate form dual;

-- schimbam formatul datei la nivel de sesiune
-- in DD-MM-YYYY HH24:MI:SS
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
select sysdate form dual;

-- schimbam formatul datei la nivel de sesiune
-- in DAY MONTH YEAR
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MONTH-YYYY';
select replace(sysdate, ' ' , '') from dual;

-- exercitiu individual ocw
-- Pentru angajatii ce au numele de lungime 4, faceti o lista cu:

-- - numele angajatului scris cu litere mari
-- - ziua in care s-au angajat
-- - denumirea departamentului in care lucreaza scrisa cu litere mici
-- - initiala numelui sefului

select
    UPPER(a1.nume) || '  ' ||
    EXTRACT(DAY from a1.data_ang) || ' ' ||
    LOWER(d.den_dep) || '   ' ||
    SUBSTR(a2.nume, 0, 1)
from angajati a1
    INNER JOIN angajati a2
            ON a1.id_sef = a2.id_ang
    INNER JOIN departamente d
            ON a1.id_dep = d.id_dep
where LENGTH(a1.nume) = 4;



-- tema de laborator
-- identific a doua litera
-- sterg toate aparitiile
-- fac diferenta de lungimi si aflu cate am sters

select
    nume || '    ' || 
    functie, 
    SUBSTR(functie, 2, 1) AS LITERA, 
    LENGTH(functie) - LENGTH(REPLACE(functie, SUBSTR(functie, 2, 1), '')) AS NR_APARITII
from angajati;



-- ex2

select
    id_dep,
    nume,
    data_ang,
    NEXT_DAY((ADD_MONTHS(data_ang, 3)) - 1, 'FRIDAY') AS Data_evaluare,
    EXTRACT(DAY FROM NEXT_DAY((ADD_MONTHS(data_ang, 3)) - 1, 'FRIDAY')) AS ziua
from angajati
WHERE functie <> 'PRESIDENT';



update login_lab_bd set data_sf= sysdate where laborator='Lab6';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab6';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 