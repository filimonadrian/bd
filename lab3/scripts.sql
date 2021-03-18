
-- tema de curs
-- metoda 1
SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &id_sef;

-- metoda 2
define id_sef = 7902
define data_ang_sef = '03-DEC-81'

SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &id_sef;

-- metoda 3
accept id_sef char prompt "Introduceti ecusonul sefului:"
accept data_ang_sef char prompt "Introduceti data de angajare a sefului:"

SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &id_sef;


-- metoda 4
SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '03-DEC-81' and id_sef = 7902;

-- metoda 5
SELECT nume, data_ang Data_angajare, functie JOB, &&id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &&id_sef;

-- exercitiul 5
SELECT id_ang, nume, functie, data_ang
    FROM angajati
    WHERE functie = '&1' AND data_ang > '&2'
    ORDER BY data_ang;
    
-- exercitiul 6
ACCEPT functie_ang char prompt 'Introduceti functia angajatului: '
SELECT nume, salariu, comision
    FROM angajati
    WHERE functie='&functie_ang';

undefine functie_ang

-- exercitiul 7
accept id_ang char prompt 'Introduceti ecusonul angajatului:'
accept nume char prompt: 'Introduceti numele angajatului:'
accept functie char prompt: 'Introduceti functia angajatului:'
accept salariu char prompt: 'Introduceti salariul angajatului:' hide

INSERT INTO angajati(id_ang, nume, functie, salariu)
    VALUES (&id_ang, '&nume', '&functie', &salariu);

undefine id_ang
undefine functie
undefine nume
undefine salariu

-- exercitiu independent ocw
-- metoda 1
ACCEPT id_dep NUMBER prompt 'Introduceti id_dep: '
ACCEPT med_income NUMBER prompt 'Introduceti med_income: '

SELECT nume, '&id_dep', salariu * 12 salariu_anual
    FROM angajati
    WHERE salariu*12 > &med_income and id_dep = &id_dep;

-- metoda 2
SELECT nume, '&&id_dep', salariu * 12 salariu_anual
    FROM angajati
    WHERE salariu*12 > &med_income and id_dep = &id_dep;

-- metoda 3
SELECT nume, '&id_dep', salariu * 12 salariu_anual
    FROM angajati
    WHERE salariu*12 > &med_income and id_dep = &id_dep;

