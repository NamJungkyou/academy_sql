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
-------------------------------------------------------------------------------------------------

-- DDL : DMBS가 OBJECT(객체)로 관리/인식하는 대상을 생성, 수정, 삭제하는 언어
-- 생성 : CREATE
-- 수정 : ALTER
-- 삭제 : DROP

-- VS DML
--   생성 : INSERT
--   수정 : UPDATE
--   삭제 : DELETE

---------------------------------------------------------------------------------------------------
/*
DDL 구문의 시작
CREATE | ALTER | DROP (관리할 객체의 타입명)

DBMS의 객체들 타입
SCHEMA, DOMAIN, TABLE, VIEW, INDEX, SEQUENCE, USER, DATABASE
*/

-- 1. 테이블 생성 구문
CREAT TABLE 테이블명
(  컬럼1명, 테이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]
 [,컬럼2명, 테이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]
 ......
 [,컬럼2명, 테이터타입[(길이)] [DEFAULT 기본값] [컬럼의 제약사항]
);
/*------------------------------------
 컬럼의 제약사항
 --------------------------------------
 1. PRIMARY KEY : 이 컬럼에 입력되는 값은 중복되지 않고 한 행을 유일하게 식별 가능한 값으로 설정
                  NULL데이터 입력이 불가능
 2. FOREIGN KEY : 주로 JOIN에 사용되는 조건으로 다른 테이블의 PRIMARY KEY로 사용되었던 값이 등장
 3. UNIQUE      : 이 컬럼에 입력되는 값은 중복되지 않음을 보장
                  NULL일 수 있음
 4. NOT NULL    : 이 컬럼에 입력되는 값의 중복은 상관없으나 NULL은 되지 않도로 보장
 
 ==> PK : UNIQUE + NOT NULL
*/

-- 예) 아카데미 구성인원정보를 저장할 테이블을 정의
/*
 테이블이름 : member
 1. 멤버 아이디      : member_id    : 문자 : VARCHAR2 : PK
 2. 멤버 이름        : member_name  : 문자 : VARCHAR2 : NOT NULL
 3. 전화번호 뒷자리  : phone        : 문자 : VARCHAR2 
 4. 시스템등록일     : reg_date     : 날짜 : DATE   
 5. 사는 곳(동 이름) : address      : 문자 : VARCHAR2 
 6. 좋아하는 숫자    : like_number  : 숫자 : NUMBER   
*/

CREATE TABLE member
(  member_id     VARCHAR2(3)     PRIMARY KEY
 , member_name   VARCHAR2(15)    NOT NULL
 , phone         VARCHAR2(4) -- NULL허용시 제약조건 비워두면 됨
 , reg_date      DATE            DEFAULT sysdate
 , address       VARCHAR2(30)
 , like_number   NUMBER
);
-- Table MEMBER이(가) 생성되었습니다.

-- 2. 테이블 삭제 구문
DROP TABLE 테이블명;

DROP TABLE member;
-- Table MEMBER이(가) 삭제되었습니다.

-- 3. 테이블 수정 구문
/*----------------------------
  수정의 종류
  ----------------------------
  1. 컬럼을 추가 : ADD
  2. 컬럼을 삭제 : DROP COLUMN
  3. 컬럼을 수정 : MODIFY
  ----------------------------
*/
ALTER TABLE 테이블명 {ADD || DROP COLUMN | MODIFY} ....;

-- 예) 생성한 member테이블에 컬럼 2개 추가
-- 출생 월 : birth_month : NUMBER
-- 성별    : gender      : VARCHAR2(1)
-- 1) ADD
ALTER TABLE member ADD
(  birth_month NUMBER
 , gender      VARCHAR2(1) CHECK (gender IN ('M', 'F'))
);
-- Table MEMBER이(가) 변경되었습니다.

-- 예) 수정한 member 테이블에서 like_number 컬럼을 삭제
-- 2) DROP COLUMN
ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
ALTER TABLE member DROP COLUMN like_number;
-- Table MEMBER이(가) 변경되었습니다.

-- 예) 출생월 컬럼을 숫자2까지만으로 제한하도록 수정
-- 3) MODIFY
ALTER TABLE 테이블명 MODIFY 컬럼명 테이터타입(크기);
ALTER TABLE member MODIFY birth_month NUMBER(2);
-- Table MEMBER이(가) 변경되었습니다.

----------------------------------------------------
-- 예로 사용할 member테이블의 최종형태 작성 구문

CREATE TABLE member
(  member_id     VARCHAR2(3)     PRIMARY KEY
 , member_name   VARCHAR2(15)    NOT NULL
 , phone         VARCHAR2(4) -- NULL허용시 제약조건 비워두면 됨
 , reg_date      DATE            DEFAULT sysdate
 , address       VARCHAR2(30)
 , birth_month   NUMBER(2)
 , gender        VARCHAR2(10)     CHECK (gender IN ('M', 'F'))
);
-- 가장 단순한 테이블 정의 구문
-- 제약조건을 각 컬럼 뒤에 제약조건명 없이 바로 생성

--****테이블 생성시 정의한 제약조건이 저장되는 형태***---

-- DDL로 정의된 제약조건은 시스템 카탈로그에 저장됨
-- user_constraints라는 테이블에 저장
SELECT u.CONSTRAINT_NAME
     , u.CONSTRAINT_TYPE
     , u.TABLE_NAME
  FROM user_constraints u
 WHERE u.TABLE_NAME = 'MEMBER'
;
/*
SYS_C008007	C	MEMBER
SYS_C008008	P	MEMBER
SYS_C008009	C	MEMBER
*/
drop table member;
-- 제약조건에 이름을 부여해서 생성
CREATE TABLE member
(  member_id     VARCHAR2(3)
 , member_name   VARCHAR2(15)    NOT NULL
 , phone         VARCHAR2(4) -- NULL허용시 제약조건 비워두면 됨
 , reg_date      DATE            DEFAULT sysdate
 , address       VARCHAR2(30)
 , birth_month   NUMBER(2)
 , gender        VARCHAR2(10) 
 , CONSTRAINT pk_member          PRIMARY KEY (member_id)
 , CONSTRAINT ck_member_gender   CHECK (gender IN ('M', 'F'))
);

SELECT u.CONSTRAINT_NAME
     , u.CONSTRAINT_TYPE
     , u.TABLE_NAME
  FROM user_constraints u
 WHERE u.TABLE_NAME = 'MEMBER'
;
/*
SYS_C008010	C	MEMBER
CK_MEMBER_GENDER	C	MEMBER
PK_MEMBER	P	MEMBER
*/

-- 테이블 생성 기법중 이미 존재하는 테이블을 복사하여 생성
-- 예) 앞서 생성한 member테이블을 복사하여 생성 : new_member
DROP TABLE new_member;
CREATE TABLE new_member
AS
SELECT *
  FROM member
 WHERE 1 = 2
; ---> PK설정은 복사되지 않고 테이블구조만 복사됨

DESC new_member;

-- member테이블에 데이터 추가
/*
INSERT INTO "SCOTT"."NEW_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M01', '유재성', '0238', '용운동', '3', 'M')
INSERT INTO "SCOTT"."NEW_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M02', '윤홍식', '4091', '오정동', '12', 'M')
INSERT INTO "SCOTT"."NEW_MEMBER" (MEMBER_ID, MEMBER_NAME, PHONE, ADDRESS, BIRTH_MONTH, GENDER) VALUES ('M03', '윤한수', '9034', '오정동', '8', 'M')
*/

-- 오정동에 사는 인원의 정보만 복사해서 새 테이블 생성
-- ojung_member
DROP TABLE ojung_member;
CREATE TABLE ojung_member
AS
SELECT *
  FROM new_member
 WHERE address='오정동'
;
-- Table OJUNG_MEMBER이(가) 생성되었습니다.

-- 복사할 조건에 항상 참이되는 조건을 주면 모든 데이터를 복사하여 새 테이블 생성
DROP TABLE full_member;
CREATE TABLE full_member
AS
SELECT *
  FROM ojung_member
 WHERE 1 =1
;

----------------------------------------
-- 테이블 수정할 때 주의사항
-- 1) 컬럼에 데이터가 없을 때는 타입변경, 크기변경 모두 자유로움
-- 2) 컬럼에 데이터가 있을 때 데이터 크기가 동일하거나 커지는 쪽으로만 변경가능
--    숫자는 정밀도 증가로만 허용
-- 3) 기본값(DEFAULT) 설정은 수정 이후 입력값부터 적용
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1) 기본값 설정 전에 멤버정보 하나 추가 : address가 NULL인 데이터
INSERT INTO "SCOTT"."OJUNG_MEMBER"(MEMBER_ID, MEMBER_NAME, PHONE, BIRTH_MONTH, GENDER) VALUES('M99', '홍길동', '0000', 6, 'M');



-- 이미 데이터가 들어있는 컬럼의 크기 변경
-- 예) ojung_member테이블의 출생월 birth_month컬럼을 1칸으로 줄이면
ALTER TABLE ojung_member MODIFY birth_month NUMBER(1);
-- ORA-01440: column to be modified must be empty to decrease precision or scale
ALTER TABLE ojung_member MODIFY birth_month NUMBER(10, 2);
-- Table OJUNG_MEMBER이(가) 변경되었습니다.
-- 숫자 데이터를 확장하는 방식으로 변경 성공

-- 예) 출생월 birth_month를 문자2자리로 변경
ALTER TABLE ojung_member MODIFY birth_month VARCHAR2(2);
-- ORA-01439: column to be modified must be empty to change datatype
-- 데이터타입 변경을 위해서는 컬럼에 데이터가 없어야 한다.

----------------------------------------------------------------------------------
-- (3) 데이터 무결성 제약조건 처리방법 4가지
-- 1. 컬럼 정의할 때 제약조건명 없이 바로 선언
DROP TABLE main_table;
CREATE TABLE main_table
(  id       VARCHAR(2)       PRIMARY KEY
 , nickname VARCHAR(2)       UNIQUE
 , reg_date DATE             DEFAULT sysdate
 , gender   VARCHAR2(1)      CHECK(gender IN ('M', 'F'))
 , message  VARCHAR2(300)
);
-- 2. 컬럼 정의할 때 제약조건명을 명시하여 선언
DROP TABLE main_table;
CREATE TABLE main_table
(  id       VARCHAR(2) CONSTRAINT pk_main_table      PRIMARY KEY
 , nickname VARCHAR(2) CONSTRAINT uq_main_talbe_nick UNIQUE
 , reg_date DATE             DEFAULT sysdate
 , gender   VARCHAR2(1) CONSTRAINT ck_main_talbe_gender CHECK(gender IN ('M', 'F'))
 , message  VARCHAR2(300)
);

DROP TABLE sub_table;
CREAT TABLE sub_table
(  id VARCHAR2(10)     CONSTRAINT fk_sub_table REFERENCES main_table(id)
 , sub_code NUMBER(4)  NOT NULL
 , sub_name VARCHAR2(30)
);

-- 3. 컬럼 정의 후 제약조건 따로 선언
DROP TABLE main_table;
DROP TABLE sub_table;

CREATE TABLE main_table
(  id       VARCHAR(2) CONSTRAINT pk_main_table      PRIMARY KEY
 , nickname VARCHAR(2) CONSTRAINT uq_main_talbe_nick UNIQUE
 , reg_date DATE             DEFAULT sysdate
 , gender   VARCHAR2(1) CONSTRAINT ck_main_talbe_gender CHECK(gender IN ('M', 'F'))
 , message  VARCHAR2(300)
 , CONSTRAINT pk_main_table      PRIMARY KEY(id)
 , CONSTRAINT uq_main_talbe_nick UNIQUE(nickname)
 , CONSTRAINT ck_main_talbe_gender CHECK(gender IN ('M', 'F'))
);

CREAT TABLE sub_table
(  id VARCHAR2(10)  
 , sub_code NUMBER(4)  NOT NULL
 , sub_name VARCHAR2(30)
 , CONSTRAINT fk_sub_table FOREIGN KEY(id) REFERENCES main_table(id)
 -- sub_table의 키는 id, sub_code를 묶어서 복합키 형태로 설정
 , CONSTRAINT pk_sub_table PRIMARY KEY(id, sub_code)
 -- 복합키로 PK를 설정할 때는 제약조건을 따로 주는 방법으로만 가능
);

-- 4. 테이블 정의 후 테이블 수정(ALTER TABLE)로 제약조건 추가
-- 제약조건이 없는 테이블 생성

-- 제약조건 사후 추가
ALTER TABLE main_table ADD
( CONSTRAINT pk_main_table      PRIMARY KEY(id)
);

-- 테이블 이름의 변경 : RENAME
-- ojung_member ====> member_of_ojung
RENAME ojung_member TO member_of_ojung;
-- 테이블 이름이 변경되었습니다.
DESC ojung_member;
DESC member_of_ojung;
-- 테이블 이름 다시 변경
RENAME member_of_ojung TO ojung_member;

-- 테이블 삭제 : DROP

DROP TABLE main_table;
-- ORA-02449: unique/primary keys ntable referenced by foreign keys
-- sub_table의 id컬럼이 main_table의 id컬럼을 참조하기 때문에 삭제 순서가 필요

-- 참조관계에 상관없이 테이블 바로 삭제
DROP TABLE main_table CASCADE CONSTRAINT;
-- sub_table과의 참조관계가 끊어지며 바로 삭제 됨

