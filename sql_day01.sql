-- sql day01
-- 1. SCOTT 계정 활성화 : sys계정으로 접속, 스크립트 실행
@C :\ oraclexe \ app \ oracle \ product \ 11.2.0 \ server \ rdbms \ admin \ scott.sql
-- 2. 접속유저 확인 명령
 show user
-- 3. HR 계정 활성화 : sys계정으로 접속, 다른 사용자 확장 후 계정잠김, 비밀번호 만료상태 해제, 비밀번호 설정

-- 계정에 존재하는 테이블 목록 조회

SELECT *
  FROM tab
 ;

-----------------------------------------------------------------------------------------------
--SCOTT 계정의 데이터 구조
-- (1) EMP 테이블 내용 조회

SELECT *
  FROM emp
 ;
/*----------------------------------------------------------------------
7369	SMITH	CLERK	    7902    80/12/17	 800	     20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300  30
7521	WARD	SALESMAN	7698	81/02/22	1250	500  30
7566	JONES	MANAGER 	7839	81/04/02	2975		 20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400 30
7698	BLAKE	MANAGER 	7839	81/05/01	2850		 30
7782	CLARK	MANAGER 	7839	81/06/09	2450		 10
7839	KING	PRESIDENT	    	81/11/17	5000		 10
7844	TURNER	SALESMAN	7698	81/09/08	1500   	0	 30
7900	JAMES	CLERK   	7698	81/12/03	 950		 30
7902	FORD	ANALYST 	7566	81/12/03	3000		 20
7934	MILLER	CLERK   	7782	82/01/23	1300		 10
--------------------------------------------------------------------------*/
-- (2) DEPT 테이블 내용 조회

SELECT *
  FROM dept
;
/*------------------------------------
DEPTNO DNAME        LOC
10	   ACCOUNTING	NEW YORK
20	   RESEARCH	    DALLAS
30	   SALES    	CHICAGO
40	   OPERATIONS	BOSTON
--------------------------------------*/

-- (3) SALGRADE 테이블 내용 조회

SELECT *
  FROM salgrade
 ;
/*----------------------------------
GRADE LOSAL HISAL
  1	  700  	1200
  2	  1201	1400
  3	  1401	2000
  4	  2001	3000
  5	  3001	9999
------------------------------------*/
  
  -- 01. DQL
  -- (1) SELECT 구문
  -- 1) emp 테이블에서 사번, 이름, 직무를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
  FROM emp e --소문자 e는 alias(별칭)
;

-- 2) emp테이블에서 직무만 조회
SELECT e.job
  FROM emp e
;
/*
CLERK
SALESMAN
SALESMAN
MANAGER
SALESMAN
MANAGER
MANAGER
PRESIDENT
SALESMAN
CLERK
ANALYST
CLERK
*/

-- (2) DISTINCT문 : SELECT문 사용시 중복을 배제하여 조회
-- 3) emp테이블에서 job컬럼의 중복을 배제하여 조회
SELECT DISTINCT e.JOB
  FROM emp e
  ;
  /*
CLERK
SALESMAN
PRESIDENT
MANAGER
ANALYST
  */
-- SQL SELECT문의 작동 원리 : 테이블의 한 행을 기본 단위로 실행
                           -- 테이블 행의 개수만큼 반복 실행.
SELECT 'Hello, SQL!'
  FROM emp e
;

--4) emp테이블에서 job, deptno에 대해 죽복을 제거하여 조회
SELECT DISTINCT 
       e.job
       e.DEPTNO
  FROM emp e
;
  
-- (3) ORDER by절 " 정렬
--5) emp 테이블에서 job을 중복을 배제하여 조회하고 결과는 오름차순으로 정렬
SELECT DISTINCT
       e.JOB
  FROM emp e 
 ORDER BY e.Job ASC
 ;
 /*
 ANALYST
CLERK
MANAGER
PRESIDENT
SALESMAN
 */
 
 --6) emp 테이블에서 job을 중복을 배제하여 조회하고 결과는 내림차순으로 정렬
 SELECT DISTINCT
        e.job
   FROM emp e
  ORDER BY e.job DESC
 ;
 /*
 SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
 */
 
 -- 7) emp 테이블에서 comm을 가장 많이 받는 순서대로 출력
 --    사번, 이름, 직무, 입사일, 커미션 순으로 조회
 SELECT e.empno
      , e.ename
      , e.job
      , e.hiredate
      , e.comm 
   FROM emp e 
  ORDER BY e.comm DESC
   ;
 
 -- 8) emp테이블에서 커미션이 작은 순서대로, 직무별 오름차순, 이름별 오름차순으로 정렬
 --    사번, 이름, 직무, 입사일, 커미션을 조회
 SELECT e.empno
      , e.ename
      , e.job
      , e.hiredate
      , e.COMM
   FROM emp e
  ORDER BY e.comm, e.job, e.ename 
   ;
   
-- 9) emp테이블에서 comm이 적은 순으로, 직무별 오름차순, 이름별 내림차순으로 정렬
--    사번, 이름, 직무, 입사일 커미션을 조회
 SELECT e.empno
      , e.ename
      , e.job
      , e.hiredate
      , e.COMM
   FROM emp e
  ORDER BY e.comm, e.job, e.ename DESC
   ;

-- (4) Alias : 별칭
-- 10) emp 테이블에서 
--     empno --> Employee No.
--     ename --> Employee Name
--     job   --> Job Name
SELECT e.EMPNO as "Employee No."
     , e.ENAME as "Employee Name"
     , e.JOB as "Job Name"
  FROM emp e
;

-- 11) 10번과 동일 as 키워드 생략하여 조회
--     empno --> 사번
--     ename --> 사원 이름
--     job   --> 직무
SELECT e.EMPNO 사번
     , e.ename "직원 번호" 
     , e.job "직무"
  FROM emp e
  ;
  
-- 12) 테이블에 붙이는 별칭을 주지 않았을 때
SELECT empno
  FROM emp
;
SELECT emp.empno
  FROM emp
;

SELECT e.empno -- FROM절에서 설정된 테이블 별칭은 SELECT 절에서 사용됨.
  FROM emp e   -- 소문자 e 가 emp 테이블의 별칭이며 테이블 별칭은 FROM절에 사용함
;

SELECT d.DEPTNO
  FROM dept d
;

-- 13) 영문별칭 사용시 특수기호 _ 사용하는 경우
SELECT e.EMPNO Employee_No
     , e.ENAME "Employee Name"
  FROM emp e
;

-- 14) 별칭과 정렬의 조합 : SELECT절에 별칭을 준 경우 ORDER BY 절에서 사용가능
--     emp 테이블에서 사번, 이름, 직무, 입사일, 커미션을 조회할 때
--     각 컬럼에 대해서 한글별칭을 주어 조회
--     정렬은 커미션, 직무, 이름을 오름차순 정렬
SELECT e.EMPNO 사번
      ,e.ENAME 이름
      ,e.JOB 직무
      ,e.hiredate 입사일
      ,e.COMM 커미션
  FROM emp e
 ORDER BY 커미션, 직무, 이름
;

-- 15) DISTINCT, 별칭, 정렬의 조합
--     job의 중복을 제거하여 직무라는 별칭으로 조회하고 
--     내림차순으로 정렬
SELECT DISTINCT e.JOB 직무
  FROM emp e
 ORDER BY 직무 DESC
 ;
 /*
직무
------------
SALESMAN
PRESIDENT
MANAGER
CLERK
ANALYST
 */
 
 -- (5) WHERE 조건절
 -- 16) emp테이블에서 empno가 7900인 사원의 
 --     사번, 이름, 직무, 입사일, 급여, 부서번호를 조회
 SELECT e.EMPNO
      , e.ENAME
      , e.JOB
      , e.HIREDATE
      , e.SAL
      , e.DEPTNO
   FROM emp e
  WHERE e.empno = 7900
;
/*
EMPNO, ENAME, JOB, HIREDATE, SAL, DEPTNO
------------------------------------------
7900	JAMES	CLERK	81/12/03	950	30
*/

-- 17) emp테이블에서 empno가 7900이거나 DEPTNO가 20인 직원의
--     사번, 이름, 직무, 입사일, 급여, 부서번호를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.HIREDATE
     , e.SAL
     , e.DEPTNO
  FROM emp e
 WHERE e.empno = 7900 
    OR e.deptno = 20
;
/*
EMPNO, ENAME, JOB, HIREDATE, SAL, DEPTNO
------------------------------------------------
7369	SMITH	CLERK	80/12/17	800	20
7566	JONES	MANAGER	81/04/02	2975	20
7900	JAMES	CLERK	81/12/03	950	30
7902	FORD	ANALYST	81/12/03	3000	20
*/

-- 18) 17번의 조회조건을 AND조건으로 조합
--     empno가 7900이고 deptno가 20인 직원의
--     사번, 이름, 직무, 입사일, 급여, 부서번호를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.HIREDATE
     , e.SAL
     , e.DEPTNO
  FROM emp e
 WHERE e.empno = 7900 
   AND e.deptno = 20
;
-- 인출된 모든 행 : 0

-- 19) job이 'CLERK'이면서 deptno가 10인 직원의
--      사번, 이름, 직무, 부서번호를 조회
SELECT e.empno
     , e.ename
     , e.job
     , e.deptno
  FROM emp e
 WHERE e.job = 'CLERK' -- 문자값 비교시 ''사용, 문자값은 대소문자 구분
   AND e.deptno = 10   -- 숫자값 비교시 따옴표 사용안함
;

-- 20) 19번에서 직무 비교값을 솜누자 clerk과 비교하여 결과를 확인
SELECT e.empno
     , e.ename
     , e.job
     , e.deptno
  FROM emp e
 WHERE e.job = 'clerk' -- 문자값 비교시 ''사용, 문자값은 대소문자 구분
   AND e.deptno = 10   -- 숫자값 비교시 따옴표 사용안함
;
-- 소문자 clerk으로 저장된 직무는 없으므로
-- 인출된 모든 행 : 0

-- (6) 연산자 1. 산술연산자
-- 21) 사번, 이름, 급여를 조회하고, 급여의 3.3%에 해당하는 원천징수 세금을 계산하여 조회
SELECT e.EMPNO 사번
     , e.ENAME 이름
     , e.SAL 급여
     , e.SAL * 0.033 원천징수세금
  FROM emp e
;

-- 실수령액에 해당하는 96.7%의 급여도 계산
SELECT e.EMPNO 사번
     , e.ENAME 이름
     , e.SAL 급여
     , e.SAL * 0.033 원천징수세금
     , e.SAL * 0.967 실수령액
  FROM emp e
;

-- 동일결과를 내는 다른 계산
SELECT e.EMPNO 사번
     , e.ENAME 이름
     , e.SAL 급여
     , e.SAL * 0.033 원천징수세금
     , e.SAL - (e.SAL * 0.033) 실수령액
  FROM emp e
;

-- (6) 연산자 2. 비교연산자
--     비교연산자는 SELECT절에 사용할 수 없음
--     WHERE, HAVING절에만 사용함

-- 22) 급여가 2000이 넘는 사원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE e.SAL >2000
;

-- 급여가 1000이상인 직원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE e.SAL >= 1000
;

-- 급여가 1000이상이고 2000미만인 직원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
  FROM emp e
 WHERE e.SAL >= 1000
   AND e.SAL <2000
;

-- comm값이 0보다 큰 작원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
     , e.COMM
  FROM emp e
 WHERE e.COMM > 0 
;
/*
 위의 실행 결과에서 comm이 (null)인 사람들의 행은
 처음부터 비교대상에 들어가지 않음을 주의해야 한다.
 (null)값은 비교연산자로 비교할 수 없는 값이다.
*/

-- 23) 영업사원(SALESMAN)직무를 가진 사람들은 급여와 수당을 함께 받으므로 영업사원의 실제 수령금을 계산해보자
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL + e.COMM "금여 + 수당"
  FROM emp e
;

/*
EMPNO, ENAME, JOB, 급여 + 수당
-------------------------------------
7369	SMITH	CLERK	
7499	ALLEN	SALESMAN	1900
7521	WARD	SALESMAN	1750
7566	JONES	MANAGER	
7654	MARTIN	SALESMAN	2650
7698	BLAKE	MANAGER	
7782	CLARK	MANAGER	
7839	KING	PRESIDENT	
7844	TURNER	SALESMAN	1500
7900	JAMES	CLERK	
7902	FORD	ANALYST	
7934	MILLER	CLERK	

==> 숫자값과 (null)값의 산술연산 결과는 (null)이다. 
*/

-- (6) 연산자 : 3. 논리연산자
-- NOT 연산자
-- 24) 급여가 2000보다 적지 않은 직원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE NOT e.SAL < 2000
;
-- 같은 결과가 나오는 다른 쿼리
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE e.SAL >= 2000
;

-- (6) 연산자 : 4. SQL 연산자
-- IN 연산자 : 비교하고자 하는 기준 값이 제시된 항목 목록에 존재하면 참으로 판단.

-- 25) 급여가 800, 3000, 5000 중 하나인 직원의 사번, 이름, 급여를 조회
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE e.SAL = 800
    OR e.SAL = 3000
    OR e.SAL = 5000
;
-- IN 연산자를 사용하여 해결
SELECT e.EMPNO
     , e.ENAME
     , e.SAL
  FROM emp e
 WHERE e.SAL IN(800, 3000, 5000)
;

-- LIKE 연산자 : 유사값을 검색하는데 사용
/* LIKE 연산자는 유사값 검색을 위해 함께 사용하는 패턴인식문자가 있다.
   % : 0자리 이상의 모든 문자패턴이 올 수 있다.
   _ : 1자리의 모든 문자패턴이 올 수 있다.
*/

-- 26) 이름이 J로 시작하는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'J%'
;

-- 이름이 M으로 시작하는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'M%'
;

-- 이름에 M이 들어가는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE '%M%'
;

-- 이름의 두번째 자리에 M이 들어가는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE '_M%' -- 유사패턴인식문자 _로 사용하여 한글자로 제한
;

-- 이름의 세번째 자리에 M이 들어가는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE '__M%' -- 유사패턴인식문자 _를 두번 사용하여 앞자리를 두글자로 제한
;

-- 이름의 둘째자리부터 LA가 들어가는 이름을 가진 직원의 사번, 이름 조회
-- 이름의 두번째 자리에 M이 들어가는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE '_LA%'
;

-- 이름이 J_로 시작하는 직원의 사번, 이름 조회
-- : 조회 값에 패턴인식문자가 들어있는 데이터는 어떻게 조회할것인가?
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'J\_%' ESCAPE '\'
;
-- 조회하려는 값에 있는 패턴인식문자를 무효화 하려면 ESCAPE절과 조합한다.

-- 이름이 J%로 시작하는 직원의 사번, 이름 조회
SELECT e.EMPNO
     , e.ENAME
  FROM emp e
 WHERE e.ENAME LIKE 'J\%%' ESCAPE '\'
;