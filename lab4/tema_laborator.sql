-- exercitiu de sfarsit

--metoda 1
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract (YEAR FROM HIREDATE) LIKE ('%&&an_angajare_manager');


--metoda 2
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    (SAL + nvl(COMM, 0) BETWEEN 0 AND 2000) AND
    extract (YEAR FROM HIREDATE) LIKE ('%&&an_angajare_manager');

-- metoda 3
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    HIREDATE LIKE ('%&&an_angajare_manager');

-- metoda 4
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract (YEAR FROM TO_DATE(HIREDATE, 'DD-MON-YYYY')) = &an_angajare_manager;


-- metoda 5
SELECT
    ENAME || '-' || JOB || '     ' || HIREDATE || '     ' || SAL || '     ' || &&an_angajare_manager
FROM EMP
WHERE
    SAL + nvl(COMM, 0) < 2000 AND
    extract(YEAR from data_ang) = (
        SELECT EXTRACT(YEAR FROM HIREDATE)
        FROM EMP
        WHERE 
            DEPTNO = 30 AND
            LOWER(JOB) = 'manager');


-- extragera anului de angajare a managerului
-- SELECT EXTRACT(YEAR FROM HIREDATE)
SELECT EXTRACT (YEAR FROM TO_DATE(HIREDATE, 'DD-MON-YYYY'))
FROM EMP
WHERE 
    DEPTNO = 30 AND
    LOWER(JOB) = 'manager';
