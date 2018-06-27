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