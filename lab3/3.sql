accept id_sef char prompt "Introduceti ecusonul sefului:"
accept data_ang_sef char prompt "Introduceti data de angajare a sefului:"

SELECT nume, data_ang Data_angajare, functie JOB, &id_sef Ecuson_sef from angajati
    WHERE data_ang < '&data_ang_sef' and id_sef = &id_sef;

