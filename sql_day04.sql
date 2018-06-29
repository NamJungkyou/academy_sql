-- sql_day04

-- JOIN

-- 문제) 직원중에 부서가 없는 사람이 있을때
-- 1. 일반 조인(EQUI-JOIN)을 걸면 조회가 안된다
SELECT e.empno
     , e.ename
     , e.deptno
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno=d.deptno
;
-- 2. OUTER JOIN으로 해결
SELECT e.empno
     , e.ename
     , e.deptno
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno=d.deptno(+)
;
-- (+)연산자는 오른쪽에 붙이면 NULL이 오른쪽 테이블에 출력
-- 전체 데이터를 기준삼는 테이블이 왼쪽이기 때문에 LEFT OUTER JOIN 발생


SELECT e.empno
     , e.ename
     , e.deptno
     , d.dname
 FROM emp e LEFT OUTER JOIN dept d
     ON e.deptno=d.deptno(+)
;