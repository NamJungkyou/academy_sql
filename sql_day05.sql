-- sql_day05

-- ORACLE의 특별한 컬럼

-- 1. ROWID : 물리적으로 디스크에 저장된 위치를 가리키는 값으로 유일하며 ORDER BY절에 의해 변경되지 않음

-- 예) emp테이블에서 'SMITH'이 사람의 정보를 조회
SELECT e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'
;

-- ROWID와 같이 출력
SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'
;

-- 1. rowid는 ORDER BY절에 의해 변경되지 않음
SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 ORDER BY e.ename
;

SELECT e.rowid
     , e.empno
     , e.ename
  FROM emp e
 ORDER BY e.empno
;

-- 2: rownum : 조회된 결괴의 첫번째 행부터 1씩로 증가하는 값
SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename = 'SMITH'
;

SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename LIKE 'J%'
;

SELECT rownum
     , e.empno
     , e.ename
  FROM emp e
 WHERE e.ename LIKE 'J%'
 ORDER BY e.ename;
 
 -- 위의 두 결과를 비교하면 rownum도 order by에 영향을 받지 않는 것 처럼 보일 수 있으나
 -- SUB-QUERY로 사용할 때 영향을 받음

SELECT rownum
     , a.empno
     , a.ename
  FROM (SELECT rownum as numrow
             , e.empno
             , e.ename
             , '|' as deli
          FROM emp e
         WHERE e.ename LIKE 'J%'
         ORDER BY e.ename) a
;

-----------------------------------------
-- DML : 데이터 조작어
-----------------------------------------
-- 1) INSERT : 테이블에 

-- 데이터를 넣을 테이블
DROP TABLE member;
CREATE TABLE member
(  member_id    VARCHAR2(3)     
 , member_name  VARCHAR2(15)    NOT NULL
 , phone        VARCHAR2(4)     -- NULL 허용시 제약조건 비우면 됨
 , reg_date     DATE            DEFAULT sysdate
 , address      VARCHAR2(30)
 , birth_month  NUMBER(2)
 , gender       VARCHAR2(1)     
 , CONSTRAINT pk_member        PRIMARY KEY (member_id)
 , CONSTRAINT ck_member_gender CHECK (gender IN ('M', 'F'))
 , CONSTRAINT ch_member_birth CHECK(birth_month > 0 AND birth_month <= 12)
);

-- 1. INTO구문에 컬럼 이름을 생략하여 데이터 추가
INSERT INTO member
VALUES ('M01', '전현찬', '5250', sysdate, '덕명동', 11, 'M');

INSERT INTO member
VALUES ('M02', '조성철', '9034', sysdate, '오정동', 8, 'M');

INSERT INTO member
VALUES ('M03', '김승유', '5219', sysdate, '오정동', 1, 'M');

-- 몇몇 컬럼에 NULL데이터 추가
INSERT INTO member
VALUES ('M04', '박길수', '4003', sysdate, NULL, NULL, 'M');

INSERT INTO member
VALUES ('M05', '강현', NULL, NULL, '홍도동', 6, 'M');

INSERT INTO member
VALUES ('M06', '김소민', NULL, sysdate, '월평동', NULL, NULL);


-- 입력데이터 조회
SELECT * 
  FROM member m
;

-- CHECK옵션에 위배되는 데이터 추가 시도
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'N'); -- gender조건 위반
---> ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated
-- 수정
INSERT INTO member
VALUES ('M07', '강병우', '2260', sysdate, '사정동', 2, 'M');

INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 0, NULL); -- birth_month조건 위반
---> ORA-02290: check constraint (SCOTT.CH_MEMBER_BIRTH) violated
-- 수정
INSERT INTO member
VALUES ('M08', '정준호', NULL, sysdate, '나성동', 1, NULL);

-- 2. INTO구문에 컬럼명을 명시하여 데이터 추가
--    VALUES절에 INTO의 순서대로 값의 타입, 개수를 맞춰 작성
INSERT INTO member (member_id, member_name, gender)
VALUES ('M09', '윤홍식', 'M');
-- reg_date컬럼 : DEFAULT설정을 해놔서 시스템 날짜가 DEFAULT값으로 입력
-- phone, address 컬럼 : NULL값으로 입력되는 것을 확인

-- INTO절에 컬럼 나열시 테이블 정의순서와 별개로 나열 가능
INSERT INTO member (member_name, address, member_id)
VALUES ('이주영', '용전동', 'M10');

-- PK값이 중복되는 입력 시도
INSERT INTO member (member_name, member_id)
VALUES ('남정규', 'M10');
-- ORA-00001: unique constraint (SCOTT.PK_MEMBER) violated
-- 수정 : 이름 컬럼에 주소가 들어가는 데이터
--        이름, 주소 모두 문자 데이터형으로 데이터 타입이 같아서 데이터가 입력됨
--        논리오류 발생
INSERT INTO member (member_name, member_id)
VALUES ('목동', 'M11');

-- 필수입력 컬럼인 member_name누락
INSERT INTO member (member_id)
VALUES ('M12');
-- ORA-01400: cannot insert NULL into ("SCOTT"."MEMBER"."MEMBER_NAME")
-- 수정
INSERT INTO member (member_id, member_name)
VALUES ('M12', '이동희');

-- INTO절에 나열된 컬럼과 VALUES절의 값의 개수 불일치
INSERT INTO member(member_id, member_name, gender)
VALUES ('M13', '유재성');
-- SQL 오류: ORA-00947: not enough values

-- INTO절에 나열된 컬럼과 VALUES절의 데이터 타입이 불일치
INSERT INTO member(member_id, member_name, birth_month)
VALUES ('M13', '유재성', 'M');
-- ORA-01722: invalid number

-- 수정
INSERT INTO member(member_id, member_name, birth_month)
VALUES ('M13', '유재성', 3);

----------------------------------------------------------
-- 다중 행 입력 : SUB-QUERY를 사용하여 가능

-- 구문구조
INSERT INTO 테이블이름
SELECT 문장; -- 서브쿼리

-- CREATE AS SELECT는 데이터를 복사하여 테이블 생성
-- INSERT INTO ~ SELECCT는 이미 만들어진 테이블에 데이터만 복사하여 추가

-- member테이블의 내용을 조회하여 new_member로 insert
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.phone IS NOT NULL
;
-- 5개 행 이(가) 삽입되었습니다.

INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.member_id > 'M09'
;
-- 4개 행 이(가) 삽입되었습니다.

-- new_member테이블 데이터 삭제

-- 성이 '김'인 멤버데이터를 복사하여 입력
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE m.member_name LIKE '김%'
;
 
-- 짝수달에 태어난 멤버데이터를 복사하여 입력
INSERT INTO new_member
SELECT m.*
  FROM member m
 WHERE MOD(m.birth_month, 2)=0
;
 
-----------------------------------------------------------------

-- 2) UPDATE : 테이블의 행을 수정
--             WHERE조건절의 조합에 따라 1행 혹은 다행 수정이 가능

-- member테이블에서 이름이 잘못 들어간 'M11'멤버 정보를 수정
-- 데이터 수정 전에 영구반영을 실행
commit;

UPDATE member m
  SET m.member_name = '남정규'
 WHERE m.member_id = 'M11'
;
-- 1 행 이(가) 업데이트되었습니다.

-- 'M05'회원의 전화번호 필드를 업데이트
commit;
UPDATE member m
   SET m.phone = '1743'
-- WHERE m.member_id = 'M05'
;
-- 13개 행 이(가) 업데이트되었습니다.
-- WHERE조건절의 실수로 DML작업 실수가 발생
-- 데이터 상태 되돌리기
rollback;
UPDATE member m
   SET m.phone = '1743'
 WHERE m.member_id = 'M05'
;
-- 1 행 이(가) 업데이트되었습니다.

-- 2개 이상의 컬럼을 한번에 UPDATE SET절에 나열
UPDATE member m
   SET m.phone ='1743'
     , m.reg_date = sysdate
 WHERE m.member_id ='M05'
;
commit;

-- '월평동'에 사는 '김소민'멤버의 NULL 업데이트
UPDATE member m
   SET m.phone - '4724'
     , m.birth_month = 1
     , m.gender = 'F'
 WHERE m.address ='월평동'
-- m.member_id = 'M06'
;

-- 위의 실행결과는 의도대로 반영되는 것 처럼 
-- 월평동에 사는 사람이 많다면 월평동의 모든 사람 정보가 수정될 것.
-- 따라서 UPDATE구문 작성시 WHERE조간은 주의를 기울여서 작성해야 함

/* DML : UPDATE, DELETE작업시 주의 점

  딱 하나의 데이터를 수정/삭제 하려면 
  WHERE절의 비교조건에 반드시 PK로 설정한 컬럼의 값을 비교하도록 권장.
  
  PK는 전체 행에서 유일하고, NOT NULL임이 보장되기 때문.
  
  UPDATE, DELETE는 
  
  
*/

-- UPDATE구문에 SELECT 서브쿼리 사용
-- 'M08'아이디의 phone, gender 수정
UPDATE member m
   SET m.phone = '3318'
     , m.gender = 'M'
 WHERE m.member_id = 'M08' 
;

서브쿼리 적용
UPDATE member m
   SET m.phone = '3318'
     , m.gender = 'M'
 WHERE m.address = ( SELECT m.address
                       FROM member m
                      WHERE m.member_id = 'M08')
;
-- 1 행 이(가) 업데이트되었습니다.

-- 'M13' 유재성 멤버의 성별 업데이트
UPDATE member m
   SET m.gender = (SELECT substr('MATH', 1, 1)
                     FROM dual)
 WHERE m.member_id = 'M13' 
;
-- 1 행 이(가) 업데이트되었습니다.

-- 'M12' 데이터 gender 컬럼 수저시 제약조건 위반
UPDATE member m
   SET m.gender = 'N'
 WHERE m.member_id = 'M12'
; --->ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated

-- address가 NULL인 사람들의 주소를 '대전'으로 일괄 수정

UPDATE member m
   SET m.address = '대전'
 WHERE m.address  IS NULL
;
-- ORA-02290: check constraint (SCOTT.CK_MEMBER_GENDER) violated

-- 3) DELETE : 테이블에서 행단위로 데이터 삭제
-- 1. WHERE 조건이 있는 DELETE문

insert into member (member_id, member_name, phone, address, birth_month, gender) 
values ('M99', '채한나', '9492', '홍도동', 1, 'F');

commit;

DELETE member m
 WHERE m.gender = 'R'
 ;
 -- 0개 행 이(가) 삭제되었습니다.
 -- 이 결과는 gender에 R값이 없으므로 삭제된 행이 없는 결과를 얻은 것 뿐 구문오류 아님
 -- 논리적으로 잘못된 결과
 
 DELETE member m
 WHERE m.gender = 'F'
 ;
 -- 2개 행 이(가) 삭제되었습니다.
 -- WHERE 조건절을 만족하는 모든 행에 대해 삭제작업 진행
 
 -- 'M99'행을 삭제하고싶다면 PK로 삭제하자
DELETE member m
 WHERE m.member_id = 'M99'
;
-- 1 행 이(가) 삭제되었습니다.
commit;

-- WHERE조건을 아예 누락(생략)한 경우 전체행 삭제
DELETE member;
-- 13개 행 이(가) 삭제되었습니다.
rollback;

-- 3. DELETE의 WHERE절에 서브쿼리 조합
--    주소가 대전이 사람을 모두 삭제
-- (1) 주소가 대전인 사람을 조회
SELECT m.member_id
  FROM member m
 WHERE m.address = '대전'
;

DELETE member m
 WHERE m.member_id IN (SELECT m.member_id
                         FROM member m
                        WHERE m.address = '대전')
;
rollback;

-- 위와 동일한 작업을 일반 where로 삭제
DELETE member m
 WHERE m.address = '대전'
;
rollback;

------------------------------------------------------------
-- DELETE vs. TRUNCATE
/*
  1. TRUNCATE는 DDL에 속하는 명령어로 rollback지점이 없음.
     따라서 한번 실해된 DDL은 되돌릴 수 없음.
     
  2. TRUNCATE는 WHERE절 조합이 안되므로 특정 데이터를 선별하여 삭제할 수 없음.
  
  !@#@!사용시 주의!@#@!
*/

-- new_member테이블을 TRUNCATE로 날려보자
-- 실행 전 되돌아갈 커밋 지점 생성
commit;

-- new_member테이블 내용 확인
SELECT m.*
  FROM new_member m
;

--TURNCATE로 new_member테이블 잘라내기
TRUNCATE TABLE new_member;
-- Table NEW_MEMBER이(가) 잘렸습니다.

-- new_member테이블 내용 확인
SELECT m.*
  FROM new_member m
;

-- rollback 시도
rollback;
-- new_member테이블 내용 확인
SELECT m.*
  FROM new_member m
;
-- rollback 해도 돌아오지 않음
-- DDL종류의 구문은 생성 즉시 커밋이 이루어져서 DDL실행 이후로 롤백 시점이 잡힘 

----------------------------------------------------------------------------------------
-- TCL : Transaction Control Language
-- 1) COMMIT
-- 2) ROLLBACK
-- 3) SAVEPOINT
--  1. new_member테이블에 1행 추가
INSERT INTO new_member(member_id, member_name)
VALUES ('M01', '홍길동')
;
-- 1행 추가 상태까지 중간저장
SAVEPOINT do_insert; -- Savepoint이(가) 생성되었습니다.
--  2. '홍길동' 데이터의 주소를 수정
UPDATE new_member m
   SET m.address = '율도국'
 WHERE m.member_id = 'M01'
;
-- 주소 수정 상태까지 중간저장
SAVEPOINT do_update_addr; -- Savepoint이(가) 생성되었습니다.

--  3. '홍길동'데이터의 전화번호를 수정
UPDATE new_member m
   SET m.phone = '0001'
 WHERE m.member_id = 'M01'
;
-- 전화번로 수정 상태까지 중간저장
SAVEPOINT do_update_phone; -- Savepoint이(가) 생성되었습니다.

--  4. '홍길동'데이터의 성별을 수정
UPDATE new_member m
   SET m.gender = 'K'
 WHERE m.member_id = 'M01'
;
-- 성별 수정 상태까지 중간저장
SAVEPOINT do_update_gender; -- Savepoint이(가) 생성되었습니다.

------------------------------------------------------------
-- 홍길동 데이터의 ROLLBACK 사니리오
-- 1. 주소 수정까지는 맞는데 전화번호, 성별 수정은 잘못됨
-- : 되돌아기야할 SAVEPOINT = do_update_addr
ROLLBACK TO do_update_addr;
-- 2. 주소, 전화번호까지 수정이 맍고, 성별 수정이 잘못됨
ROLLBACK TO do_update_phone;
---> ORA-01086: savepoint 'DO_UPDATE_PHONE' never established in this session or is invalid
--              SAVEPOINT의 순서가 do_update_addr 다음이기 떄문에 do_update_addr까지 rollback하면 그 이후에 생성된 savepoint는 삭제됨
-- : 되돌아기야할 SAVEPOINT = do_update_phone
-- 앞의 수정구문 재 실행 후 다시 전화번호 수정까지 돌아감
ROLLBACK TO do_update_phone;

-- 3. 2번 수행 후 어디까지 롤백이 가능한가
ROLLBACK TO do_update_addr;
ROLLBACK TO do_insert;
ROLLBACK;
-- Savepoint로 한번 되돌아가면 되돌아간 시점 이후 생성된 SAVEPOINT는 무효화 됨

-----------------------------------------------------------------------------------------------------------

-- sequence
-- 1. 시작번호 :1, 최대 : 30, nocycle
CREATE SEQUENCE seq_member_id
START WITH 1
MAXVALUE 30
NOCYCLE
;
-- Sequence SEQ_MEMBER_ID이(가) 생성되었습니다.

-- 시퀀스가 생성되면 유저 딕셔너리에 정보가 저장됨 : user_sequences

SELECT s.sequence_name
     , s.min_value
     , s.max_value
     , s.cycle_flag
     , s.increment_by
  FROM user_sequences s
 WHERE s.sequence_name = 'SEQ_MEMBER_ID'
 ;
 -- SEQ_MEMBER_ID	1	30	N	1

-- 사용자의 객체가 저장되는 딕셔너리 테이블
-- user_objects
SELECT o.object_name
     , o.object_type
     , o.objent
  FROM user_objects u
;

/*------------------------------------------------
  메타 데이터를 저장하는 유저 딕셔너리
  
  무결성 제약조건 : user_constraints
  시퀀스 생성정보 : user_sequences
  태이블 생성정보 : user_table
  인덱스 생성종보 : usert_indexes
  객체들 생성정보 : user_objects
-----------------------------------------------*/

-- 2. 생성된 시퀀스 사용
-- 사용법 : 시퀀스이름.NEXTVAL

SELECT seq_member_id.NEXTVAL
  FROM dual;
  

SELECT 'M' || LPAD(seq_member_id.nextval, 2, 0) as member_id
  FROM dual;
  
------------------------------------------------------------------------

--INDEX : 데이터의 검색(조회)시 일저한 검색 속도를 보장하기 위해 DBMS가 관리하는 객체

-- 1. user_indexes딕셔너리에서 검색

SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes i
;

-- 2. 테이블의 주키(PK) 컬럼에 대해서는 이미 DBMS가 작동으로 인덱스 생성.
--    따라서 새로 생성 불가

-- 예) member테이블의 member_id컬럼에 인덱스 생성 시도
CREATE INDEX idx_member_id
ON member(member_id)
;
-- ORA-01408: such column list already indexed;
-- 테이블의 주키 컬럼에는 이미 있으므로 오류 발생
-- 생성하는 인덱스 이름이 달라도 생성할 수 없음.

-- 3. 복사한 테이블인 new_member에는 PK가 없으므로 인덱스도 없는 상태
--   (1) new_member 테이블에 index생성시도
CREATE INDEX idx_new_member_id
ON new_member(member_id)
;
-- Index IDX_NEW_MEMBER_ID이(가) 생성되었습니다.

SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes 
;
-- IDX_MEMBER_ID	NORMAL	NEW_MEMBER	SCOTT	

--   (2) 대상 컬럼이 중복 값이 없는 컬럼임이 확실하다면 UNIQUE 인덱스 생성이 가능
DROP INDEX idx_new_member_id;

CREATE UNIQUE INDEX idx_new_member_id
ON new_member(member_id)
;

SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes 
;
-- INDEX가 명시적으로 사용되는 경우
-- 오라클에 빠른 검색을 위해 HINT절을 SELECT에 사용하는 경우가 있다
