
spool C:\Users\Adrian\Documents\bd\lab5\spool_bd_lab5_1apr2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab5', user, sysdate, null, null);
select * from login_lab_bd;



--ex1

-- metoda 1

select nume, functie, den_dep
from angajati, departamente
where functie = 'ANALYST';


-- metoda2
select nume, functie, den_dep
from angajati
    CROSS JOIN departamente
where functie = 'ANALYST';


-- metoda 1
-- folosind alias

select 
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
from 
    angajati a,
    departamente d
where 
    a.id_dep = d.id_dep AND
    a.id_dep = 10
ORDER BY 3;

-- metoda 1 folosind numele tabelului
SELECT 
    angajati.id_dep,
    departamente.den_dep,
    angajati.nume,
    angajati.functie
FROM
    angajati,
    departamente
WHERE
    angajati.id_dep = departamente.id_dep AND
    angajati.id_dep = 10
ORDER BY 3;


-- metoda 2
-- varianta 1

SELECT 
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    JOIN departamente d ON a.id_dep = d.id_dep
WHERE
    a.id_dep = 10
ORDER BY 3;

-- metoda 2 varianta 2
SELECT 
    a.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM 
    angajati a
    INNER JOIN departamente d ON a.id_dep = d.id_dep
WHERE
    a.id_dep = 10
ORDER BY 3;

-- metoda 3 varianta 1
-- folosind using

SELECT
    id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    INNER JOIN departamente d USING  (id_dep)
WHERE
    id_dep = 10
ORDER BY 3;

-- metoda 3 variaanta 2
-- folosind using

SELECT
    id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    angajati a
    JOIN departamente d USING (id_dep)
WHERE 
    id_dep = 10
ORDER BY 3;

-- ex 3
SELECT
    id_dep,
    den_dep,
    nume,
    functie
FROM
    angajati
    NATURAL JOIN departamente
WHERE
    id_dep = 10
ORDER BY 3;
    

    
-- ex 4

-- metoda 1
SELECT
    a.nume,
    a.salariu,
    g.grad
FROM
    angajati a,
    grila_salariu g
WHERE
    a.salariu BETWEEN g.nivel_inf AND g.nivel_sup AND
    a.id_dep = 20;

-- metoda 2

SELECT
    a.nume,
    a.salariu,
    g.grad
FROM
    angajati a
    INNER JOIN grila_salariu g ON a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
WHERE
    a.id_dep = 20;

-- ex 5
-- metoda 1
SELECT
    a.nume,
    a.salariu,
    g.grad,
    d.den_dep
FROM
    angajati a, grila_salariu g, departamente d
WHERE
    a.salariu BETWEEN g.nivel_inf AND g.nivel_sup AND
    d.id_dep = a.id_dep AND
    a.id_dep = 20
ORDER BY 3, 1;

-- metoda 2 versiunea 1

SELECT
    a.nume,
    a.salariu,
    g.grad,
    d.den_dep
FROM
    angajati a
    INNER JOIN grila_salariu g
            ON a.salariu BETWEEN g.nivel_inf AND g.nivel_sup
    INNER JOIN departamente d
            ON d.id_dep = a.id_dep
WHERE a.id_dep = 20
ORDER BY 3, 1;
    

-- metoda 2, versiunea 2
SELECT
    a.nume,
    a.salariu,
    g.grad,
    d.den_dep
FROM
    angajati a
    JOIN departamente d
            ON d.id_dep = a.id_dep
    JOIN grila_salariu g
            ON a.salariu >= g.nivel_inf AND a.salariu <= g.nivel_sup
WHERE a.id_dep = 20
ORDER BY 3, 1;


-- ex 6
-- metoda 1

SELECT
    a1.nume "Nume angajat",
    a1.functie "Functie angajat",
    a2.nume "Nume sef",
    a2.functie "Functie sef"
FROM
    angajati a1,
    angajati a2
WHERE
    a1.id_sef = a2.id_ang AND
    a1.id_dep = 10;


-- metoda 2

SELECT
    a1.nume "Nume angajat",
    a1.functie "Functie angajat",
    a2.nume "Nume sef",
    a2.functie "Functie sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
WHERE
    a1.id_dep = 10;

-- ex 7
-- metoda 1
SELECT
    d.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    departamente d,
    angajati a
WHERE
    d.id_dep = a.id_dep(+)
ORDER BY a.id_dep;

-- metoda 2
SELECT
    d.id_dep,
    d.den_dep,
    a.nume,
    a.functie
FROM
    departamente d
        LEFT OUTER JOIN angajati a
                ON d.id_dep = a.id_dep
ORDER BY a.id_dep;

-- ex 8

SELECT
    a.nume,
    a.salariu,
    g.grad
FROM grila_salariu g
    FULL OUTER JOIN angajati a
            ON a.salariu * 2 BETWEEN g.nivel_inf AND g.nivel_sup
ORDER BY a.nume;

-- ex 9

-- metoda 1

SELECT
    d.den_dep,
    a.nume,
    a.salariu,
    g.grad
FROM grila_salariu g
        FULL OUTER JOIN angajati a
                RIGHT OUTER JOIN departamente d
                        ON d.id_dep = a.id_dep
                ON a.salariu * 2 BETWEEN g.nivel_inf AND g.nivel_sup
ORDER BY d.den_dep, a.nume, g.grad;


-- metoda 2

SELECT
    d.den_dep,
    a.nume,
    a.salariu,
    g.grad
FROM
    angajati a
    FULL OUTER JOIN grila_salariu g
            ON a.salariu * 2 BETWEEN g.nivel_inf AND g.nivel_sup
    FULL OUTER JOIN departamente d
            ON d.id_dep = a.id_dep
ORDER BY d.den_dep, a.nume, g.grad;


--ex 10

SELECT
    id_dep,
    nume,
    functie,
    salariu
from
    ANGAJATI
where 
    id_dep = 10
UNION
SELECT
    id_dep,
    nume,
    functie,
    salariu
FROM angajati
WHERE
    id_dep = 30;

-- ex 11

select
    id_dep, nume, 'are salariul' are, salariu sal_com
from angajati
where id_dep = 10
UNION
select id_dep, nume, 'are comisionul' are, comision sal_com
from angajati
where id_dep = 30;


-- ex 12

select functie from angajati where id_dep = 10
union all
select functie from angajati where id_dep = 20;


-- ex 13
select functie, nvl(comision, 0) comision
    from angajati where id_dep = 10
intersect
select functie, nvl(comision, 0)
    from angajati where id_dep = 20
intersect
select functie, nvl(comision, 0)
    from angajati where id_dep = 30;

-- ex 14

select functie
    FROM angajati
    WHERE id_dep = 10
MINUS
select functie
    from angajati
    where id_dep = 30;



-- exercitiu individual


-- fara join
SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1,
    angajati a2,
    departamente d
WHERE
    nvl(a1.comision, 0) = 0 AND
    a1.data_ang < a2.data_ang;


-- metoda 1
-- inner join

SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
        INNER JOIN departamente d
                ON a1.id_dep = d.id_dep
WHERE
    nvl(a1.comision, 0) = 0 AND
    a1.data_ang < a2.data_ang;

-- metoda 2
-- equi join

SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1,
    angajati a2,
    departamente d
WHERE
    a1.id_sef = a2.id_ang AND
    a1.id_dep = d.id_dep AND
    nvl(a1.comision, 0) = 0 AND
    a1.data_ang < a2.data_ang;


-- metoda 3
-- inner join + natural join
SELECT
    departamente.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        NATURAL JOIN departamente
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
WHERE
    nvl(a1.comision, 0) = 0 AND
    a1.data_ang < a2.data_ang;



-- metoda 4
-- Join vertical(intersect)
SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
        INNER JOIN departamente d
                ON a1.id_dep = d.id_dep
WHERE
    a1.data_ang < a2.data_ang
INTERSECT
SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
        INNER JOIN departamente d
                ON a1.id_dep = d.id_dep
WHERE
    nvl(a1.comision, 0) = 0;


-- metoda 5
-- Join vertical(minus)
SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
        INNER JOIN departamente d
                ON a1.id_dep = d.id_dep
WHERE
    a1.data_ang < a2.data_ang
MINUS
SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
        INNER JOIN departamente d
                ON a1.id_dep = d.id_dep
WHERE
    nvl(a1.comision, 0) > 0;

-- metoda 6
-- join cu using

SELECT
    d.den_dep AS "Den_depart_subalt",
    a1.nume AS "Nume_subalt",
    a1.data_ang AS "Data_ang_subalt",
    a2.nume AS "Nume_sef",
    a2.data_ang AS "Data_ang_sef"
FROM
    angajati a1
        INNER JOIN departamente d
                USING (id_dep)
        INNER JOIN angajati a2
                ON a1.id_sef = a2.id_ang
WHERE
    nvl(a1.comision, 0) = 0 AND
    a1.data_ang < a2.data_ang;


update login_lab_bd set data_sf= sysdate where laborator='Lab5';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab5';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 