-- 남정규lab05

----------------------------------DML----------------------------------

-- 실습 1) customer 테이블에 데이터를 추가
--          regdate(등록일) 데이터는 레코드 추가 시점의 날짜 값을 자동 입력되도록
--          아이디, 이름, 생년, 등록일, 주소
--          C001, 김수현, 1988, sysdate, 경기
--          C002, 이효리, 1979, sysdate, 제주
--          C003, 원빈, 1977, sysdate, 강원

INSERT INTO customer (userid, name, birthyear, regdate, address)
VALUES ('C001', '김수현', 1988, sysdate, '경기');

INSERT INTO customer (userid, name, birthyear, regdate, address)
VALUES ('C002', '이효리', 1979, sysdate, '제주');

INSERT INTO customer (userid, name, birthyear, regdate, address)
VALUES ('C003', '원빈', 1977, sysdate, '강원');
/*
1 행 이(가) 삽입되었습니다.

1 행 이(가) 삽입되었습니다.

1 행 이(가) 삽입되었습니다.
*/

-- 실습 2) CUSTOMER테이블의 값 수정
--          C001의 이름, 생년을 차태현, 1976으로 변경
UPDATE customer c
   SET c.name = '차태현'
     , c.birthyear =1976
 WHERE c.userid = 'C001'
;
/*
1 행 이(가) 업데이트되었습니다.
*/

-- 실습 3)  모든 고객의 주소를 서울로 변경
UPDATE customer c
   SET c.address = '서울';
   
SELECT c.userid
     , c.name
     , c.birthyear
     , c.regdate
     , c.address
  FROM customer c
;
/*
3개 행 이(가) 업데이트되었습니다.
USERID, NAME, BIRTHYEAR, REGDATE, ADDRESS
-------------------------------------------------
C001	차태현	1976	18/07/09	서울
C002	이효리	1979	18/07/09	서울
C003	원빈	1977	18/07/09	서울
*/

-- 실습 4) customer 테이블의 값 삭제
--          아이디가 C003인 정보를 삭제
DELETE FROM customer c
 WHERE c.userid = 'C003'
;
/*
1 행 이(가) 삭제되었습니다.
*/

-- 실습 5) 전체 회원 정보를 삭제
DELETE FROM customer;
/*
2개 행 이(가) 삭제되었습니다.
*/

-- 실습 6) TURNCATE를 사용하여 customer 테이블의 데이터와 할당공간을 삭제
TRUNCATE TABLE customer;
/*
Table CUSTOMER이(가) 잘렸습니다.
*/


----------------------------시퀀스와 이덱스, 기타 객체--------------------------------

-- 실습 1) 시작번호가 1, 최대가 99까지 일련번호를 가지며 사이클이 없는 시퀀스를 생성하라
--          시퀀스의 이름은 seq_cust_userid로 지정한다.
CREATE SEQUENCE seq_cust_userid
START WITH 1
MAXVALUE 99
NOCYCLE
;
/*
Sequence SEQ_CUST_USERID이(가) 생성되었습니다.
*/

-- 실습 2) 앞서 생성한 seq_cust_userid의 정보를 USER_SEQUENCES 테이블에서 조회해보기
SELECT s.SEQUENCE_NAME
     , s.MIN_VALUE
     , s.MAX_VALUE
     , s.CYCLE_FLAG
     , s.INCREMENT_BY
  FROM user_sequences s
 WHERE s.SEQUENCE_NAME = 'SEQ_CUST_USERID'
;
/*
SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, CYCLE_FLAG, INCREMENT_BY
--------------------------------------------------------------
SEQ_CUST_USERID	1	99	N	1
*/

-- 실습 3) 고객테이블에서 userid 컬럼을 인덱스로 생성하고 인덱스 명을 idx_cust_userid로 할 것.
CREATE INDEX idx_cust_userid
ON customer (userid)
;
/*
Index IDX_CUST_USERID이(가) 생성되었습니다.
*/

-- 실습 4) USER_INDEXES 테이블의 구조 조회
--         USER_IND_COLUMNS 테이블 구조 조회
DESC user_indexes;
DESC user_ind_columns;
/*
이름                      널?       유형             
----------------------- -------- -------------- 
INDEX_NAME              NOT NULL VARCHAR2(30)   
INDEX_TYPE                       VARCHAR2(27)   
TABLE_OWNER             NOT NULL VARCHAR2(30)   
TABLE_NAME              NOT NULL VARCHAR2(30)   
TABLE_TYPE                       VARCHAR2(11)   
UNIQUENESS                       VARCHAR2(9)    
COMPRESSION                      VARCHAR2(8)    
PREFIX_LENGTH                    NUMBER         
TABLESPACE_NAME                  VARCHAR2(30)   
INI_TRANS                        NUMBER         
MAX_TRANS                        NUMBER         
INITIAL_EXTENT                   NUMBER         
NEXT_EXTENT                      NUMBER         
MIN_EXTENTS                      NUMBER         
MAX_EXTENTS                      NUMBER         
PCT_INCREASE                     NUMBER         
PCT_THRESHOLD                    NUMBER         
INCLUDE_COLUMN                   NUMBER         
FREELISTS                        NUMBER         
FREELIST_GROUPS                  NUMBER         
PCT_FREE                         NUMBER         
LOGGING                          VARCHAR2(3)    
BLEVEL                           NUMBER         
LEAF_BLOCKS                      NUMBER         
DISTINCT_KEYS                    NUMBER         
AVG_LEAF_BLOCKS_PER_KEY          NUMBER         
AVG_DATA_BLOCKS_PER_KEY          NUMBER         
CLUSTERING_FACTOR                NUMBER         
STATUS                           VARCHAR2(8)    
NUM_ROWS                         NUMBER         
SAMPLE_SIZE                      NUMBER         
LAST_ANALYZED                    DATE           
DEGREE                           VARCHAR2(40)   
INSTANCES                        VARCHAR2(40)   
PARTITIONED                      VARCHAR2(3)    
TEMPORARY                        VARCHAR2(1)    
GENERATED                        VARCHAR2(1)    
SECONDARY                        VARCHAR2(1)    
BUFFER_POOL                      VARCHAR2(7)    
FLASH_CACHE                      VARCHAR2(7)    
CELL_FLASH_CACHE                 VARCHAR2(7)    
USER_STATS                       VARCHAR2(3)    
DURATION                         VARCHAR2(15)   
PCT_DIRECT_ACCESS                NUMBER         
ITYP_OWNER                       VARCHAR2(30)   
ITYP_NAME                        VARCHAR2(30)   
PARAMETERS                       VARCHAR2(1000) 
GLOBAL_STATS                     VARCHAR2(3)    
DOMIDX_STATUS                    VARCHAR2(12)   
DOMIDX_OPSTATUS                  VARCHAR2(6)    
FUNCIDX_STATUS                   VARCHAR2(8)    
JOIN_INDEX                       VARCHAR2(3)    
IOT_REDUNDANT_PKEY_ELIM          VARCHAR2(3)    
DROPPED                          VARCHAR2(3)    
VISIBILITY                       VARCHAR2(9)    
DOMIDX_MANAGEMENT                VARCHAR2(14)   
SEGMENT_CREATED                  VARCHAR2(3)
--------------------------------------------------------------
이름              널? 유형             
--------------- -- -------------- 
INDEX_NAME         VARCHAR2(30)   
TABLE_NAME         VARCHAR2(30)   
COLUMN_NAME        VARCHAR2(4000) 
COLUMN_POSITION    NUMBER         
COLUMN_LENGTH      NUMBER         
CHAR_LENGTH        NUMBER         
DESCEND            VARCHAR2(4)    
*/

-- 실습 5) 생성한 idx_cust_userid 인덱스 정보를 USER_IDEXES 테이블에서 조회
SELECT i.INDEX_NAME
     , i.INDEX_TYPE
     , i.TABLE_NAME
     , i.TABLE_OWNER
     , i.INCLUDE_COLUMN
  FROM user_indexes i
 WHERE i.INDEX_NAME = 'IDX_CUST_USERID'
;  
/*
INDEX_NAME, INDEX_TYPE, TABLE_NAME, TABLE_OWNER, INCLUDE_COLUMN
--------------------------------------------------------------
IDX_CUST_USERID	NORMAL	CUSTOMER	SCOTT	
*/

-- 실습 6) 생성한 idx_cust_userid 인데스 정보를 USER_IND_COLUMNS 테이블에서 조회
SELECT i.INDEX_NAME
     , i.TABLE_NAME
     , i.COLUMN_NAME
     , i.COLUMN_POSITION
     , i.COLUMN_LENGTH
     , i.CHAR_LENGTH
     , i.DESCEND
  FROM user_ind_columns i
 WHERE i.INDEX_NAME = 'IDX_CUST_USERID'
;
/*
INDEX_NAME, TABLE_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND
--------------------------------------------------------------------------------------------
IDX_CUST_USERID	CUSTOMER	USERID	1	20	20	ASC
*/

-- 실습 7) 앞서 생성한 idx_cust_userid 인덱스를 삭제
DROP INDEX idx_cust_userid;
/*
Index IDX_CUST_USERID이(가) 삭제되었습니다.
*/

-- 실습 8) USER_IND_COLUMNS 테이블을 사용하여 idx_cust_userid 인덱스가 삭제되었는지 확인
SELECT i.INDEX_NAME
     , i.TABLE_NAME
     , i.COLUMN_NAME
     , i.COLUMN_POSITION
     , i.COLUMN_LENGTH
     , i.CHAR_LENGTH
     , i.DESCEND
  FROM user_ind_columns i
 WHERE i.INDEX_NAME = 'IDX_CUST_USERID'
;

-- 실습 9) customer 테이블에서 등급이 General인 고객의 userid, regdate 컬럼을 대상으로 VIEW를 생성
--          VIEW 이름 : v_cust_general_regdt
--          컬럼이름 : userid = 아이디, regdate = 등록일
INSERT INTO customer (userid, name, birthyear, regdate, address, grade)
VALUES ('C001', '김수현', 1988, sysdate, '경기', 'General');

CREATE OR REPLACE VIEW v_cust_general_regdt
AS
SELECT c.userid
     , c.regdate
  FROM customer c
 WHERE c.grade = 'General'
;
/*
View V_CUST_GENERAL_REGDT이(가) 생성되었습니다.
*/

-- 실습 10) 앞서 생성한 v_cust_general_redgt 뷰에서 전체 데이터를 조회
SELECT *
  FROM v_cust_general_regdt
;
/*
USERID, REGDATE
--------------------------------------------------------------
C001	18/07/09
*/

-- 실습 11) USER_VIEWS 테이블의 구조를 확인
DESC user_views;
/*
이름               널?       유형             
---------------- -------- -------------- 
VIEW_NAME        NOT NULL VARCHAR2(30)   
TEXT_LENGTH               NUMBER         
TEXT                      LONG           
TYPE_TEXT_LENGTH          NUMBER         
TYPE_TEXT                 VARCHAR2(4000) 
OID_TEXT_LENGTH           NUMBER         
OID_TEXT                  VARCHAR2(4000) 
VIEW_TYPE_OWNER           VARCHAR2(30)   
VIEW_TYPE                 VARCHAR2(30)   
SUPERVIEW_NAME            VARCHAR2(30)   
EDITIONING_VIEW           VARCHAR2(1)    
READ_ONLY                 VARCHAR2(1)    
*/

-- 실습 12) USER_VIEWS에서 view_name, text 컬럼을 조회
SELECT v.VIEW_NAME
     , v.TEXT
  FROM USER_VIEWS v
;
/*
VIEW_NAME, TEXT
--------------------------------------------------------------
V_CUST_GENERAL_REGDT	"SELECT c.userid, c.regdate FROM customer c WHERE c.grade = 'General'"
*/

-- 실습 13) v_cust_general_regdt VIEW를 삭제
DROP VIEW v_cust_general_regdt;
/*
View V_CUST_GENERAL_REGDT이(가) 삭제되었습니다.
*/

-- 실습 14) USER_VIEWS를 이용하여 삭제 여부 확인
SELECT v.VIEW_NAME
     , v.TEXT
  FROM USER_VIEWS v
 WHERE v.VIEW_NAME = 'V_CUST_GENERAL_REGDT'
;
