ACCEPT id_dep NUMBER prompt 'Introduceti id_dep: '
ACCEPT med_income NUMBER prompt 'Introduceti med_income: '

SELECT nume, '&id_dep', salariu * 12 salariu_anual
    FROM angajati
    WHERE salariu*12 > &med_income and id_dep = &id_dep;
