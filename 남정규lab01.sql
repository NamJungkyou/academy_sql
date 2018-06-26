-- 실습 1)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
  FROM emp e
 ORDER BY e.sal DESC;
 
-- 실습 2)
SELECT e.empno
      , e.ename
      , e.hiredate
  FROM emp e
 ORDER BY e.hiredate ASC;
  
-- 실습 3)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
 ORDER BY e.comm ASC;
 
--실습 4)
SELECT e.EMPNO
     , e.ENAME
     , e.COMM
  FROM emp e
 ORDER BY e.comm DESC;
 
-- 실습 5)
SELECT e.empno AS "사번"
     , e.ename AS "이름"
     , e.sal AS "급여"
     , e.hiredate AS "입사일"
FROM emp e
;

-- 실습 6)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
;

-- 실습 7)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.ename = 'ALLEN'
;

-- 실습 8)
SELECT e.EMPNO
     , e.ENAME
     , e.DEPTNO
  FROM emp e
 WHERE e.deptno = 20
;

-- 실습 9)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , e.DEPTNO
  FROM emp e
 WHERE e.deptno = 20
   AND e.sal < 3000
;

-- 실습 10)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL+(nvl(e.comm, 0))
  FROM emp e
;
