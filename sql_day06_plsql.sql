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