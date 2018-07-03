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
     ,r_mgrname      EMP.ENAME%TYPE
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
       AND e.sal BETWEEN s.losal AND s.hisal
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

-- JOB별로 경조사비를 급여대비 일정 비율로 지급하고 있따.
-- 각 직원들의 경조사비를 구하는 프로시저 작성
/*
CLERK       : 5%
SALESMAN    : 4%
MANAGER     : 3.7%
ANALYST     : 3%
PRESIDENT   : 1.5%
*/

-- (1) SP 이름 : sp_get_tribute_fee
-- (2) IN 변수 : v_empno(사번) 
-- (3) OUT 변수 : v_tribute_fee(급여타입)

-- 1. 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_get_tribute_fee
( v_empno        IN EMP.EMPNO%TYPE
 ,v_tribute_fee OUT EMP.SAL%TYPE )
IS
    -- 1. 사번인 직원의 직무를 저장할 지역변수 선언
    v_job EMP.JOB%TYPE;
    -- 2. 사번인 직원의 급여를 저장할 지역변수 선언
    v_sal EMP.SAL%TYPE;
    
BEGIN
    -- 1. 입력된 사번 직원의 직무를 조회하여 v_job에 저장
    SELECT e.job, e.sal
      INTO v_job, v_sal
      FROM emp e
     WHERE e.EMPNO = v_empno
    ;
/*
    CLERK       : 5%
    SALESMAN    : 4%
    MANAGER     : 3.7%
    ANALYST     : 3%
    PRESIDENT   : 1.5%
*/
    -- 2. 일정비율로 v_tribute_fee를 계산
    IF    v_job = 'CLERK'       THEN v_tribute_fee := v_Sal * 0.05;
    ELSIF v_job = 'SALESMAN'    THEN v_tribute_fee := v_Sal * 0.04;
    ELSIF v_job = 'MANAGER'     THEN v_tribute_fee := v_Sal * 0.037;
    ELSIF v_job = 'ANALYST'     THEN v_tribute_fee := v_Sal * 0.03;
    ELSIF v_job = 'PRESIDENT'   THEN v_tribute_fee := v_Sal * 0.015;
    END IF;
END sp_get_tribute_fee;
/

-- 2. 컴파일/ 디버깅
-- Procedure SP_GET_TRIBUTE_FEE이(가) 컴파일되었습니다.

-- 3. VAR v_tribute_fee_bind
VAR v_tribute_fee_bind NUMBER

-- 4. EXEC
EXEC sp_get_tribute_fee(v_tribute_fee => :v_tribute_fee_bind, v_empno => 7566)
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

-- 5. PRINT
PRINT v_tribute_fee_bind
/*
V_TRIBUTE_FEE_BIND
------------------
            110.08
*/

------------------------------------------------------------
-- 2. LOOP 기본 반복문
------------------------------------------------------------
-- ANONYMOUS PROCEDURE로 실행 예
-- 문제) 1 ~ 10까지의 합을 출력

DECLARE
    -- 초기값 변수 선언 및 초기화
    v_init NUMBER := 0;
    -- 합산을 저장할 변수 선언 및 초기화
    v_sum NUMBER := 0;
BEGIN
    LOOP
        v_init := v_init +1;
        v_sum := v_sum + v_init;
        
        DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
        -- 반복문 종료 조건
        EXIT WHEN v_init = 10;
    END LOOP
    ;
    
    -- 합산변수 출력
    DBMS_OUTPUT.PUT_LINE('1 ~ 10 합산 결과 : ' || v_sum);
END;
/
/*
v_sum : 1
v_sum : 3
v_sum : 6
v_sum : 10
v_sum : 15
v_sum : 21
v_sum : 28
v_sum : 36
v_sum : 45
v_sum : 55
1 ~ 10 합산 결과 : 55


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

--------------------------------------------------------
-- 2. LOOP : FOR LOOP 카운터 변수를 사용하는 반복문
--------------------------------------------------------
-- 지정된 횟수만큼 실행 반복문
-- 문제) 1 ~20 사이의 3의 배수를 출력 : ANONYMOUS PROCEDURE
DECLARE
    -- 1. FOR LOOP에서 사용할 카운터 변수 선언 및 초기화
    cnt     NUMBER := 0;
BEGIN
    -- 2. LOOP 작성
    FOR cnt IN 1 .. 20 LOOP
        -- 3. 3의 배수 판단.
        IF(MOD(cnt, 3) = 0)
            THEN DBMS_OUTPUT.PUT_LINE(cnt);
        END IF;
    END LOOP;
END;
/
/*
3
6
9
12
15
18


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

------------------------------------------------------------------------
-- 2. LOOP : WHILE LOOP 조건에 따라 수행되는 반복문
------------------------------------------------------------------------
-- 문제) 1 ~ 20 사이의 수 중에서 2의 배수를 화면에 출력
--       ANONYMOUS PROCEDURE로 바로 수행
DECLARE
    -- 반복 조건으로 사용할 횟수 변수 선언 및 초기화
    cnt     NUMBER := 0;
BEGIN
    --WHILE 반복문 작성
    WHILE cnt < 20 LOOP
        cnt := cnt + 2; 
        DBMS_OUTPUT.PUT_LINE(cnt);
    END LOOP;
    
    --INSERT INTO ... VALUES()
    -- COMMIT 
END;
/
/*
2
4
6
8
10
12
14
16
18
20


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

--------------------------------------------------
-- PL/SQL : Stored Function(저장함수)
--------------------------------------------------
-- 대부분 SP와 유사
-- IS 블록 전에 RETURN 구문이 존재
-- RETURN 구문에는 문장종료기호(;)가 없음
-- 실행은 기존에 사용하는 함수와 동일하게 SELECT, WHERE절 등에 사용함

-- 문제) 부서번호를 입력받아서 해당부서의 급여 평균을 구하는 함수 작성
---- (1) FN 이름 : fn_avg_sal_by_dept
---- (2) IN 변수 : v_deptno (부서번호타입)

-- 1. 함수작성
CREATE OR REPLACE FUNCTION fn_avg_sal_by_dept
( v_deptno      IN      emp.deptno%TYPE)
-- 함수의 리턴구문 작성
RETURN NUMBER
IS
    -- 부서별 급여평균을 저장할 지역변수 선언
    v_avg_sal   emp.sal%TYPE;
BEGIN
    -- 부서별 급여평균을 AVG() 함수를 사용하여 구하고 저장
    SELECT avg(e.sal)
      INTO v_avg_sal
      FROM emp e
     WHERE e.deptno = v_deptno
    ;
    
    -- 계산결과를 반올림하여 리턴
    RETURN ROUND(v_avg_sal);
    
END fn_avg_sal_by_dept;
/

-- 2. 컴파일 / 디버깅
--Function FN_AVG_SAL_BY_DEPT이(가) 컴파일되었습니다.

-- 3. 이 함수를 사용하는 쿼리를 작성하여 실행해 본다.
SELECT fn_avg_sal_by_dept(10) as "부서 급여 평균"
  FROM dual
;

SELECT AVG(sal)
  FROM emp
 WHERE deptno = 10
;

-- 10번 부서의 급여평균보다 높은 급여평균을 가지고 있는 부서는?
SELECT e.deptno
     , AVG(e.sal)
  FROM emp e
 GROUP BY e.deptno
HAVING AVG(e.sal) > fn_avg_sal_by_dept(30)
;



------------------------------------------------------------
-- SP/FN에서 예외처리
------------------------------------------------------------
-- 예외처리 : 오라클에서 프로시저 실행 중 발생할 수 있는 이미 잘 알려진 상황에 

-- 1. NO_DATA_FOUND
CREATE OR REPLACE PROCEDURE sp_get_emp_info_detail
(v_empno IN EMP.EMPNO%TYPE)
IS
    -- a. RECODE타입 선언
    TYPE emp_record_type IS RECORD
    ( r_empno        EMP.EMPNO%TYPE
     ,r_ename        EMP.ENAME%TYPE
     ,r_mgrname      EMP.ENAME%TYPE
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
       AND e.sal BETWEEN s.losal AND s.hisal
       AND e.empno = v_empno
    ;
    
    -- 4. v_emp_record에 들어온 값을 화면에 출력
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp_record.r_empno);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp_record.r_ename);
    DBMS_OUTPUT.PUT_LINE('매니저 : ' || v_emp_record.r_mgrname);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || v_emp_record.r_dname);
    DBMS_OUTPUT.PUT_LINE('부서위치 : ' || v_emp_record.r_loc);
    DBMS_OUTPUT.PUT_LINE('급여등급 : ' || v_emp_record.r_salgrade);
    
    -- 5. NO_DATA_FOUND 예외처리
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN DBMS_OUTPUT.PUT_LINE('해당 직원의 매니저 혹은 부서가 없습니다.');
    
END sp_get_emp_info_detail;
/
EXEC sp_get_emp_info_detail(7839)
EXEC sp_get_emp_info_detail(6666)

-- 2. DUP_VAL_ON_INDEX
-- 문제) member테이블에 member_id, member_name을 입력하여 신규로 1행을 추가하는 sp_insert_member 작성

--- 1. 프로시저 작성
CREATE OR REPLACE PROCEDURE sp_insert_member
( v_member_id   IN   member.member_id%TYPE
 ,v_member_name IN   member.member_name%TYPE)
IS
BEGIN
    -- 입력된 IN 모드 변수 값을 INSERT 시도
    INSERT INTO member (member_id, member_name)
    VALUES (v_member_id, v_member_name)
    ;
    COMMIT;
           DBMS_OUTPUT.PUT_LINE(v_member_id || '에 신규 데이터를 추가합니다.');
    -- 입력시도에서는 항상 DUP_vAL_ON_INDEX 예외 위험이 존재
    EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN -- 이미 존재하는 키의 값이면 신규추가가 아니라 수정으로 진행
              UPDATE member m
                 SET m.member_name = v_member_name 
               WHERE m.member_id = v_member_id
               ;
               -- 처리내용을 화면에 출력
               DBMS_OUTPUT.PUT_LINE(v_member_id || '가 이미 존재하므로 멤버의 정보를 수정합니다.');
        /*
         WHEN NO_DATA_FOUND
         THEN ....
        */
END sp_insert_member;
/

-- 2. 컴파일 / 디버깅
-- 3. EXEC
EXEC sp_insert_member('M13', '채한나')
EXEC sp_insert_member('M13', '유재성')