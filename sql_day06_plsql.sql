-----------------------------------------------
-- PL/SQL 계속
-----------------------------------------------
------ IN, OUT 모드변수를 사용하는 프로시저


-- 문제) 한달 급여를 입력(IN모드변수)하면  일년 급여를 계산해주는 프로시저를 작성

-- 1) SP 이름 : sp_calc_year_sal
-- 2) 변수    : IN => v_sal
--              OUT => v_sal_year
-- 3) PROCEDURE 작성

CREATE OR REPLACE PROCEDURE sp_calc_year_sal
(  v_sal       IN NUMBER
 , v_sal_year OUT NUMBER)
IS
BEGIN
    v_sal_year := v_sal * 12;
END sp_calc_year_sal;
/
-- 4) SQL*PLUL CLI라면 위 코드를 복사 + 붙여넣기
--    Oracle SQL Developer : ctrl + enter키 입력

-- Procedure SP_CALC_YEAR_SAL이(가) 컴파일되었습니다. // 오류가 존재하면 SHOW errors 명령으로 확인

-- 5) OUT모드변수가 있는 프로시저이므로 BIND변수가 필요
--    VAR 명령으로 SQL*PLUS의 변수를 선언하는 명령
VAR v_sal_year_bind NUMBER;

-- 6) 프로시저 실행 : EXEC[UTE] : SQL*PLUS명령
EXEC SP_CALC_YEAR_SAL(1200000, :V_SAL_YEAR_BIND)
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 7) 실행 결과가 담긴 BIND 변수를 SQL*PLUS에서 출력
PRINT v_sal_year_bind
/*
V_SAL_YEAR_BIND
---------------
       14400000
*/

-- 실습 6) 여러 형태의 변수를 사용하는 sp_variables를 작성
/*
    IN 모드 변수 : v_deptno, v_loc
    지역변수     : v_hiredate, v_empno, v_msg
    상수         : v_max
*/

-- 1) 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_variables
(  v_deptno     IN NUMBER
 , v_loc        IN VARCHAR2)
IS
    -- IS ~ BEGIN 사이는 지역변수 선언 / 최기화
    v_hiredate VARCHAR2(0);
    v_empno NUMBER := 1999;
    v_msg := VARCHAR2(500) DEFAULT ' Hello, PL/SQL';
    
    -- CONSTANT는 상수를 만드는 설정
    v_max CONSTANT NUMBER := 5000;
BEGIN
    -- 위에서 정의된 값들을 출력
    DBMS_OUTPUT.PUT_LINE('v_hiredate: ' || v_hiredate);
    
    v_hiredate := sysdate;
    DBMS_OUTPUT.PUT_LINE('v_deptno: ' || v_deptno);
    DBMS_OUTPUT.PUT_LINE('v_loc: ' || v_loc);
    DBMS_OUTPUT.PUT_LINE('v_empno: ' || v_empno);
    
    v_msg :='내일 지구가 멸망하더라도 오늘 사과나무를 심겠다.'
    DBMS_OUTPUT.PUT_LINE('v_msg: ' || v_msg);
    
    -- 상수인 v_max에 할당 시도
    -- v_max := 10000;
    DBMS_OUTPUT.PUT('   , ');
    
END sp_variables;
/
-- 2) 컴파일 / 디버깅
-- 3) VAR : BIND변수가 필요하면 선언
-- 4) EXEC : SP실행
SET SERVEROUTPUT ON
EXEC sp_variables('10', '하와이')
EXEC sp_variables('20', '스페인')
EXEC sp_variables('30', '제주도')
EXEC sp_variables('40', '몰디브')
-- 5) PRINT : BIND 변수에 값이 저장되었으면 출력






--------------------------------------------------------------
-- PS/SQL 변수 : REFERENCE 변수 사용
-- 1) %TYPE 변수
--    DEPT 테이블의 부서번호를 입력(IN 모드) 받아서 
--    부서명을 (OUT 모드) 출력하는 저장 프로시저
     
     
CREATE OR REPLACE PROCEDURE set_get_dname
(  v_deptno     IN DEPT.DEPTNO%TYPE
 , v_dname     OUT DEPT.DNAME%TYPE
IS
BEGIN
    SELECT d.dname
      INTO v_name
      FROM dept d
     WHERE d.deptono = v.datpno
END sp_set_dname;
/

-- 2. 컴파일 / 디버깅
--Procedure SET_GET_DNAME이(가) 컴파일되었습니다.
-- 
-- 3. 













-------------------------------------------------------------------------------
-- 수업 중 실습
-- 문제) 한사람의 사번을 입력받으면 그 사람의 소속 부서명, 부서위치를 함께 화면 출력
-- 쿼리로 해결
SELECT e.ename
     , d.dname
     , d.loc
  FROM emp e
     , dept d
 WHERE e.deptno=d.deptno
   AND e.empno = 7654
;

-- (1) SP 이름 : sp_get_emp_info
CREATE OR REPLACE PROCEDURE sp_get_emp_info
(  v_ename IN EMP.EMPNO%TYPE;
 , v_dep)
IS
BEGIN
END
/
-- (2) IN 변수 : v_empno
-- (3) %TYPE, %ROWTYPE 변수 활용

-----instructor
CREATE OR REPLACE PROCEDURE sp_get_emp_info_ins
( v_empno     IN  emp.empno%TYPE)
IS
    -- emp테이블의 한 행을 받을 ROWTYPE
    v_emp emp&ROWTYPE;
    -- depy테이블의 한 행을 받을 ROWTYPE
    v_dept dept%ROWTYPE;
BEGIN
    -- SP의 좋은점은 여려개의 쿼리를 순차적으로 실행하는 것이 가능하고 변수를 활용할 수 있기 때무에
    
    -- 1. IN모드 벼누솔 들어로는 한 직원의 정보를 조회
    SELECT e.*
      INTO v_emp
      FROM emp e
     WHERE e.empno = v_empno
    ;
    
    -- 2. 1번 결과에서 직원의 부서번호를 얻을 수 있으므로
    --    부서정보 조회
    SELECT d.*
      INTO v_dept
      FROM dept d
     WHERE d.deptno = v_emp.deptno
    ;
    
    -- 3. v_emp, v_dept에서 필요한 필드만 화면 출력
    DBMS_OUTPUT.PUT_LINE('직원 이름 : ' || v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('소속 부서 : ' || v_dept.dname);
    DBMS_OUTPUT.PUT_LINE('부서 위치 : ' || v_dept.loc);
END sp_get_emp_info_ins;
/

-- 2. 컴파일 / 디버깅

-- 3. 실행 EXEC
EXEC sp_get_emp_info_ins(7654);


------------------------------------------------------------
-- PS/SQL 변수 : RECORD TYPE 변수의 사용
------------------------------------------------------------
-- RECORD TYPE : 한개 혹은 그 이상의 테이블에서 원하는 컬럼만 추출하여 구성

-- 문제) 사번을 입력(IN모드 변수) 받아 그 직원의 매니저 이름, 부서이름, 부서위치, 급여등급을 함께 출력

-- (1) SP 이름 : sp_get_emp_info_detail
-- (2) IN 변수 : v_empno
-- (3) RECODE 변수 : v_emp_record

-- 1. 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_get_emp_info_detail
(v_empno IN EMP.EMPNO%TYPE)
IS
    -- a. RECODE타입 선언
    TYPE emp_record_type IS RECORD
    ( r_empno        EMP.EMPNO%TYPE
     ,r_ename        EMP.ENAME%TYPE
     ,r_mgrname      EMP.ENAME&TYPE
     ,r_dname        DEPT.DNAME%TYPE
     ,r_loc          DEPT.LOC%TYPE
     ,r_salgrade     SALGRADE.GRADE%TYPE
     )
    ;
    
    -- b. a에서 선언한 타입의 변수를 선언
    v_emp_record      emp_record_type;
BEGIN
    -- c. 1에서 선언한 RECORD 타입은 조인의 결과를 받을 수 있음
    SELECT e.empno
         , e.ename
         , e1.ename
         , d.dname
         , d.loc
         , s.grade
      INTO v_emp_record
      FROM emp e
         , emp e1
         , dept d
         , salgrade s
     WHERE e.mgr = e1.empno
       AND e.deptno = d.deptno
       AND e.sal BETWEEN s.lowsal AND s.hisal
       AND e.empno = v_empno
    ;
    
    -- 4. v_emp_record에 들어온 값을 화면에 출력
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp_record.r_empno);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp_record.r_ename);
    DBMS_OUTPUT.PUT_LINE('매니저 : ' || v_emp_record.r_mgrname);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || v_emp_record.r_dname);
    DBMS_OUTPUT.PUT_LINE('부서위치 : ' || v_emp_record.r_loc);
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || v_emp_record.r_salgrade);
END sp_get_emp_info_detail;
/

-- 2. 컴파일 / 디버깅

-- 3. EXEC 실행
EXEC sp_get_emp_info_detail(7369)
EXEC sp_get_emp_info_detail(7902)
---------------------------------------------------------
-- 프로시저는 다른 프로시저에서 호출 가능

-- ANONYMOUS PROCEDURE를 사용하여 지금 정의한 sp_get_emp_info_detail 실행
DECLARE
    v_empno EMP.EMPNO%TYPE;
BEGIN
    SELECT e.empno
      INTO
      FROM emp e
     WHERE e.emp = 7902
    ;
    
    sp_get_emp_info_detail(v_empno);
END;
/

-------------------------------------------------
-- PS/SQL 변수 : 아규먼트 변수 IN OUT 모드의 사용
-------------------------------------------------
-- IN : SP로 값이 전달도리 때 사용, 입력용
--      프로시저를 사용하는 쪽(SQL*PLUS)에서 프로시저로 전달
-------------------------------------------------
-- OUT : SP에서 수행결과값이 저장되는 용도, 출력용
--       프로시저는 리턴(반환)이 없기 때문에
--       SP를 호출한 쪽에 돌려주는 방법으로 사용
-------------------------------------------------
-- IN OUT : 하나의 매개변수에 입력, 출력을 함께 사용
-------------------------------------------------
-- 문제) 기본 숫자값을 입력 받아서 숫자 포맷화 '$9,999.00'
--      출력하는 프로시저를 작성. IN OUT 모드 변수를 활용
-- (1) SP 이름 : sp_chng_member_format
-- (2) IN OUT 변수 : v_number
-- (3) BIND 변수 : v_number_bind

-- 1. 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_chng_number_format
( v_number IN OUT VARCHAR2)
IS
BEGIN
    -- a. 입력된 초기상태의 값 출력
    DBMS_OUTPUT.PUT_LINE('초기 입력 값 : ' || v_number);
    
    -- b. 숫자 패턴화 변경
    v_number := TO_CHAR(TO_NUMBER(v_number), '$9,999.99');
    
    -- c. 화면출력으로 변경된 패턴 확인
     DBMS_OUTPUT.PUT_LINE('초기 입력 값 : ' || v_number);
END sp_chng_number_format;
/

-- 2. 컴파일 / 디버깅
-- Procedure SP_CHNG_NUMBER_FORMAT이(가) 컴파일되었습니다.


-- 3. VAR : BIND변수 선언
-- IN OUT으로 사용될 변수
VAR v_number_bind   VARCHAR2(20)

-- 4. EXEC : 실행
--- a. BIND 변수에 1000으 먼저 저장
EXEC :v_number_bind := 1000
--- b. 1000이 저장된 BIND변수를 프로시저에 전달
EXEC sp_chng_number_format(:v_number_bind)
/*
초기 입력 값 : 1000
초기 입력 값 :  $1,000.00


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

-- 5. PRRINT : BIND 변수 출력
PRINT v_number_bind
/*
V_NUMBER_BIND
--------------------------------------------------------------------------------
 $1,000.00
*/

-- 위의 문제를 다른 방법으로 풀이 : SELECT ~ INTO
CREATE OR REPLACE PROCEDURE sp_chng_number_format
( in_number IN   NUMBER
 ,out_number OUT VARCHAR2)
IS
BEGIN
   -- in_number로 입력된 값을 INTO절을 사용하여 out_number변수로 입력
   SELECT TO_CHAR(in_number, '$9,999.99')
     INTO out_number
     FROM dual
    ;
END sp_chng_number_format;
/

VAR v_out_number_bind VARCHAR2(10)
EXEC sp_chng_number_format(1000, : v_out_number_bind)
PRINT v_out_number_bind













------------------------------------------------------------------------------------------------
-- PL/SQL 제어문
------------------------------------------------------------------------------------------------
-- 1. IF 제어문
--  IF ~ THEN ~ [ELSIF ~ THEN] ~ ELSE ~ END IF;

