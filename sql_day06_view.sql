---------------------------------------------------------
-- VIEW : 논리적으로만 존재하는 가상 테이블
---------------------------------------------------------

-- 1. SCOTT 계정에 VIEW 생성 권한 부여
CONN sys as sysdba;

GRANT CREATE VIEW TO SCOTT;
CONN SCOTT/TIGER;

-- 2. 
CREATE TABLE new_emp
AS
SELECT *
  FROM emp
 WHERE 1=1
;

CREATE TABLE new_dept
AS
SELECT *
  FROM dept
 WHERE 1=1
;

-- 3. 복사 테이블에 누락된 PK 설정 ALTER
-- new_dept에 PK설정
ALTER TABLE new_dept ADD
CONSTRAINT pk_new_deptno    PRIMARY KEY(deptno)
;
-- new_emp에 PK설정
ALTER TABLE new_emp ADD
( CONSTRAINT pk_new_emp         PRIMARY KEY (empno)
 ,CONSTRAINT fk_new_deptno      FOREIGN KEY (deptno) REFERENCES new_dept(deptno)
 ,CONSTRAINT fk_new_emp_mgr     FOREIGN KEY (mgr)    REFERENCES new_emp(empno)
 );
 
-- 4. 복사 테이블에서 view 생성
--   : 상사이름, 부서명, 부서위치까지 조회할 수 있는 뷰
CREATE OR REPLACE VIEW v_emp_dept
AS
SELECT e1.empno
     , e1.ename
     , e2.ename as mgr_name
     , e1.deptno
     , d.dname
     , d.loc
  FROM new_emp e1
     , new_emp e2
     , new_dept d
 WHERE e1.mgr = e2.empno(+)
   AND e1.deptno = d.deptno(+)
;

-- 6. 뷰 정보는 딕셔너리에 저장된다.
--     user_views
DESC user_views;

SELECT u.view_name
     , u.text
     , u.read_only
  FROM user_views u
;

-- 7. 생성된 뷰에서 데이터 확인
--- 1) 전체 조회
SELECT v.*
  FROM v_emp_dept v
;
--- 2) SALES 이름 부서의 정보 조회
SELECT v.empno
     , v.ename
     , v.dname
  FROM v_emp_dept v
 WHERE v.dname = 'SALES'
;