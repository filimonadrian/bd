spool C:\Users\Adrian\Documents\bd\lab10\spool_bd_lab10_14mai2021.lst
set lines 200
set pages 100
select to_char(sysdate, ’dd-mm-yyyy hh:mi:ss’) from dual;
insert into login_lab_bd values( 'Filimon Adrian', '334CC', 'Lab10', user, sysdate, null, null);
select * from login_lab_bd;

-- exemplu create table

create table exemplu (
    data_implicita date default sysdate,
    numar_implicit number(7, 2) default 7.24,
    string_implicit varchar(5) default 'test',
    operator varchar2(10) default user
);

-- pentru a afla valorile default
select table_name, column_name, data_default
from user_tab_columns
where table_name='EXEMPLU';



-- ex 1

create table studenti (
    facultate char(30) default 'Automatica si Calculatoare',
    catedra char (20),
    cnp number(13),
    nume varchar (30),
    data_nasterii date,
    an_univ_number(4) default 2019,
    medie_admitere number(4, 2),
    discip_oblig varchar2(20) default 'Matematica',
    discip_opt varchar(20) default 'Fizica',
    operator varchar(20) default user,
    data_op timestamp default sysdate
);

-- ex 2
create table dept_20
as 
select id_Dep, nume, data_ang, salariu + nvl(comision, 0) venit
from angajati
where id_dep = 20;

-- ex 3

create table dept_30 (
    id default 30,
    nume not null,
    data_ang,
    prima
)
as
select
    id_dep, nume, data_ang,
    round (0.15 * (salariu + nvl(comision, 0)), 0)
from angajati
where id_dep = 30;


-- constrangerea not null

create table exemplu2 (
    col1 number(2) constraint nn_col1 not null,
    col2 varchar2(20) NOT NULL
);

-- constrangerea UNIQUE

create table ex3 (
    col1 number(2) constraint uq_col1 unique,
    col2 varchar2(20) unique
);

create table ex4 (
    col1 nunmber(2),
    col2 varchar2(20),
    constraint uq_col1_a unique(col1),
    unique(col2)
);

create table ex5 (
    col1 number(2),
    col2 varchar2(20),
    constraint uq_col12 unique(col1, col2)
);


-- ex 4
-- nomenclator de functii care fiecare functie sa aiba 
-- un cod unic

create table functii (
    cod number(2) constraint pk_cod primar key,
    functie varchar2(20),
    data_vigoare date default sysdate
);



-- ex 5
-- tabela cu date despre persoana
-- pk pe seria CI, cod CI si cnp

create table persoane (
    nume varchar2(20),
    prenume varchar2(20),
    serie_ci varchar2(2),
    cod_ci number(6),
    cnp number(13),
    constraint pk_persoane primary key(serie_ci, cod_ci, cnp)
);


-- ex 6
-- tabela angajati - sa se adauge PK si FK

create table angajati2 (
    id_ang number(4)
        constraint pk_id_ang2
        primary key,
    id_sef number(4),
    id_dep number(2)
        constraint fk_id_dep2
        references departamente(id_dep),
    nume varchar2(20),
    functie varchar2(9),
    data_ang date,
    salariu number(7, 2),
    comision number(7, 2),
    constraint fk_id_sef2
        foreign key(id_sef)
        references angajati2(id_ang)
);

-- ex 7
-- tabela angajati cu CHECK:
-- salariu > 0
-- comisionul nu depaseste salariul
-- numele este scris doar cu litere mari

create table angajati3 (
    id_ang number(4)
        constraint pk_id_ang3
        primary key,
    id_sef number(4)
        constraint fk_id_sef3 references angajati3(id_ang),
    id_dep number(2)
        constraint nn_id_dep3 not null,
    nume varchar2(20)
        constraint ck_nume check=(nume = upper(nume)),
    functie varchar2(9),
    data_ang date default sysdate,
    salariu number(7, 2)
        constraint nn_salariu not null,
    comision number(7, 2),
    constraint fk_id_dep3 foreign key(id_dep)
        references departamente(id_dep),
    constraint ck_comision check(comision <= salariu)
);


--- alter table examples

create table ex6 (
    colA number(2), col2 number(2), col3 number(2),
    col4 number(2), col5 number(2), col6 number(2),
    col7 number(2), col8 number(2), col9 number(2)
);

-- redenumirea unui tabel
alter table ex6 rename to exAlter;

-- redenumirea unei coloane
alter table exAlter rename column colA to col1;

-- schimbarea tipului unei coloane
alter table exAlter modify (col1 varchar2(20));

-- schimbarea tipului mai multor coloane
alter table exAlter modify (col2 varchar2(20), col3 date);

-- marcarea unei coloane ca neutilizabila
alter table exAlter set unused(col4);

-- marcarea mai multor coloane ca neutilizabile
alter table exAlter set unusued(col5, col6);

-- stergerea coloanelor unused
alter table exAlter drop unused columns;

-- adaugam coloanele din nou
alter table exAlter add (
    col4 varchar2(20),
    col5 varchar2(20),
    col6 varchar2(20)
);

-- stergerea unei coloane
alter table exAlter drop col7;

-- stergerea mai multor coloane
alter table exAlter drop (col8, col9);

-- adaugarea unei constrangeri PK
alter table exAlter add constraint pk_col1_alter primary key (col1);

-- adaugarea unui PK pe mai multe coloane
alter table exAlter add constraint pk_col2_alter primary key (col1, col2);

-- adaugarea unui FK
alter table exAlter add
    constraint fk_col21 foreign key (col2)
    references exAlter (col1)

-- adaugarea unui FK pe mai multe coloane
alter table exAlter add
    constraint fk_col34_12 foreign key (col3, col4)
    references exAlter (col1, col2);

-- adaugarea unique
alter table exAlter add
    constraint uq_col3_alter unique (col3);

-- adaugarea unique pe mai multe coloane
alter table exAlter add
    constraint uq_col45_alter unique (col4, col5);

-- dezactivare constrangeri
alter table exAlter disable constraint uq_col3_alter;

-- activare constrangeri
alter table exAlter enable constraint uq_col3_alter;

-- stergere constrangeri
alter table exAlter drop constraint uq_col3_alter

---- adaugarea unei coloane noi
alter table angajati2 add venite number(4, 3);

alter table angajati add (
    vechime number(4),
    venit_anual number(6, 2)
);

-- stergere tabela:
DROP table table_name

-- golirea unui tabel - truncate - sterge toate liniile
-- !!! dupa truncate rollback nu are efect
-- este mai rapida decat delete
TRUNCATE table table_name;


-- inserare intr-o tabela
create table dept2 (
    id_dep number(2),
    dname varchar2(14)
);

insert into dept2 values (50, 'IT');
insert into dept2(id_dep) values(60);

insert into dept2
    select deptno, dname
    from dept
    where deptno in (20, 30);

select * from dept2;


--- comanda update

update dept2
set dname = 'HR',
    id_dep = 80;
where id_dep = 60;

update dept2
set dname = 'Human Red'
where id_dep = 80;

update dept2
set (id_dep, dname) = (select deptno, dname
                        from dept
                        where deptno = 10)
where id_dep = 20;


---- comanda delete

delete from dept2
where id_dep = 80;

select * from dept2;

delete from dept2
where (id_dep, dname) in (select deptno, dname
                            from dept
                            where deptno in (10, 30));


select * from dept2;
delete from dept2;


--- comenzile commit si rollback
-- commit - folosit pentru a face persitente informatiile din baza de date
-- rollback readuce starea bazei de date la o stare anterioara


---- sequence
-- un obiect al bazei de date care genereaza numere intregi unice
-- folosit pentru a genera valori pentru PK

-- creare secventa
create sequece seq_id_dep
start with 1
increment by 10
nocache
nocycle;

-- modificare secventa
alter sequence seq_id_dep cycle;

-- utilizare sequence
insert into dept2
values (seq_id_dep.nextval, 'test');

-- stergere secventa
drop sequence seq_id_dep;

---- index
-- stryctyra care imbunatateste viteza de acces la date
-- se creeaza automat cand se creeaza un PK sau un FK

-- crearea unui index
create index idx_name on dept2(dname);

-- modifica indexul la 5 tranzactii de intrare
-- si urmatoarea incrementare sa fie la 100k
alter index idx_name initrans 5 storage (next 100k);

-- stergerea unui index
drop index idx_name;

---- view
-- tabela logica care extrage date dintr-o tabela propriu-zisa
-- nu are date proprii

create or replace view view_dept
    as select id_dep, den_dep from departamente;

select * from view_dept;

insert into view_dept values (80, 'test');

select * from view_dept;

update view_dept
    set den_dep = 'HR'
    where id_dep = 80;

select * from view_dept;

delete from view_dept where id_dep = 80;

drop view view_dept;















update login_lab_bd set data_sf= sysdate where laborator='Lab10';
update login_lab_bd set durata= round((data_sf-data_in)*24*60) where laborator='Lab10';
commit;
select instance_number,instance_name, to_char(startup_time, 'dd-mm-yyyy hh:mi:ss’), host_name
from v$instance;
select nume_stud, grupa, laborator, to_char(data_in, 'dd-mm-yyyy hh:mi:ss') data_inceput,
to_char(data_sf, 'dd-mm-yyyy hh:mi:ss') data_sfarsit, durata minute_lucrate from login_lab_bd;
spool off; 