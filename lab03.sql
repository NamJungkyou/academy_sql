-- 남정규lab03

-- 실습 16)
SELECT e.empno 사원번호
     , e.ename 이름
     , e.sal 급여
     , CASE e.job WHEN 'CLERK' THEN to_char(300, '$9,999')
                  WHEN 'SALESMAN' THEN to_char(450,'$9,999')
                  WHEN 'MANAGER' THEN to_char(600, '$9,999')
                  WHEN 'ANALYST' THEN to_char(800, '$9,999')
                  WHEN 'PRESIDENT' THEN to_char(1000, '$9,999')
       END as "자기 계발비"
  FROM emp e
;
/*
사원번호, 이름, 급여, 자기 계발비
---------------------------------
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
9999	J_JUNE	500	   $300
8888	J	400	   $300
7777	J%JONES	300	   $300
6666	JJ	200	
*/

-- 실습 17)
SELECT e.empno 사원번호
     , e.ename 이름
     , e.sal 급여
     , CASE WHEN e.job = 'CLERK' THEN to_char(300, '$9,999')
            WHEN e.job = 'SALESMAN' THEN to_char(450,'$9,999')
            WHEN e.job = 'MANAGER' THEN to_char(600, '$9,999')
            WHEN e.job = 'ANALYST' THEN to_char(800, '$9,999')
            WHEN e.job = 'PRESIDENT'THEN to_char(1000, '$9,999')
       END as "자기 계발비"
  FROM emp e
;
/*
사원번호, 이름, 급여, 자기 계발비
---------------------------------
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
9999	J_JUNE	500	   $300
8888	J	400	   $300
7777	J%JONES	300	   $300
6666	JJ	200	
*/

-- 실습 18)
SELECT COUNT(*)
  FROM emp e
;
/*
COUNT(*)
-----------------------------
16
*/

-- 실습 19)
SELECT nvl(e.job, '직무없음') as 직무
     , COUNT(e.job) 직책수
  FROM emp e
 GROUP BY e.job
;
/*

-----------------------------------------

*/

-- 실습 20)

/*

-----------------------------------------

*/

-- 실습 21)

/*

-----------------------------------------

*/

-- 실습 22)

/*

-----------------------------------------

*/

-- 실습 23)

/*

-----------------------------------------

*/

-- 실습 24)

/*

-----------------------------------------

*/

-- 실습 25)

/*

-----------------------------------------

*/

-- 실습 26)

/*

-----------------------------------------

*/

-- 실습 27)

/*

-----------------------------------------

*/

-- 실습 28)

/*

-----------------------------------------

*/

