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
  
  PK는 전체 행에서 유이라혹, NOT NULL

*/