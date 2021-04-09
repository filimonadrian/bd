
-- returneaza -1
SELECT SIGN(-12) from dual;

--returneaza 12
SELECT ABS(-12) from dual;

--returneaza 15
SELECT CEIL(14.2) from dual;

-- definire PI
DEFINE pi = '(select asin(1) * 2 from dual)'

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


select nume, data_ang
    MONTHS_BETWEEN('01-JAN-2014', data_ang) luni_vechime1,
    MONTHS_BETWEEN(data_ang, '01-JAN-2014') luni_vechime2,
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