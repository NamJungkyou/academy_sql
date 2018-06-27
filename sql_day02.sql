-- SQL day02
----------------------------------------------------------------------------------------------------------------------------
-- 28)

-- (6) 연산자 : 6. 집합연산자
-- 첫번째 쿼리
SELECT *
  FROM dept d
;

-- 두번째 쿼리 : 부서번호가 10번인 부서정보만 조회
SELECT * 
  FROM dept d
 WHERE d.deptno = 10
;

-- 1) UNION ALL : 두 집합의 중복데이터를 허용하는 합집합
SELECT * 
  FROM dept d
  UNION ALL
SELECT *
  FROM dept d
 WHERE d.DEPTNO =10
;

-- 2) UNION : 두 집합의 중복데이터가 없는 합집합
SELECT * 
  FROM dept d
  UNION
SELECT *
  FROM dept d
 WHERE d.DEPTNO =10
;

-- 3) INTERSECT : 교집합
SELECT * 
  FROM dept d
  INTERSECT
SELECT *
  FROM dept d
 WHERE d.DEPTNO =10
;

-- 4) MINUS : 첫번째 쿼리 실행 결과에서 두번째 쿼리 실행결과를 뺀 차집합
SELECT * 
  FROM dept d
  MINUS
SELECT *
  FROM dept d
 WHERE d.DEPTNO =10
;

-- 주의! : 각 쿼리 조회 결과의 컬럼 수, 데이터 타입이 서로 일치해야 한다.
SELECT *  -- 첫번째 쿼리의 컬럼 수는 3
  FROM dept d
  UNION ALL
SELECT d.DEPTNO -- 두번째 쿼리의 컬럼 수는 2
     , d.DNAME 
  FROM dept d
 WHERE d.DEPTNO =10
;
/*
ORA-01789: query block has incorrect number of result columns
*/

SELECT d.DNAME -- 문자형
     , d.DEPTNO -- 숫자형
  FROM dept d
  UNION ALL
SELECT d.DEPTNO --숫자형
     , d.DNAME -- 문자형
  FROM dept d
 WHERE d.DEPTNO =10
;
/*
ORA-01790: expression must have same datatype as corresponding expression
*/

-- 서로 다른 테이블에서 조회한 결과를 집합연산 가능
-- 첫번째 쿼리 : emp테이블에서 조회
SELECT e.empno -- 숫자형
     , e.ename -- 문자형
     , e.job -- 문자형
  FROM emp e
;

-- 두번째 쿼리 : dept테이블에서 조회
SELECT d.deptno -- 숫자형
     , d.DNAME -- 문자형
     , d.loc -- 문자형
  FROM dept d
;

-- 서로 다른 테이블의 조회 결과를 UNION
SELECT e.empno -- 숫자형
     , e.ename -- 문자형
     , e.job -- 문자형
  FROM emp e
  UNION
SELECT d.deptno -- 숫자형
     , d.DNAME -- 문자형
     , d.loc -- 문자형
  FROM dept d
;
/*
EMPNO, ENAME, JOB
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7777	J%JONES	CLERK
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
8888	J	CLERK
9999	J_JUNE	CLERK
*/

-- 서로 다른 테이블의 조회 결과를 MINUS
SELECT e.empno -- 숫자형
     , e.ename -- 문자형
     , e.job -- 문자형
  FROM emp e
  MINUS
SELECT d.deptno -- 숫자형
     , d.DNAME -- 문자형
     , d.loc -- 문자형
  FROM dept d
;
/*
EMPNO, ENAME, JOB
7369	SMITH	CLERK
7499	ALLEN	SALESMAN
7521	WARD	SALESMAN
7566	JONES	MANAGER
7654	MARTIN	SALESMAN
7698	BLAKE	MANAGER
7777	J%JONES	CLERK
7782	CLARK	MANAGER
7839	KING	PRESIDENT
7844	TURNER	SALESMAN
7900	JAMES	CLERK
7902	FORD	ANALYST
7934	MILLER	CLERK
8888	J	CLERK
9999	J_JUNE	CLERK
*/

-- 서로 다른 테이블의 조회 결과를 INTERSECT
SELECT e.empno -- 숫자형
     , e.ename -- 문자형
     , e.job -- 문자형
  FROM emp e
  INTERSECT
SELECT d.deptno -- 숫자형
     , d.DNAME -- 문자형
     , d.loc -- 문자형
  FROM dept d
;
-- 조회결과 없음 :
-- 인출된 모든 행 : 0
-- no rows selected


-- 3) 직무가 CLERK이거나
--    급여가  1300이 넘으면서 매니저가 7698인 직원의 정보 조회
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
     , e.SAL
     , e.MGR
  FROM emp e
 WHERE e.JOB= 'CLERK'
    OR (e.MGR = 7698 AND e.SAL >1300)
;
-- AND연산자의 우선순위는 자동으로 OR보다 높기 때문에
-- 두번째처럼 괄호를 사용하지 않아도 수행결과는 같아짐
/*
EMPNO, ENAME, JOB, SAL, MGR
9999	J_JUNE	CLERK	500	
8888	J	CLERK	400	
7777	J%JONES	CLERK	300	
7369	SMITH	CLERK	800	7902
7499	ALLEN	SALESMAN	1600	7698
7844	TURNER	SALESMAN	1500	7698
7900	JAMES	CLERK	950	7698
7934	MILLER	CLERK	1300	7782
*/

------------------ 6. 함수
-- (2) dual 테이블 : 1행 1열로 구성된 시스템 테이블
DESC dual; --> 문자데이터 1칸으로 구성된 dummy라는 컬럼을 가진 테이블
DESC emp;

SELECT * -- dummy컬럼에 X값이 하나 들어있음을 확인
  FROM dual
;

-- dual테이블을 사용하여 날짜 조회
SELECT sysdate
  FROM dual
;

-- (3) 단일행 함수
--  1) 숫자합수 : 1. MOD(m, n) : m을 n으로 나눈 나머지를 계산
SELECT mod(10, 3) as result
  FROM dual
;

SELECT mod(10, 3) as result
  FROM emp
;

SELECT mod(10, 3) as result
  FROM dept
;

-- 각 사원의 급여를 3으로 나눈 나머지를 조회
SELECT e.empno
     , e.ename
     , mod(e.sal, 3) as result
  FROM emp e
;
/*
9999	J_JUNE	2
8888	J	1
7777	J%JONES	0
7369	SMITH	2
7499	ALLEN	1
7521	WARD	2
7566	JONES	2
7654	MARTIN	2
7698	BLAKE	0
7782	CLARK	2
7839	KING	2
7844	TURNER	0
7900	JAMES	2
7902	FORD	0
7934	MILLER	1
*/
-- 단일행 함수는 테이블 1행당 1번씩 적용

--  2. ROUND(m, n) : 실수 m을 소수점 n+1자리에서 반올림한 결과를 계산
SELECT round(1234.56, 1)
  FROM dual
; -- 1234.6
SELECT round(1234.56, 0)
  FROM dual
; -- 1235
SELECT round(1234.46, 0)
  FROM dual
; -- 1234

--  ROUND(m) : n값을 생략하면 소수점 이하 첫째자리 반올림 바로 수행
--              즉, n값을 0으로 수행함
SELECT round(1234.46)
  FROM dual
; -- 1234
SELECT round(1234.56)
  FROM dual
; -- 1235

--  3. TRUNC(m, n) : 실수 m을 m에서 지정한 자리 이하 소수점 버림
SELECT trunc(1234.56, 1)
  FROM dual
; -- 1234.5
SELECT trunc(1234.56, 0)
  FROM dual
; -- 1234
--    TRUNC(m) : n을 생략하면 0으로 수행
SELECT trunc(1234.56)
  FROM dual
; -- 1234

--  4. CEIL(n) : 입력된 실수 n에서 같거나 가장 큰 가까운 정수
SELECT ceil(1234.56)
  FROM dual
; -- 1235
SELECT ceil(1234)
  FROM dual
; -- 1234
SELECT ceil(1234.001)
  FROM dual
; -- 1235

--  5. FLOOR(n) : 입력된 실수 n에서 같거나 가장 가까운 작은 정수
SELECT floor(1234.56)
  FROM dual
; -- 1234
SELECT floor(1234)
  FROM dual
; -- 1234
SELECT floor(1235.56)
  FROM dual
; -- 1235

--  6.WIDTH_BUCKET(expr, min, max, buckets)
--  min, max값 사이를 buckets 개수만큼의 구간으로 나누고
--  expr이 출력하는 값이 어느 구간인지 위치를 숫자로 구해줌

-- 급여 범위를 0 ~ 5000으로 잡고, 5개의 구간으로 나누어서
-- 각 직원의 급여가 어느 구간에 해당하는지 보고서를 출력해 보자.
SELECT e.empno
     , e.ename
     , e.sal
     , width_bucket(e.sal, 0, 5000, 5) as "급여 구간"
  FROM emp e
  ORDER BY "급여 구간" DESC
;

--  2) 문자함수
--  1. INITCAP(str) : str의 첫글자를 대문자로 변경(영문일 때)
SELECT initcap('the soap') FROM dual; -- The Soap
SELECT initcap('안녕하세요, 하하') FROM dual; -- 안녕하세요, 하하

--  2. LOWER(str) : str을 소문자로 변경(영문일 때)
SELECT lower('MR. SCOTT MCMILLAN') "소문자로 변경" FROM dual;

--  3. UPPER(str) : str을 대문자로 변경(영문일 때)
SELECT upper('sql is cooooooooooooooooool~!!') "씐나" FROM dual;

--  4. LENGTH(str), LENGTHB(str) : str의 글자길이를 계산
SELECT length('hello, sql') as "글자 길이" FROM dual;
SELECT length('hello, sql의 글자 길이는') FROM dual;

-- oracle에서 한글은 3byte로 계산
SELECT lengthb('hello, sql') as "글자 byte" FROM dual;
SELECT lengthb('오라클') as "글자 byte" FROM dual;

--  5. CONCAT(str1, str2) : str1, str2 문자열을 접함, ||연산자와 동일
SELECT concat('안녕하세요, ', 'SQL') FROM dual;
SELECT '안녕하세요, ' || 'SQL' FROM dual;

--  6. SUBSTR(str, i, n) : str에서 i번째 위치에서 n개의 글자를 추출
--     SQL에서 문자열 인덱스를 나타내는 i는 1부터 시작(주의할 것)
SELECT substr('sql is cooooooooooooooooool~!!', 3, 4) FROM dual;
--     SUBSTR(str, i) : i번째 위치에서부터 문자열 끝까지 추출
SELECT substr('sql is cooooooooooooooooool~!!', 3) FROM dual;

--  7. INSTR(str1, str2) : 2번째 문자열이 1번째 문자열 어디에 위치하는지 계산
SELECT instr('sql is cooooooooooooooooool~!!', 'is') FROM dual;
SELECT instr('sql is cooooooooooooooooool~!!', 'ia') FROM dual;
--     2번째 문자열이 없으면 0으로 계산

--  8. LPAD, RPAD(str, n, c) : 입력된 str의 전체 자리수를 n으로 잡고 
--                             남는 공간의 왼쪽/오른쪽에 문자 c를 채워넣는다.
SELECT lpad('sql is cooool~!!', 20, '!') FROM dual;
SELECT rpad('sql is cooool~!!', 25, '!') FROM dual; 

--  9. LTRIM, RTRIM, TRIM : 입력된 문자열의 왼쪽, 오른쪽, 양쪽 공백 제거
SELECT '>' || ltrim('      sql is cool     ') || '<' FROM dual;
SELECT '>' || rtrim('      sql is cool     ') || '<' FROM dual;
SELECT '>' || trim('      sql is cool     ') || '<' FROM dual;

-- 10. NVL(expr1, expr2), NVL2(expr1, expr2, pxpr3), NULLIF(str1, str2)
--     NVL(expr1, expr2) : expr1의 값이 NULL이면 expr2의 값 출력
SELECT e.EMPNO
     , e.ENAME
     , nvl(e.MGR, '매니저 없음') -- mgr값이 숫자, 출력값이 문자
  FROM emp e                     -- 타입이 달라서 실행이 안됨
;
---------------------
SELECT e.EMPNO
     , e.ENAME
     , nvl(e.MGR, 0) 
  FROM emp e                     
;
---------------------
SELECT e.EMPNO
     , e.ENAME
     , nvl(e.MGR || '', '매니저 없음') -- 숫자에 문자열을 덧붙이면 문자로 형변환
  FROM emp e   
;

--     NVL2(expr1, expr2, pxpr3) : expr1의 값이 NOT NULL 이면 expr2의 값 출력, NULL이면 expr3의 값 출력
SELECT e.EMPNO
     , e.ENAME
     , nvl2(e.MGR, '매니저 있음', '매니저 없음') 
  FROM emp e                     
;

--     NULLIF(expr1, expr2) : expr1, expr2의 값이 같으면 NULL출력, 다르면 expr1의 값 출력
SELECT nullif('AAA', 'BBB')
  FROM dual
;
SELECT nullif('AAA', 'AAA')
  FROM dual
;
-- 조회된 결과 1행이 NULL인 결과를 얻게 됨
-- 1행이라도 NULL이 조회된 결과는 인출된 모든 행 : 0과는 상태가 다르다.