-- @C:\Users\Adrian\Documents\bd\test1_lab\incercari.sql

-- pb1

-- accept id_dep char prompt 'Incearca-ti norocul: '
-- define id_dep = 10;
-- SELECT
--     DEPTNO,
--     'Angajatul ' || ENAME || ' are id-ul ' || EMPNO,
--     COMM,
--     SAL
-- FROM emp
-- WHERE (ENAME LIKE '%A%') AND
--     (COMM IS NULL OR COMM = 0) AND 
--     (DEPTNO = &id_dep);



-- pb2 cu define

-- define t_sal = 2000
-- define ch = a
-- SELECT 
--     ENAME || ' cu functia ' || JOB AS "Info angajat",
--     12 * SAL AS "Venit anual"
-- FROM emp
-- WHERE
--     (12 * SAL > &t_sal) AND
--     (lower(ENAME) NOT LIKE '%&ch');

-- script cu parametri

-- SELECT 
--     ENAME || ' cu functia ' || JOB AS "Info angajat",
--     12 * SAL AS "Venit anual"
-- FROM emp
-- WHERE
--     (12 * SAL > &1) AND
--     (ENAME NOT LIKE '%&2');



-- 02-APR-81

-- --metoda 1
-- SELECT
--     DEPTNO || '     ' || ENAME || '     ' || HIREDATE || '     ' || COMM || '     ' || '&&data_angajare_manager'
-- FROM EMP
-- WHERE
--     (DEPTNO = &&id_dep) AND
--     (COMM IS NULL OR COMM = 0) AND
--     (HIREDATE > '&&data_angajare_manager');


-- accept data_angajare_manager char prompt 'Introduceti data de angajare a managerului: '
-- accept id_dep char prompt 'Introduceti id-ul departamentului: '
-- SELECT
--     DEPTNO || '     ' || ENAME || '     ' || HIREDATE || '     ' || COMM || '     ' || '&&data_angajare_manager'
-- FROM EMP
-- WHERE
--     (DEPTNO = &id_dep) AND
--     (COMM IS NULL OR COMM = 0) AND
--     (HIREDATE > '&data_angajare_manager');


-- metoda 3

define data_angajare_manager = 02-APR-81
define id_dep = 20
SELECT
    DEPTNO || '           ' || ENAME || '           ' || HIREDATE || '           ' || COMM || '           ' || '&data_angajare_manager' AS
    "ID_DEP      Nume_ang      Data_angajare      Comision       Data_angajare_director"
FROM EMP
WHERE
    (DEPTNO = &id_dep) AND
    (COMM IS NULL OR COMM = 0) AND
    (HIREDATE > '&data_angajare_manager');
undef data_angajare_manager
undef id_dep


-- metoda 4

-- SELECT
--     DEPTNO || '           ' || ENAME || '           ' || HIREDATE || '           ' || COMM || '           ' || '&1' AS 
--     "ID_DEP      Nume_ang      Data_angajare      Comision       Data_angajare_director"
-- FROM EMP
-- WHERE
--     (DEPTNO = &2) AND
--     (COMM IS NULL OR COMM = 0) AND
--     (HIREDATE > '&1');