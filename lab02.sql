--남정규lab02

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

--------------------------------------------------------------------------------------

-- 실습 1)
SELECT initcap(e.ename) as 이름
  FROM emp e
;
/*
이름
------------
Smith
Allen
Ward
Jones
Martin
Blake
Clark
King
Turner
James
Ford
Miller
*/

-- 실습 2)
SELECT lower(e.ename) as 이름
  FROM emp e
;
/*
이름
--------
smith
allen
ward
jones
martin
blake
clark
king
turner
james
ford
miller
*/

-- 실습 3)
SELECT upper(e.ename) as 이름
  FROM emp e
;
/*
이름
--------------------------------------
SMITH
ALLEN
WARD
JONES
MARTIN
BLAKE
CLARK
KING
TURNER
JAMES
FORD
MILLER
*/

-- 실습 4)
SELECT length('korea')
  FROM dual
;
/*
 LENGTH('KOREA')
--------------------------------------
5
*/
SELECT lengthb('korea')
  FROM dual
;
/*
 LENGTHB('KOREA')
--------------------------------------
5
*/

-- 실습 5)
SELECT length('남정규')
  FROM dual
;
/*
LENGTH('남정규')
--------------------------------------
3
*/
SELECT lengthb('남정규')
  FROM dual
;
/*
LENGTHB('남정규')
--------------------------------------
9
*/

-- 실습 6)
SELECT concat('SQL', '배우기')
  FROM dual
;
/*
CONCAT('SQL','배우기')
--------------------------------------
SQL배우기
*/

-- 실습 7)
SELECT substr('SQL 배우기', 5, 2)
  FROM dual
;
/*
SUBSTR('SQL 배우기',5,2)
--------------------------------------
배우
*/

-- 실습 8)
SELECT lpad('SQL', 7, '$')
  FROM dual
;
/*
LPAD('SQL',7,'$')
--------------------------------------
$$$$SQL
*/

-- 실습 9)
SELECT rpad('SQL', 7, '$')
  FROM dual
;
/*
RPAD('SQL',7,'$')
--------------------------------------
SQL$$$$
*/

-- 실습 10)
SELECT ltrim('    sql 배우기  ')
  FROM dual
;
/*
LTRIM('SQL배우기')
--------------------------------------
sql 배우기  
*/

-- 실습 11)
SELECT rtrim('    sql 배우기  ')
  FROM dual
;
/*
RTRIM('SQL배우기')
--------------------------------------
    sql 배우기
*/

-- 실습 12)
SELECT trim('    sql 배우기  ')
  FROM dual
;
/*
TRIM('SQL배우기')
--------------------------------------
sql 배우기
*/

-- 실습 13)
SELECT nvl(e.comm, 0)
  FROM emp e
;
/*
NVL(E.COMM,0)
--------------------------------------
0
300
500
0
1400
0
0
0
0
0
0
0
*/

-- 실습 14)
SELECT nvl2(e.comm, (e.sal+e.comm), 0) as nvl2
  FROM emp e
;
/*
NVL2
--------------------------------------
0
1900
1750
0
2650
0
0
0
1500
0
0
0
*/

-- 실습 15)
SELECT e.empno 사원번호
     , e.ename 이름
     , e.sal 급여
     , decode(e.job, 'CLERK', to_char(300, '$9,999')
                 , 'SALESMAN', to_char(450,'$9,999')
                 , 'MANAGER', to_char(600, '$9,999')
                 , 'ANALYST', to_char(800, '$9,999')
                 , 'PRESIDENT', to_char(1000, '$9,999')
            ) as "자기 계발비"
  FROM emp e
;
/*
사원번호, 이름, 급여, 자기 계발비
--------------------------------------
7369	SMITH	800	   $300
7499	ALLEN	1600	   $450
7521	WARD	1250	   $450
7566	JONES	2975	   $600
7654	MARTIN	1250	   $450
7698	BLAKE	2850	   $600
7782	CLARK	2450	   $600
7839	KING	5000	 $1,000
7844	TURNER	1500	   $450
7900	JAMES	950	   $300
7902	FORD	3000	   $800
7934	MILLER	1300	   $300
*/