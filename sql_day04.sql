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

-- 3. LEFT OUTER JOIN ~ ON 으로
SELECT e.empno
     , e.ename
     , e.deptno
     , d.dname
 FROM emp e LEFT OUTER JOIN dept d
     ON e.deptno=d.deptno
;

-- 문제) 아직 아무도 배치되지않은 부서가 있어도 부서를 모두 조회하고 싶다면
-- 1. (+)연산자로 해결
SELECT e.empno
     , e.ename
     , e.deptno
     , '|'
     , d.deptno
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno(+) = d.deptno
;

-- 2. RIGHT OUTER JOIN ~ ON 으로 해결
SELECT e.empno
     , e.ename
     , e.deptno
     , '|'
     , d.deptno
     , d.dname
  FROM emp e RIGHT OUTER JOIN dept d
    ON e.deptno = d.deptno
;

-- 문제) 부서배치가 안된 직원도 보고싶고
--       직원이 아직 아무도 없는 부서도 모두 보고싶을 떄
--       즉, 양쪽 모두에 존재하는 NULL값들을 모두 한번에 조회하려면 어떻게 해야하는가?
-- 1. (+)연산자로는 양쪽 OUTER JOIN 불가
SELECT e.empno
     , d.dname
  FROM emp e
     , dept d
 WHERE e.deptno(+) = d.deptno(+)
; ----> ORA-01468: a predicate may reference only one outer-joined table

--2. FULL OUTER JOIN ~ ON구문 지원
SELECT e.empno
     , e.ename
     , d.dname
  FROM emp e FULL OUTER JOIN dept d
    ON e.deptno = d.deptno
;

--  6) SELF JOIN : 한테이블 내에서 자기자신의 컬럼끼리 연결하여 새 행을 만드는 기법
-- 문제) emp 테이블에서 mgr에 해당하는 상사의 이름을 같이 조회하려면
SELECT e1.empno 직원번호
     , e1.ename 직원이름
     , e1.mgr   상사번호
     , e2.ename 상사이름
  FROM emp e1
     , emp e2
 WHERE e1.mgr=e2.empno
;

-- 상사가 없는 테이블도 조회
--  a) e1 테이블이 기준 : LEFT OUTRER JOIN
--  b)
SELECT e1.empno 직원번호
     , e1.ename 직원이름
     , e1.mgr   상사번호
     , e2.ename 상사이름
  FROM emp e1 LEFT OUTER JOIN emp e2
    ON e1.mgr=e2.empno
;
-- 부하직원이 없는 테이블 조회
--  a) 
SELECT e1.empno 직원번호
     , e1.ename 직원이름
     , e1.mgr   상사번호
     , e2.ename 상사이름
  FROM emp e1 RIGHT OUTER JOIN emp e2
    ON e1.mgr=e2.empno
;

--   7. 조인과 서브쿼리
-- (2) 서브쿼리 : SEUB-QUERY
--                SELECT, FROM ,WHERE절에 사용 가능

-- 문제 BLAKE와 직무가 동일한 직원의 정보를 조회
-- 1. BLSCK의 직무를 조회
SELECT e.JOB
  FROM emp e 
 WHERE e.ename='BLACK'
;

-- 2. 1dml 겨로가를 WHERE조건 절에 사용하는 메인 쿼리 작성
SELECT
  FROM
WHERE
;

--------------------------------------------------------
-- 서브쿼리 실습
-- 1. 이 회사의 평균급여보다 급여가 큰 직원들의 목록 조회 (사번, 이름, 급여)
SELECT e.empno
     , e.ename
     , e.sal
  FROM emp e
 WHERE e.sal > (SELECT AVG(e.sal)
                  FROM emp e)
;

-- 2. 급여가 평균급여보다 크면서 사번이 7700번 보다 높은 직원 조회 (사번, 이름, 급여)
SELECT e.empno
     , e.ename
     , e.sal
  FROM emp e
 WHERE e.sal > (SELECT AVG(e.sal)
                  FROM emp e)
   AND e.empno > 7700
;
  
-- 3. 각 직무별로 최대 급여를 받는 직원 목록을 조회(사번, 이름, 직무, 급여)
-- a) 직무별 최대급여를 구하는 서브쿼리
SELECT e.job
     , MAX(e.sal) as sal
  FROM emp e
 GROUP BY e.job
;
-- b) a를 사용할 메인쿼리
--  최대급여가 자신의 급여와 같은지
--  그때, 직무가 나의 직무와 같은지 비교
SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
 WHERE e.sal = (SELECT e.job                 ---> ORA-00913: too many values
                     , MAX(e.sal) as sal
                  FROM emp e
                 GROUP BY e.job)
;

---> WHERE절에서 비교하는 e.sal은 1컬럼
--   서브쿼리에서 돌아오는 값은 총 2개의 컬럼이라 비교 불가능

SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
 WHERE e.sal = (SELECT MAX(e.sal) as sal    ---> ORA-01427: single-row subquery returns more than one row
                  FROM emp e
                 GROUP BY e.job)
;
-- 하나에 행에 여러개 행을 비교 불가

-- IN연산자 사용
SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
 WHERE (e.job, e.sal) IN (SELECT e.job
                               , MAX(e.sal) max_sal
                            FROM emp e
                           GROUP BY e.job)
;

SELECT e.empno
     , e.ename
     , e.job
     , e.sal
  FROM emp e
 WHERE e.sal IN (SELECT MAX(e.sal) max_sal
                   FROM emp e
                  GROUP BY e.job)
;
---> 데이터가 다양해지면 잘못 자동할 수 있다


-- 4. 각 월별 입사인원을 세로로 출력
-- a)
-- b)
SELECT to_char(e.hiredate, 'FMMM')
     , COUNT(*)
  FROM emp e
 GROUP BY to_char(e.hiredate, 'FMMM')
;

-- c) 입사월 순으로 정렬
SELECT to_number(to_char(e.hiredate, 'FMMM')) 입사월
     , COUNT(*) 인원
  FROM emp e
 GROUP BY to_char(e.hiredate, 'FMMM')
 ORDER BY 입사월
;

SELECT to_number(to_char(e.hiredate, 'FMMM'))||'월' 입사월
     , COUNT(*) 인원
  FROM emp e
 GROUP BY to_char(e.hiredate, 'FMMM')
 ORDER BY 입사월
; --> '월'을 붙이면 문자로 변환되어 정렬 안됨

SELECT a.입사월 || '월' as 입사월
     , a.인원
  FROM (SELECT to_number(to_char(e.hiredate, 'FMMM')) 입사월
             , COUNT(*) 인원
          FROM emp e
         GROUP BY to_char(e.hiredate, 'FMMM')
         ORDER BY 입사월) a
;
