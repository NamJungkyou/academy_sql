-- 남정규lab06

-- 실습 1)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL World!');
END;
/
/*
Hello, PL/SQL World!


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

-- 실습 2)
DECLARE
    str VARCHAR2(30):= 'Hello, PL/SQL World!';
BEGIN
    DBMS_OUTPUT.PUT_LINE(str);
END;
/
/*
Hello, PL/SQL World!


PL/SQL 프로시저가 성공적으로 완료되었습니다.
*/

-- 실습 3)
CREATE TABLE log_table
(  userid VARCHAR2(20)
 , log_date DATE
);
-- Table LOG_TABLE이(가) 생성되었습니다.

CREATE OR REPLACE PROCEDURE log_execution
IS
    v_userid VARCHAR2(20) := 'myid';
BEGIN
    INSERT INTO log_table
    VALUES (v_userid, sysdate);
END log_execution;
/
-- Procedure LOG_EXECUTION이(가) 컴파일되었습니다.
EXEC LOG_EXECUTION;
-- PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT l.userid
     , l.log_date
  FROM log_table l
;
/*
USER_ID, LOG_DATE
-----------------
myid	18/07/03
*/

-- 실습 4)
CREATE OR REPLACE PROCEDURE log_execution
( v_log_user  IN  VARCHAR2
 ,v_log_date  OUT VARCHAR2)
IS
BEGIN
    INSERT INTO log_table
    VALUES (v_log_user, sysdate);
    
   v_log_date := sysdate;
   
END log_execution;
/

VAR v_log_result VARCHAR2(300)

EXEC log_execution('myid2', :v_log_result)

PRINT v_log_result

select * from log_table;
/*
V_LOG_RESULT
--------------------------------------------------------------------------------
18/07/09


USER_ID, LOG_DATE
-----------------
myid	18/07/09
myid2	18/07/09
*/


--------------------여기부터 06------------------------------
-- 실습 5)

/*

*/

-- 실습 6)

/*

*/

-- 실습 7)

/*

*/

-- 실습 8)

/*

*/

-- 실습 9)

/*

*/

-- 실습 10)

/*

*/

-- 실습 11)

/*

*/

-- 실습 12)

/*

*/

-- 실습 13)

/*

*/

-- 실습 14)

/*

*/

-- 실습 15)

/*

*/

-- 실습 16)

/*

*/

-- 실습 17)

/*

*/

-- 실습 18)

/*

*/