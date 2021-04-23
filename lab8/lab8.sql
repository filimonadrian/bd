
spool C:\Users\Adrian\Documents\bd\lab8\spool_bd_lab8_23apr2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab8', user, sysdate, null, null);
select * from login_lab_bd;

-- ex 1 - Angajatul cu cel mai mare salariu din firma

SELECT
    id_dep,
    nume,
    functie,
    salariu
FROM angajati
WHERE
    salariu = (SELECT max(salariu)
                FROM angajati);

-- ex 2: angalatii care au functii ssimilare functiilor din departamentul 20
-- si nu lucreaza in acest departament

SELECT
    id_dep,
    nume,
    functie,
    salariu
FROM angajati
WHERE
    NOT id_dep = 20 AND
    functie IN (SELECT functie
                FROM angajati
                WHERE id_dep = 20)
ORDER BY functie;

-- ex 3
-- angajatii care nu s-au angajat in decembrie, ianuarie si februarie

SELECT
    nume,
    functie,
    data_ang
FROM angajati
WHERE
    data_ang NOT IN (SELECT distinct(data_ang)
                    FROM angajati
                    WHERE to_char(data_ang, 'MON') IN ('DEC', 'JAN', 'FEB'))
ORDER BY nume;


-- ex 4
-- au salariile in lista de salarii maxime pe departament

SELECT
    den_dep,
    nume,
    salariu
FROM angajati
    NATURAL JOIN departamente
WHERE
    salariu IN
    (SELECT max(salariu)
    FROM angajati
    GROUP BY id_dep)
ORDER BY den_dep;



-- ex 5
-- angajatii care au venit in acealasi an si au aceeasi functie cu angajatul
-- care are numele JONES

SELECT
    id_dep,
    nume,
    functie,
    data_ang
FROM angajati
WHERE
    (TO_CHAR(data_ang, 'YYYY'), functie) IN
    (SELECT to_char(data_ang, 'YYYY'), functie
        FROM angajati
        WHERE LOWER(nume) = 'jones');

-- ex 6
-- angajatii care au salariu lunar minim pe fiecare departament

SELECT
    id_dep,
    nume,
    salariu
FROM angajati
WHERE
    (id_dep, salariu + nvl(comision, 0)) IN
    (SELECT id_dep, min(salariu + nvl(comision, 0))
        FROM angajati
        GROUP BY id_dep)
ORDER BY id_dep;

-- ex 7
-- angajatii cu salariul mai mare decat salariul maxim din dep SALES

SELECT
    nume,
    functie,
    data_ang,
    salariu
FROM angajati
WHERE
    salariu >
    (SELECT MAX(salariu)
        FROM angajati
        WHERE
            LOWER(den_dep) = 'sales');


SELECT
    nume,
    functie,
    data_ang,
    salariu
FROM angajati
WHERE
    salariu >
    (SELECT MAX(salariu)
        FROM angajati
        WHERE
            id_dep = (SELECT id_dep
                        FROM departamente
                        WHERE
                            LOWER(den_dep) = 'sales'));


-- ex 8
-- angajatii cu ssalariul peste valoarea medie a departamentului din care fac parte
SELECT
    a.id_dep,
    a.nume,
    a.functie,
    a.salariu
FROM angajati a
WHERE
    a.salariu > (SELECT AVG(b.salariu)
                    FROM angajati b
                    WHERE b.id_dep = a.id_dep)
ORDER BY a.id_dep;

-- ex 9
-- sa se mareasca salariile angajatilor cu 10% din salariul mediu si sa se 
-- acorde tuturor angajatilor un comision egal cu comisionul mediu pe fiecare
-- departament, numai pentru persoanele angajate inainte de 1-JUN-1981

UPDATE angajati a
SET
    (a.salariu, a.comision) = 
        (SELECT 
            a.salariu + avg(b.salariu * 0.1),
            a.comision + avg(b.comision * 0.1)
        FROM angajati b
        WHERE a.id_dep = b.id_dep)
WHERE
    data_ang <= '1-JUN-81';

-- ex 10
-- sa se afle salariul maxim pentru fiecare departament

-- metoda 1
SELECT
    b.id_dep,
    a.den_dep,
    b.max_sal_dep
FROM
    departamente a,
    (SELECT
        id_dep,
        max(salariu) max_sal_dep
    FROM angajati
    GROUP BY id_dep) b
WHERE a.id_dep = b.id_dep
ORDER BY b.id_dep;

-- metoda 2
SELECT
    b.id_dep,
    a.den_dep,
    b.max_sal_dep
FROM
    departamente a INNER JOIN
        (SELECT
            id_dep,
            max(salariu) max_sal_dep
        FROM angajati
        GROUP BY id_dep) b
    ON a.id_dep = b.id_dep

ORDER BY b.id_dep;




update login_lab_bd set data_sf= sysdate where laborator='Lab8';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab8';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 