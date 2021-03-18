define id_sef = 7902
define data_ang_sef = '03-DEC-81'

SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &id_sef;