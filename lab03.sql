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

-- 실습 19) emp테이블의 직책의 개수 조회(중복 제거)
SELECT COUNT(DISTINCT e.job) 직책수
  FROM emp e
;
/*
직책수
-----------------------------------------
5
*/

-- 실습 20) emp테이블에서 커미션을 받는 사원의 숫자 조회
SELECT COUNT(e.comm) "커미션 받는 사원"
  FROM emp e
;
/*
커미션 받는 사원
-----------------------------------------
4
*/

-- 실습 21) emp테이블에서 전 직원의 급여의 총합
SELECT SUM(e.sal) 급여총합
  FROM emp e
;
/*
급여총합
-----------------------------------------
26325
*/

-- 실습 22) emp테이블에서 전 직원의 급여 평균
SELECT AVG(e.sal) 급여평균
  FROM emp e
;
/*
급여평균
-----------------------------------------
1645.3125
*/

-- 실습 23) 20번 부서 급여의 총합, 평균, 최대, 최소 조회
SELECT SUM(e.sal) 급여총합
     , AVG(e.sal) 급여평균
     , MAX(e.sal) 최대급여
     , MIN(e.sal) 최소급여
  FROM emp e
 WHERE e.deptno = 20
;
/*
급여총합, 급여평균, 최대급여, 최소급여
-----------------------------------------
6775	2258.333333333333333333333333333333333333	3000	800
*/

-- 실습 24) 급여 표준편차와 분산 조회
SELECT STDDEV(e.sal) "급여 표준편차"
     , VARIANCE(e.sal) "급여 분산"
  FROM emp e
;
/*
급여 표준편차, 급여 분산
-----------------------------------------
1300.519727839604899855188283560407405253	1691351.5625
*/

-- 실습 25) 직책이 SALESMAN인 직원들의 표준편차와 분산 조회
SELECT STDDEV(e.sal) "급여 표준편차"
     , VARIANCE(e.sal) "급여 분산"
  FROM emp e
 WHERE e.job = 'SALESMAN'
;
/*
급여 표준편차, 급여 분산
-----------------------------------------
177.951304200521853513525399426595177105	31666.6666666666666666666666666666666667
*/

-- 실습 26) emp테이블에서 부서별, 자기계발비 총합을 구하여 조회(DECODE 함께 사용)
-- CLERK : 300, SALESMAN : 450, MANAGER : 600, ANALYST : 800, PRESIDENT : 1000 
SELECT e.deptno
     , SUM(DECODE(e.job, 'CLERK', 300
                       , 'SALESMAN', 450
                       , 'MANAGER', 600
                       , 'ANALYST', 800
                       , 'PRESIDENT', 1000)) "자기계발비 총합"
  FROM emp e
 GROUP BY e.deptno
 ORDER BY e.deptno
 ;

/*
DEPTNO, 자기계발비 총합
-----------------------------------------
10	1900
20	1700
30	2700
*/

-- 실습 27) emp테이블에서 부서별, 직책별 자기계발비 총합을 구하여 조회(DECODE 함께 사용)하고 부서별 오름차순, 직책별 내림차순 정렬
SELECT e.deptno
     , e.job
     , SUM(DECODE(e.job, 'CLERK', 300
                       , 'SALESMAN', 450
                       , 'MANAGER', 600
                       , 'ANALYST', 800
                       , 'PRESIDENT', 1000)) "자기계발비 총합"
  FROM emp e
 GROUP BY e.deptno, e.job
 ORDER BY e.deptno ASC, e.job DESC
 ;
/*
DEPTNO, JOB, 자기계발비 총합
-----------------------------------------
10	PRESIDENT	1000
10	MANAGER	600
10	CLERK	300
20	MANAGER	600
20	CLERK	300
20	ANALYST	800
30	SALESMAN	1800
30	MANAGER	600
30	CLERK	300
*/

---------------------------조인과 서브쿼리----------------------------------
-- 실습 1) NATURAL JOIN을 사용하혀 WHERE절 없이 emp, dept 테이블을 조인 
SELECT e.empno
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.COMM
     , e.HIREDATE
     , d.DNAME
     , d.LOC
     , deptno
  FROM emp e NATURAL JOIN dept d
;
/*
EMPNO, ENAME, JOB, MGR, SAL, COMM, HIREDATE, DNAME, LOC, DEPTNO
-----------------------------------------
7839	KING	PRESIDENT		5000		81/11/17	ACCOUNTING	NEW YORK	10
7782	CLARK	MANAGER	7839	2450		81/06/09	ACCOUNTING	NEW YORK	10
7934	MILLER	CLERK	7782	1300		82/01/23	ACCOUNTING	NEW YORK	10
7902	FORD	ANALYST	7566	3000		81/12/03	RESEARCH	DALLAS	20
7369	SMITH	CLERK	7902	800		80/12/17	RESEARCH	DALLAS	20
7566	JONES	MANAGER	7839	2975		81/04/02	RESEARCH	DALLAS	20
7900	JAMES	CLERK	7698	950		81/12/03	SALES	CHICAGO	30
7844	TURNER	SALESMAN	7698	1500	0	81/09/08	SALES	CHICAGO	30
7654	MARTIN	SALESMAN	7698	1250	1400	81/09/28	SALES	CHICAGO	30
7521	WARD	SALESMAN	7698	1250	500	81/02/22	SALES	CHICAGO	30
7499	ALLEN	SALESMAN	7698	1600	300	81/02/20	SALES	CHICAGO	30
7698	BLAKE	MANAGER	7839	2850		81/05/01	SALES	CHICAGO	30
*/

-- 실습 2) JOIN ~ USING을 사용하혀 WHERE절 없이 emp, dept 테이블을 조인 
SELECT e.empno
     , e.ENAME
     , e.JOB
     , e.MGR
     , e.SAL
     , e.COMM
     , e.HIREDATE
     , d.DNAME
     , d.LOC
     , deptno
  FROM emp e JOIN dept d USING (deptno)
;
/*
EMPNO, ENAME, JOB, MGR, SAL, COMM, HIREDATE, DNAME, LOC, DEPTNO
-----------------------------------------
7839	KING	PRESIDENT		5000		81/11/17	ACCOUNTING	NEW YORK	10
7782	CLARK	MANAGER	7839	2450		81/06/09	ACCOUNTING	NEW YORK	10
7934	MILLER	CLERK	7782	1300		82/01/23	ACCOUNTING	NEW YORK	10
7902	FORD	ANALYST	7566	3000		81/12/03	RESEARCH	DALLAS	20
7369	SMITH	CLERK	7902	800		80/12/17	RESEARCH	DALLAS	20
7566	JONES	MANAGER	7839	2975		81/04/02	RESEARCH	DALLAS	20
7900	JAMES	CLERK	7698	950		81/12/03	SALES	CHICAGO	30
7844	TURNER	SALESMAN	7698	1500	0	81/09/08	SALES	CHICAGO	30
7654	MARTIN	SALESMAN	7698	1250	1400	81/09/28	SALES	CHICAGO	30
7521	WARD	SALESMAN	7698	1250	500	81/02/22	SALES	CHICAGO	30
7499	ALLEN	SALESMAN	7698	1600	300	81/02/20	SALES	CHICAGO	30
7698	BLAKE	MANAGER	7839	2850		81/05/01	SALES	CHICAGO	30
*/
