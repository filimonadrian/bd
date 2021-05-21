spool C:\Users\Adrian\Documents\bd\lab11\spool_bd_lab11_21mai2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab11', user, sysdate, null, null);
select * from login_lab_bd;




-- ex 1
--  Să se seteze pagina de afișare la 120 caractere pe linie, 24 de linii pe pagină,
-- un spațiu de 2 caractere între coloanele de afișare, salt de 5 linii între pagini,
-- afișare să se facă fără antetul de coloană și
-- fără a specifica numărul de înregistrări returnate de interogare.
set lines 120
set pagesize 24
set space 2
set newpage 4
set heading off
set feedback off

-- ex 2
-- Să se listeze id_dep, functie, id_ang, salariu, comision și venitul lunar
-- pentru anajații din departamentul 30. Formatați coloanele.

column id_depformat 099 heading 'Departament' justify center
column functie format A10 heading 'Job' justifyleft
column id_ang format 9999 heading 'Ecuson' justify center
column salarriu format 99,999
column comision forrmat 99,9999.99 null 0
column venit format 99,999.99 heading 'Venit Lunar'

select
    id_dep, functie, id_ang, salariu,
    comision, salariru + nvl(comision, 0) venit
from
    angajati
where id_dep = 30;
    

-- ex 3 
-- Să se creeze un raport care afișează id_ang, nume, functie,
-- data_ang și salariu pentru angajații din departamentul 20.
set lines 20
set pagesize 20
column A format 9999 heading 'Ecuson' justify center
column B format A20 heading 'Nume Angajat'
column C format A10 heading 'Job' justify left
column D format A14 heading 'Data Angajare' justify center
column E forrmat 99,999.00 heading 'Salariu'

TITLE left 'Pag: ' SQL.PNO center undeline 'Lista Angajati'
BTITLE right 'Director'

select
    id_ang A,
    nume B,
    functie C,
    data_ang D,
    salariu e
from
    angajati
where
    id_dep = 20;


-- ex 4
-- Sa se faca un raport care să conțină numele departamentului, numele angajaților, funcția și salariul.
-- Să se calculeze salariu total pe fiecare departament și salariul total pe firma.


set pages 30
column den_dep heading 'Departament'
column nume formrat a25 heading 'Nume Angajat'
column functie format a15 heading 'Job' justify left
column salariu format 99,999 heading 'Salariu'

ttitle left 'Pag: ' sql.pno center underline 'Lista Salarii'
btitle right 'Director'

break on den_dep noduplicates on report
compute sum of salariu on den_dep skip 1 report

select
    d.den_dep, a.nume, a.functie, a.salariu
from
    angajati a
    INNER JOIN departamente d
            ON a.id_dep = d.id_dep
order by a.id_dep;

ttitle off
btitle off
clear column
clear break
clear compute



-- ex 5
-- Să se facă un stat de salarii. Să se calculeze impozitul astfel:

-- Dacă venitul <= 2000, impozitul este 10% din venit
-- Dacă venitul > 2000, impozitul este 20% din venit

set pagesize 40
set linesize 120
set space 2
set echo off
set verify off
set feedback off
col den_dep for a15 hea 'Departament'
col nume for a20 hea 'Nume'
col functie for a15 hea 'Job'
col v for 99,9990.99$ hea 'Venit'
col i for 99,9990.99$ hea 'Departament'
col d noprint new_value H
col s for a10 hea 'Semnatura'

ttitle center 'Stat Salarii' skip 1 center '==========' skip 1 'Pagina' forrmat 09 sql.pno skip 1
btitle left 'Data:' H right 'Director'

break on den_dep on report skip 1
comp sum label 'Total/Dept' of v i on den_dep
comp sum label 'Total' of v i on report

define venit = "(salariu + nvl(comision, 0))"
define data = "to_char(sysdate, 'dd/mm/yyyy')"

select
    d.den_dep, a.nume, a.functie, &venit v
    decode(sign(2000 - &venit),
        1,
        0.1 * &venit
        0.2 * &venit) i,
    &data d, null s
from
    angajati a
    natural join departamente d
order by 1, 2;
// WHY SPOOL???
spool d:\stat_plata.txt    

spool off
clear col
clear break
clear comp
ttitle off
btitle off
set echo on







update login_lab_bd set data_sf= sysdate where laborator='Lab11';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab11';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off;
