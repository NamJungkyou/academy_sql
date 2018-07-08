-- 남정규lab04

-- 실습 3) emp테이블에서 상위관리자가 없는 직원 명단 출력
SELECT e1.EMPNO 사원번호
     , e1.ENAME 사원이름
     , e2.ENAME 상사이름
  FROM emp e1
     , emp e2
 WHERE e1.mgr = e2.empno(+)
;

/*
사원번호, 사원이름, 상사이름
--------------------------------------------------------------
7902	FORD	JONES
7900	JAMES	BLAKE
7844	TURNER	BLAKE
7654	MARTIN	BLAKE
7521	WARD	BLAKE
7499	ALLEN	BLAKE
7934	MILLER	CLARK
7782	CLARK	KING
7698	BLAKE	KING
7566	JONES	KING
7369	SMITH	FORD
7839	KING	
*/

-- 실습 4) emp 테이블에서 부하직원이 없는 직원 명단 출력/////////////////////////
SELECT e2.MGR 사원번호
     , e1.ENAME 사원이름
     , e1.ENAME 상사이름
  FROM emp e1
     , emp e2
 WHERE e1.mgr = e2.empno(+)
;

SELECT e1.EMPNO
     , e1.ENAME
  FROM emp e1 LEFT OUTER JOIN emp e2
;
/*

--------------------------------------------------------------

*/

-- 실습 5) emp 테이블에서 JAMES와 직무가 동일한 직원의 정보를 조회.
SELECT e.EMPNO
     , e.ENAME
     , e.JOB
  FROM emp e
 WHERE e.job = (SELECT e.JOB
                  FROM emp e
                 WHERE e.ename = 'JAMES')
;

/*
EMPNO, ENAME, JOB
--------------------------------------------------------------
7369	SMITH	CLERK
7900	JAMES	CLERK
7934	MILLER	CLERK
*/


--------------------------------DDL-------------------------------------------

-- 실습 1) userid, name, birthyear, regdate, address를 컬럼으로 가지는 CUSTOMER 테이블 생성
CREATE TABLE customer
(  userid       VARCHAR2(20)
 , name         VARCHAR2(20)
 , birthyear    number(4)
 , regdate      DATE
 , address      VARCHAR2(100)
 );

/*
Table CUSTOMER이(가) 생성되었습니다.
*/

-- 실습 2) 위에서 생성한 테이블의 구조 조회
DESC customer;

/*
이름        널? 유형            
--------- -- ------------- 
USERID       VARCHAR2(20)  
NAME         VARCHAR2(20)  
BIRTHYEAR    NUMBER(4)     
REGDATE      DATE          
ADDRESS      VARCHAR2(100) 
*/

-- 실습 3) 앞서 만든 CUSTOMER 테이블을 사용하여 NEW_CUST테이블 구조 복사 생성
CREATE TABLE new_cust
AS
SELECT *
  FROM CUSTOMER
 WHERE 1 = 2
;

/*
Table NEW_CUST이(가) 생성되었습니다.
*/

-- 실습 4) 생성된 NEW_CUST 테이블 구조 조회
DESC new_cust;

/*
이름        널? 유형            
--------- -- ------------- 
USERID       VARCHAR2(20)  
NAME         VARCHAR2(20)  
BIRTHYEAR    NUMBER(4)     
REGDATE      DATE          
ADDRESS      VARCHAR2(100) 
*/

-- 실습 5) emp 테이블을 사용하여 JOB이 SALESMAN인 경우의 데이터로 salesman 테이블 복사 생성
CREATE TABLE salesman
AS
SELECT *
  FROM emp e
 WHERE e.job = 'SALESMAN'
;

/*
Table SALESMAN이(가) 생성되었습니다.
*/

-- 실습 6)  생성된 salseman테이블 내용 조회
SELECT s.*
  FROM salesman s
;

/*
EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
--------------------------------------------------------------
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	30
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	30
*/

-- 실습 7) 앞서 생성한 CUSTOMER 테이블에 phone, grade라는 컬럼 추가
ALTER TABLE customer ADD
(  phone VARCHAR2(13)
 , grade VARCHAR2(20)
);

/*
Table CUSTOMER이(가) 변경되었습니다.
*/

-- 실습 8) 7에서 추가한 grade컬럼 삭제 / 재추가
ALTER TABLE customer DROP COLUMN grade;

ALTER TABLE customer ADD
( grade VARCHAR2(20)
);

/*
Table CUSTOMER이(가) 변경되었습니다.

Table CUSTOMER이(가) 변경되었습니다.
*/

-- 실습 9) 7에서 추가한 phone컬럼의 크기 변경
--          userid컬럼의 타입 변경
ALTER TABLE customer MODIFY ( phone     VARCHAR2(11)
                             ,userid    NUMBER);
                             
/*
Table CUSTOMER이(가) 변경되었습니다.
*/



