--SQL_day03

-- case 결과에 숫자 통화 패턴 씌우기 : $기호, 숫자 세자리 끊어 읽기, 소수점 이하 2자리
SELECT e.empname
     , e.ename
     , e.job
     , to_char(case when e.job ='CLERK' then e.sal * 0.05
                    when e.job ='SALESMAN' then e.sal * 0.04
                    when e.job ='MANAGER' then e.sal * 0.037
                    when e.job ='ANALYST' then e.sal * 0.03
                    when e.job ='PRESIDENT' then e.sal * 0.15
                    ELSE 10
                end, '$9,999.99')
  FROM emp e
;
/* SALGRADE테이블의 내용 : 이 회사의 급여등급 값
ROWSAL, HIGHSAL
------------------------------
1	700	1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/

-- 제공되는 급여 등급을 바탕으로 각 직원들의 급여 등급을 구해보자
-- CASE를 사용하여

SELECT e.empno
     , e.ename
     , e.sal
     , CASE WHEN e.sal >= 700 AND e.sal <=1200 THEN 1
            WHEN e.sal > 1200 AND e.sal <=1400 THEN 2
            WHEN e.sal > 1400 AND e.sal <=2000 THEN 3
            WHEN e.sal > 2000 AND e.sal <=3000 THEN 4
            WHEN e.sal > 3000 AND e.sal <=9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
 ORDER BY "급여 등급" DESC
;

-- WHEN안의 구문을 BETWEEN ~ AND ~로 변경
SELECT e.empno
     , e.ename
     , e.sal
     , CASE WHEN e.sal BETWEEN 700 AND 1199 THEN 1
            WHEN e.sal BETWEEN 1200 AND 1399 THEN 2
            WHEN e.sal BETWEEN 1400 AND 1999 THEN 3
            WHEN e.sal BETWEEN 2000 AND 2999 THEN 4
            WHEN e.sal BETWEEN 3000 AND 9999 THEN 5
            ELSE 0
        END as "급여 등급"
  FROM emp e
 ORDER BY "급여 등급" DESC
;

--  2. 그룹함수 (복수행 함수)
--  1) COUNT(*) : 특정 테이블의 행의 개수(데이터의 개수)를 세어주는 함수
--                NULL을 처리하는 <유일한> 그룹함수

--     COUNT(expr) : expr로 등장한 값을 NULL을 제외하고 세어주는 함수

-- dept, salgrade테이블의 전체 데이터 개수 조회
SELECT COUNT(*) as "부서 개수"
  FROM dept d
;

/*
10	ACCOUNTING	NEW YORK  ---->
20	RESEARCH	DALLAS    ----> COUNT(*) ====> 4
30	SALES	CHICAGO       ---->
40	OPERATIONS	BOSTON    ---->
*/


SELECT *
  FROM salgrade s
;
/*
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/

SELECT COUNT(*) "급여 등급 개수"
  FROM salgrade s
;
/*
1	700	    1200 ---->
2	1201	1400 ---->
3	1401	2000 ---->  COUNT(*) ====> 5
4	2001	3000 ---->
5	3001	9999 ---->
*/

-- emp테이블에서 job컬럼의 데이터 개수를 카운트
 SELECT COUNT(e.JOB)
   FROM emp e
;
/*
7369	SMITH	CLERK     ---->
7499	ALLEN	SALESMAN  ---->
7521	WARD	SALESMAN  ---->
7566	JONES	MANAGER   ---->
7654	MARTIN	SALESMAN  ---->
7698	BLAKE	MANAGER   ---->
7782	CLARK	MANAGER   ---->
7839	KING	PRESIDENT ---->
7844	TURNER	SALESMAN  ---->
7900	JAMES	CLERK     ---->
7902	FORD	ANALYST   ---->
7934	MILLER	CLERK     ---->
9999	J_JUNE	CLERK     ---->
8888	J	    CLERK     ---->
7777	J%JONES	CLERK     ---->
6666	JJ	    (null)    ---->
*/

-- 매니저가 배정된 직원은 몇명인가
SELECT COUNT(e.MGR) as "상사가 있는 직원 수"
  FROM emp e
;

-- 매니저 직을 맡고있는 직원은 몇명인가
-- 1. mgr컬럼을 중복제거하여 조회
-- 2. 그때의 결과를 카운트
SELECT COUNT(DISTINCT e.MGR) as "매니저 수"
  FROM emp e
;

-- 부서가 배정된 직원이 몇명이나 있는가
SELECT COUNT(*) as "전체 인원"
     , COUNT(e.DEPTNO) as "부서가 배정된 인원"
     , (count(*) - COUNT(e.DEPTNO)) as "부서가 없는 인원"
  FROM emp e
;

-- COUNT(*)가 아닌 COUNT(expr)를 사용한 경우에는
SELECT e.DEPTNO
  FROM emp e
 WHERE e.DEPTNO IS NOT NULL; 
 
-- 2) SUM() : NULL항목을 제외하고 
--            합산 가능한 행을 모두 더한 결과를 출력

--    SALESMAN들의 수당 총합을 구해보자
SELECT SUM(e.COMM)
  FROM emp e
 WHERE e.JOB = 'SALESMAN'
 ;
 /*
(null)
300     ---->
500     ---->
(null)
1400    ---->  SUM(e.COMM) ====> 2200 : comm 컬럼이 NULL인 것들은 합산에서 제외
(null)
(null)
(null)
0       ---->
(null)
(null)
(null)
(null)
(null)
(null)
(null)
 */
 
-- 수당 총합 결과에 숫자 출력 패턴, 별칭
SELECT to_char(SUM(e.COMM), '$9,999') as "수당 총합"
  FROM emp e
 WHERE e.JOB = 'SALESMAN'
;

--  3) AVG(expr) : NULL값 제외하고 연산 가능한 항목의 산술 평균을 구함
--  수당 평균을 구해보자
SELECT to_char(AVG(e.COMM), '$9,999') "수당 평균"
  FROM emp e
;

--  4) MAX(expr) : expr의 값 중 최대값을 구함
--                 expr이 문자인 경우 알파벳순 뒷쪽에 위치한 글자를 최대값으로 계산

-- 이름이 가장 나중인 직원
SELECT MAX(e.ENAME)
  FROM emp e
;




-- 만약 GROUP BY절에 등장하지 않은 컬럼이 SELECT절에 등장하면 오류, 실행불가
SELECT e.DEPTNO
     , sum(e.SAL)
  FROM emp e
 GROUP BY e.DEPTNO
;

-- 부서별 급여의 총합, 평균, 최대급여, 최소급여를 구하자
SELECT SUM(e.SAL) "급여 총합"
     , AVG(e.SAL) "급여 평균"
     , MAX(e.SAL) "최대 급여"
     , MIN(e.SAL) "최소 급여"
  FROM emp e
 GROUP BY e.DEPTNO
;
-- 위의 쿼리는 실행은 되지만 어느 부서의 결과인지 정확히 알 수 없다.
/*-----------------------------------------------
 GROUP BY절에 등장하는 그룹화 기준 컬럼은 반드시 SELECT절에 똑같이 등장해야한다.
 
 하지만 위의 쿼리가 실행되는 이유는
 SELECT절에 나열된 컬럼중에서 그룹함수가 사용되지 않은 컬럼이 없기 때문이다.
 즉, 모두 다 그룹함수가 사용된 컬럼들이다.
------------------------------------------*/

SELECT e.DEPTNO "부서 번호"
     , SUM(e.SAL) "급여 총합"
     , AVG(e.SAL) "급여 평균"
     , MAX(e.SAL) "최대 급여"
     , MIN(e.SAL) "최소 급여"
  FROM emp e
 GROUP BY e.DEPTNO
 ORDER BY e.DEPTNO
;


-- 결과 숫자패턴 씌우기
SELECT e.DEPTNO "부서 번호"
     , to_char(SUM(e.SAL), '9,999.00') "급여 총합"
     , to_char(AVG(e.SAL), '9,999.00') "급여 평균"
     , to_char(MAX(e.SAL), '9,999.00') "최대 급여"
     , to_char(MIN(e.SAL), '9,999.00') "최소 급여"
  FROM emp e
 GROUP BY e.DEPTNO
 ORDER BY e.DEPTNO
;

-- 부서별, 직무별 급여의 총합, 평균, 최대, 최소를 구해보자

SELECT e.DEPTNO "부서 번호"
     , JOB "직무"
     , SUM(e.SAL) "급여 총합"
     , AVG(e.SAL) "급여 평균"
     , MAX(e.SAL) "최대 급여"
     , MIN(e.SAL) "최소 급여"
  FROM emp e
 GROUP BY e.DEPTNO, e.JOB
 ORDER BY e.DEPTNO, e.JOB
;

-- 오류코드 ORA-00979: not a GROUP BY expression
SELECT e.DEPTNO "부서 번호"
     , JOB "직무"              -- SELECT절에 등장
     , SUM(e.SAL) "급여 총합"
     , AVG(e.SAL) "급여 평균"
     , MAX(e.SAL) "최대 급여"
     , MIN(e.SAL) "최소 급여"
  FROM emp e
 GROUP BY e.DEPTNO             -- GROUP BY절에 누락
 ORDER BY e.DEPTNO, e.JOB
;
-- 그룹함수가 적용되지 않았고, GROUP BY절에도 등장하지 않은 JOB컬럼이
-- SELECT절에 있기 때문에 오류가 발생

-- 오류코드 ORA-00937: not a single-group group function
SELECT e.DEPTNO "부서 번호"
     , JOB "직무"              -- SELECT절에 등장
     , SUM(e.SAL) "급여 총합"
     , AVG(e.SAL) "급여 평균"
     , MAX(e.SAL) "최대 급여"
     , MIN(e.SAL) "최소 급여"
  FROM emp e
-- GROUP BY e.DEPTNO             -- GROUP BY절 누락
;
-- 그룹함수가 적용되지 않은 컬럼들이 SELECT에 등장하면 그룹화 기준으로 가정되어야 한다.
-- 그룹화 기준으로 사용되는 GROUP BY절 자체가 누락

-- job별 급여의 총합, 평균, 최대, 최소를 구해보자
SELECT nvl(e.JOB, '직무 없음') 직무
     , to_char(SUM(e.SAL), '$9,999') "총합"
     , to_char(AVG(e.SAL), '$9,999') "평균"
     , to_char(MAX(e.SAL), '$9,999') "최대"
     , to_char(MIN(e.SAL), '$9,999') "최소"
  FROM emp e
 GROUP BY e.JOB
;