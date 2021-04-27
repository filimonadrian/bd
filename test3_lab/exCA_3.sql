-- Sa se acorde o prima pentru fiecare sef, care are cel putin 3 subalterni: 
--numele, denumirea departamentului din care face parte, PRIMA, numarul subalternilor.

-- Prima se calculeaza ca fiind jumatate din salariu, truncheata la valori intregi.
-- Lista se va afisa cu antetul:
-- Sef, Denumire departament, PRIMA, Nr subalterni

-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE

select a.ename Sef,
    d.dname as "Denumire departament",
    trunc(a.sal / 2) PRIMA,
    count(a1.mgr ) as "Nr subalterni"
  from emp a,
  dept d,
  emp a1
 where a1.mgr = a.empno and d.deptno = a.deptno
 group by a.ename,
 d.dname,
 a.sal
 having count(a1.mgr) >= 3;



-- Sa se efectueze o lista de premiere pentru angajatii care nu primesc comision 
-- si care au venit in firma cu cel putin 2 luni dupa sefii lor directi.
-- Astfel:
-- - daca gradul salarial al angajatului este 1, prima va fi 500
-- - daca gradul salarial al angajatului este 2, prima va fi 300
-- - daca gradul salarial al angajatului este 3, prima va fi 100
-- - restul angajatilor nu primesc prima

-- Antetul listei va fi:
-- Nume ang, Comision ang, Data angajare, Data angajare sef, Grad salarial, PRIMA

-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select a.ename Nume,
    nvl(a.comm,0) Comision,
    a.hiredate Data_ang,
    a1.hiredate Data_aSef,
    g.grade Grad,
    case 
      when months_between(a.hiredate, a1.hiredate) >= 2 
      then
        case 
          when g.grade = 1 then 500
          when g.grade = 2 then 300
          when g.grade = 3 then 100
          else 0
        end
      else 0
    end "Prima"
  from emp a,
  emp a1,
  salgrade g
 where a.mgr = a1.empno and 
    a.sal >= g.losal and a.sal <= g.hisal and 
    months_between(a.hiredate, a1.hiredate) >= 2 and 
    nvl(a.comm,0) = 0
order by a.ename, 
a.hiredate,
g.grade; 

-- Pentru fiecare angajat, care are salariul in unul din gradele 3, 4 sau 5, sa se calculeze un calificativ, astfel:
-- - daca data angajarii este anterioara datei angajarii lui BLAKE, atunci calificativul este FOARTE APRECIAT
-- - daca data angajarii este ulterioara sau egala cu data angajarii lui BLAKE, atunci calificativul este APRECIAT
-- - daca angajatul primeste comision, atunci calificativul este PREMIAT

-- Lista se va afisa cu antetul:
-- Nume, Comision, Grad salarial, Data angajare, Data angajare BLAKE, Calificativ

-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select a.ename Nume,
    nvl(a.comm,0) Comision,
    g.grade Grad,
    a.hiredate Data_ang,
    b.Data_ang_BLK,
    case 
      when g.grade = 3 or g.grade = 4 or g.grade = 5 then
            case 
              when a.hiredate < b.Data_ang_BLK then 'Foarte Apreciat' 
              when a.hiredate >= b.Data_ang_BLK then 'Apreciat'
              when nvl(a.comm,0) > 0 then 'Apreciat' 
                else '-'
            end
      else '-'
    end "Calificativ"
  from (select hiredate Data_ang_BLK from emp where ename = 'BLAKE') b,
        emp a,
        SALGRADE g
where a.sal >= g.losal and a.sal <= g.hisal ;
group by a.ename,
        g.grade,
        a.hiredate,
        a.comm,
        b.Data_ang_BLK; 



-- Sa se afiseze pentru toti angajatii care s-au angajat inaintea sefului lor si au gradul de salarizare 
-- mai mare sau egal cu 3, numarul intreg de zile de concediu la care au dreptul,  
-- calculat dupa formula  zile=abs(sin(sqrt(vec*grad))*150).

-- unde vec=vechime in ani nerotunjita
-- grad=gradul din grila de salarizare
-- Lista are antetul nume, grad, concediu si se ordoneaza alfabetic.

-- Sa se rezolve prin doua metode distincte folosind diverse functii SQL.
-- Pentru testare se va utiliza baza de date a userului scott, formata din tabelele EMP, DEPT si SALGRADE.

select a.ename Nume, 
    g.grade Grad,
    case 
      when a1.hiredate > a.hiredate and g.grade >= 3  then trunc(abs(sin(sqrt((sysdate - a.hiredate) * g.grade))*150))
    end Concediu
  from emp a,
    emp a1,
    salgrade g
where a.sal >= g.losal and a.sal <= g.hisal and 
    a1.empno = a.mgr and a1.hiredate > a.hiredate and g.grade >= 3
 order by a.ename;




