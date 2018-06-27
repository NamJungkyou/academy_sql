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

-- 실습 11)
SELECT e.EMPNO
     , e.ENAME
     , e.SAL*12
  FROM emp e
;

-- 실습 12)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.COMM
  FROM emp e
 WHERE e.ENAME 
    IN('MARTIN', 'BLAKE')
 ;
 
-- 실습 13)
 SELECT e.EMPNO
      , e.ENAME
      , e.JOB
      , e.SAL+(nvl(e.comm, 0))
   FROM emp e
  WHERE e.ENAME 
     IN('MARTIN', 'BLAKE')
;

-- 실습 14)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm != 0
;
 
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm <> 0
;
 
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm > 0
;
 
-- 실습 15)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm IS NOT NULL
;
 
-- 실습 16)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.deptno = 20
   AND e.sal >2500
;

-- 실습 17)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.job = 'MANAGER'
    OR e.deptno = 10
;

-- 실습 18)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.job
    IN ('MANAGER', 'CLERK', 'SALESMAN')
;

-- 실습 19)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.ename
  LIKE 'A%'
;

-- 실습 20)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.ename
  LIKE '%A%'
;

-- 실습 21)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.ename
  LIKE '%S'
;

-- 실습 22)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.ename
  LIKE '%E_'
;

-- 실습 23)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.sal
BETWEEN 2500
    AND 3000
;

-- 실습 24)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm IS NULL
;

-- 실습 25)
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.HIREDATE
     , e.COMM
     , e.DEPTNO
  FROM emp e
 WHERE e.comm IS NOT NULL
;

-- 실습 26)
SELECT e.EMPNO 사번
     , e.ENAME || '의 월급은 '|| e.SAL || ' 입니다.' as 월급여
  FROM emp e
;

-- 푸시테스트